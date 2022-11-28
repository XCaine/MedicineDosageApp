import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DosageCalculatorResult extends StatefulWidget {
  const DosageCalculatorResult({Key? key, required this.searchWrapper}) : super(key: key);
  final DosageSearchWrapper searchWrapper;

  @override
  State<StatefulWidget> createState() => _DosageCalculatorResultState();
}

class _DosageCalculatorResultState extends State<DosageCalculatorResult> {
  final DatabaseBroker _dbHandler = DatabaseBroker();
  List<PackagingOption> _samplePackages = [];

  Future<void> _fetchSamplePackages() async {
    var db = await _dbHandler.database;
    var queryResult = await db.rawQuery(
      '''
      select * from ${PackagingOption.databaseName()}
      where ${PackagingOption.medicineIdFieldName} = ${widget.searchWrapper.selectedMedicine.id}
      '''
    );
    var samplePackages = queryResult.map((e) => PackagingOption.fromJson(e)).toList();

    setState(() {
      _samplePackages = samplePackages;
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: ListTile(
                    title: Text(widget.searchWrapper.selectedMedicine.commonlyUsedName),
                    subtitle: const Text('substancja aktywna'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: ListTile(
                    title: Text('${widget.searchWrapper.potency}'),
                    subtitle: const Text('wybrana moc'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: ListTile(
                    title: Text('${widget.searchWrapper.dosagesPerDay}'),
                    subtitle: const Text('ilość dawek na dzień'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: ListTile(
                    title: Text(DateFormat('dd.MM.yyyy').format(widget.searchWrapper.dateStart!)),
                    subtitle: const Text('początek dawkowania'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  child: ListTile(
                    title: Text(DateFormat('dd.MM.yyyy').format(widget.searchWrapper.dateEnd!)),
                    subtitle: const Text('koniec dawkowania'),
                  ),
                ),
                if (_samplePackages.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    child: ListTile(
                      title: Text(_samplePackages.map((e) => e.freeText).join('\n')),
                      subtitle: const Text('przykładowe warianty opakowań'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
