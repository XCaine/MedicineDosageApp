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
  static const int _numberOfResults = 3;

  DosageCalculator({required DosageSearchWrapper searchWrapper})
      :_searchWrapper = searchWrapper;

  Future<DosageResultSetWrapper> findMatchingPackageSets() async {
    Database db = await _dbHandler.database;
    var allPackages = await db.rawQuery('''
      SELECT p.* FROM ${PackagingOption.databaseName()} p 
      JOIN ${Medicine.databaseName()} m on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
      WHERE m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
    ''');
    var allMedicines = await db.rawQuery('''
      SELECT DISTINCT m.* FROM ${Medicine.databaseName()} m 
      JOIN ${PackagingOption.databaseName()} p on m.${RootDatabaseModel.idFieldName} = p.${PackagingOption.medicineIdFieldName}
      WHERE m.${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper.selectedMedicine.commonlyUsedName}'
    ''');
    List<PackagingOption> allMatchingPackageInstances = allPackages.map((package) => PackagingOption.fromJson(package)).toList();
    List<Medicine> allMatchingMedicines = allMedicines.map((medicine) => Medicine.fromJson(medicine)).toList();

    //skipping deduplication for now
    var seen = <int>{};
    var uniqueMatchingPackageInstances = allMatchingPackageInstances
        .where((package) => seen.add(package.count!))
        .toList();

    int target = _searchWrapper.dosagesPerDay! *
        (_searchWrapper.searchByDates ? _searchWrapper.dateEnd!.difference(_searchWrapper.dateStart!).inDays : _searchWrapper.numberOfDays!);
    List<int> packageCounts = uniqueMatchingPackageInstances.map((package) => package.count!).toList();

    List<List<int>> allOfferedOptions = DosageCalculationAlgorithm.apply(packageCounts, target);

    List<DosageResultSet> results = [];
    for(List<int> packagesForOption in allOfferedOptions) {
      //TODO change firstWhere to all instances of a matching package variant from either medicine (for each name)
      List<PackagingOption> packagesForResultWrapper = List.from(
          packagesForOption.map(
                  (singlePackageCount) => allMatchingPackageInstances
                      .firstWhere((instance) => instance.count! == singlePackageCount)
          )
      );
      List<Medicine> medicinesForResultWrapper = allMatchingMedicines.where(
              (medicine) => packagesForResultWrapper.any((package) => package.medicineId == medicine.id)
      ).toList();

      var resultWrapper = DosageResultSet(
          medicines: medicinesForResultWrapper,
          packages: packagesForResultWrapper,
          target: target
      );
      results.add(resultWrapper);
    }

    results.sort((a,b) => a.compareTo(b));
    DosageResultSetWrapper wrapper = DosageResultSetWrapper(
        packageVariants: packageCounts,
        resultSets: results.take(_numberOfResults).toList()
    );

    return wrapper;
  }
}