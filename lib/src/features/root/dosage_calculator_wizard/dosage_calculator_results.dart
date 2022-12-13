import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_calculator.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_result_wrapper.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:flutter/material.dart';

class DosageCalculatorResult extends StatefulWidget {
  const DosageCalculatorResult({Key? key, required this.searchWrapper}) : super(key: key);
  final DosageSearchWrapper searchWrapper;

  @override
  State<StatefulWidget> createState() => _DosageCalculatorResultState();
}

class _DosageCalculatorResultState extends State<DosageCalculatorResult> {
  final DatabaseBroker _dbHandler = DatabaseBroker();
  List<DosageResultWrapper> _dosageResultWrappers = [];

  static const int _maxResultsCount = 50;
  bool _loading = false;

  Future<void> _fetchSamplePackages() async {
    setState(() {
      _loading = true;
    });

    var db = await _dbHandler.database;
    var packageFactorModels = await DosageCalculator(searchWrapper: widget.searchWrapper).findMatchingPackages();

    List<DosageResultWrapper> results = [];
/*    for (PackageMatchFactorModel packageFactorModel in packageFactorModels) {
      var queryResult = await db.rawQuery('''
        SELECT m.* FROM ${Medicine.databaseName()} m
        JOIN ${PackagingOption.databaseName()} p on p.${PackagingOption.medicineIdFieldName} = m.${RootDatabaseModel.idFieldName}
        WHERE p.${RootDatabaseModel.idFieldName} = ${packageFactorModel.relatedPackage.id}
      ''');
      var medicine = Medicine.fromJson(queryResult.single);
      results.add(DosageResultWrapper(medicine: medicine, packageFactorModel: packageFactorModel));
    }*/

    setState(() {
      _loading = false;
      _dosageResultWrappers = results.take(_maxResultsCount).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSamplePackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki'),
        actions: [IconButton(onPressed: _fetchSamplePackages, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Text(
                          'You searched for ${widget.searchWrapper.selectedMedicine.commonlyUsedName}\n'
                          'potency ${widget.searchWrapper.selectedMedicine.potency}\n'
                          'number of days ${widget.searchWrapper.searchByDates ? widget.searchWrapper.dateEnd!.difference(widget.searchWrapper.dateStart!).inDays : widget.searchWrapper.numberOfDays}\n'
                          'dosages per day ${widget.searchWrapper.dosagesPerDay}\n',
                        ),
                      ),
                    ),
                  ],
                ),
                /*Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: ListTile(
                        title: Text(_dosageResultWrappers[index].medicine.productName),
                        subtitle: Text(_dosageResultWrappers[index].packageFactorModel.relatedPackage.rawCount)),
                  ),
                  itemCount: _dosageResultWrappers.length,
                )),*/
              ],
            ),
    );
  }
}
