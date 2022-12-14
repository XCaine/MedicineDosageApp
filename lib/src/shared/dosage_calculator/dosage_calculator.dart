import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_calculation_algorithm.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_result_set.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_result_set_wrapper.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/database/medicine.dart';

class DosageCalculator {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageCalculator');
  final DosageSearchWrapper _searchWrapper;
  final DatabaseBroker _dbHandler = DatabaseBroker();
  static const int _maxNumberOfResults = 5;

  DosageCalculator({required DosageSearchWrapper searchWrapper})
      :_searchWrapper = searchWrapper;

  Future<DosageResultSetWrapper> findMatchingPackageSets() async {
    Database db = await _dbHandler.database;
    var distinctMedicines = await db.rawQuery('''
      SELECT DISTINCT m.* FROM ${Medicine.databaseName()} m 
      JOIN ${PackagingOption.databaseName()} p on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
      WHERE m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
      AND m.${Medicine.potencyFieldName} = '${_searchWrapper.potency!}'
    ''');
    List<Medicine> feasibleMedicineInstances = distinctMedicines.map((medicine) => Medicine.fromJson(medicine)).toList();

    List<DosageResultSet> results = [];
    for(Medicine medicineInstance in feasibleMedicineInstances) {
      var allPackages = await db.rawQuery('''
        SELECT p.* FROM ${PackagingOption.databaseName()} p 
        JOIN ${Medicine.databaseName()} m on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
        WHERE m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
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
    }

    results.sort((a,b) => a.compareTo(b));
    DosageResultSetWrapper wrapper = DosageResultSetWrapper(
        resultSets: results.take(_maxNumberOfResults).toList()
    );

    return wrapper;
  }
}