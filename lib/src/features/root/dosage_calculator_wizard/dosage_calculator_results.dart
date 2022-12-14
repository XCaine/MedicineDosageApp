import 'package:collection/collection.dart';
import 'package:drugs_dosage_app/src/features/root/dosage_calculator_wizard/shared/close_wizard_dialog.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_calculator.dart';
import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_result_set.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/database/medicine.dart';

class DosageCalculatorResult extends StatefulWidget {
  const DosageCalculatorResult({Key? key, required this.searchWrapper}) : super(key: key);
  final DosageSearchWrapper searchWrapper;

  @override
  State<StatefulWidget> createState() => _DosageCalculatorResultState();
}

class _DosageCalculatorResultState extends State<DosageCalculatorResult> {
  static final _logger = LogDistributor.getLoggerFor('DosageCalculatorResult');
  List<DosageResultSet> _dosageResultWrappers = [];

  bool _loading = false;

  Future<void> _fetchMatchingModels() async {
    setState(() {
      _loading = true;
    });
    var resultWrapper = await DosageCalculator(searchWrapper: widget.searchWrapper).findMatchingPackageSets();

    setState(() {
      _loading = false;
      _dosageResultWrappers = resultWrapper.resultSets;
    });
  }

  String _formatPackageModels(DosageResultSet model) {
    var countsMap = model.packages.fold<Map<int, int>>({}, (map, element) {
      int key = element.count!;
      map[key] = (map[key] ?? 0) + 1;
      return map;
    });
    var buffer = StringBuffer();
    buffer.write('Nazwa leku: ${model.medicine.productName}\n');
    buffer.write('Wszystkie warianty opakowań: (${model.packageVariants.join(',')})\n');
    for (var key in countsMap.keys) {
      buffer.write('Package variant $key; count ${countsMap[key]}\n');
    }
    buffer.write('DEBUG Total dosages offered ${model.packages.map((package) => package.count!).sum}\n');
    buffer.write('Redundancy factor: ${model.redundancyFactor}\n');
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
    _fetchMatchingModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki'),
        //should now be deterministic
        actions: [
          IconButton(
              onPressed: () => CloseWizardDialog.show(context),
              icon: const Icon(Icons.close))
        ],
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
                          'dosages per day ${widget.searchWrapper.dosagesPerDay}\n'
                          'dosages total: ${widget.searchWrapper.dosagesPerDay! * (widget.searchWrapper.searchByDates ? widget.searchWrapper.dateEnd!.difference(widget.searchWrapper.dateStart!).inDays : widget.searchWrapper.numberOfDays)!}\n',
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      child: ListTile(
                        title: Text(_formatPackageModels(_dosageResultWrappers[index])),
                      )),
                  itemCount: _dosageResultWrappers.length,
                )),
              ],
            ),
    );
  }
}
