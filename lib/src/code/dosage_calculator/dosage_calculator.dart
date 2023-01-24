import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_calculation_algorithm.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_result_set.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_result_set_wrapper.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/code/models/dosage_search.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/database/medicine.dart';

enum DosageCalculatorMode {
  bestMatchesAcrossMultipleDrugs,
  bestMatchForEachDrug
}

class DosageCalculator {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageCalculator');
  final DosageSearchWrapper _searchWrapper;
  final DatabaseBroker _dbHandler = DatabaseBroker();
  static const int _maxNumberOfResults = 5;

  DosageCalculator({required DosageSearchWrapper searchWrapper})
      :_searchWrapper = searchWrapper;

  Future<DosageResultSetWrapper> findMatchingPackageSets(DosageCalculatorMode mode) async {
    Database db = _dbHandler.database;

    var distinctMedicines = await db.rawQuery('''
      SELECT DISTINCT m.* FROM ${Medicine.tableName()} m 
      JOIN ${PackagingOption.tableName()} p on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
      WHERE m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
      AND m.${Medicine.potencyFieldName} = '${_searchWrapper.potency!}'
    ''');
    List<Medicine> feasibleMedicineInstances = distinctMedicines.map((medicine) => Medicine.fromJson(medicine)).toList();

    List<DosageResultSet> results = [];
    for(Medicine medicineInstance in feasibleMedicineInstances) {
      try {
        var allPackages = await db.rawQuery('''
        SELECT p.* FROM ${PackagingOption.tableName()} p 
        JOIN ${Medicine.tableName()} m on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
        WHERE m.${RootDatabaseModel.idFieldName} = ${medicineInstance.id}
          AND m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
          AND m.${Medicine.potencyFieldName} = '${_searchWrapper.potency!}'
          AND m.${Medicine.productNameFieldName} = '${medicineInstance.productName}' 
      ''');
        List<PackagingOption> feasiblePackageInstances = allPackages.map((package) => PackagingOption.fromJson(package)).toList();

        //deduplication
        var seen = <int>{};
        var uniqueMatchingPackageInstances = feasiblePackageInstances
            .where((package) => seen.add(package.count!))
            .toList();

        int target = _searchWrapper.dosagesPerDay! *
            (_searchWrapper.searchByDates ? _searchWrapper.dateEnd!.difference(_searchWrapper.dateStart!).inDays : _searchWrapper.numberOfDays!);
        List<int> packageCounts = uniqueMatchingPackageInstances.map((package) => package.count!).toList();

        List<List<int>> allOfferedOptions = DosageCalculationAlgorithm.apply(packageCounts, target);

        for(List<int> packagesForOption in allOfferedOptions) {
          List<PackagingOption> packagesForResultWrapper = List.from(
              packagesForOption.map((singlePackageCount) => feasiblePackageInstances
                  .firstWhere((instance) => instance.count! == singlePackageCount && instance.medicineId == medicineInstance.id)
              )
          );
          var resultWrapper = DosageResultSet(
              medicine: medicineInstance,
              packages: packagesForResultWrapper,
              packageVariants: packageCounts,
              target: target
          );
          results.add(resultWrapper);
        }
      } catch(e, stackTrace) {
        _logger.severe('Failed to get proposed package variants for medicine ${medicineInstance.id}: ${medicineInstance.productName}', e, stackTrace);
      }

    }
    //TODO MAYBE RETAIN 3 best options from searchWrapper's medicine and 1 best option from each other drug
    results.sort((a,b) => a.compareTo(b));

    DosageResultSetWrapper wrapper;
    if(mode == DosageCalculatorMode.bestMatchForEachDrug) {
      //only retain one option per medicine name
      var deduplicationSet = <int>{};
      results.retainWhere((result) => deduplicationSet.add(result.medicine.id!));
      wrapper = DosageResultSetWrapper(
          resultSets: results
      );
    } else if(mode == DosageCalculatorMode.bestMatchesAcrossMultipleDrugs) {
      wrapper = DosageResultSetWrapper(
        resultSets: results.take(_maxNumberOfResults).toList()
      );
    } else {
      throw UnsupportedError('Mode not supported');
    }

    return wrapper;
  }
}