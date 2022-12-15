import 'package:collection/collection.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/shared/utility_string_formatter.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/step3_results/search_input_data_summary.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/shared/close_wizard_dialog.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_calculator.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_result_set.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/dosage_search.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/step4_result_details/step4_calculation_result_details.dart';
import 'package:flutter/material.dart';

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
    var resultWrapper = await DosageCalculator(searchWrapper: widget.searchWrapper)
        .findMatchingPackageSets(DosageCalculatorMode.bestMatchesAcrossMultipleDrugs);

    setState(() {
      _loading = false;
      _dosageResultWrappers = resultWrapper.resultSets;
    });
  }

  String _formatPackageModels(DosageResultSet model) {
    StringBuffer buffer = StringBuffer();
    buffer.write('Wybrane opakowania:\n');
    buffer.write(UtilityStringFormatter.formatPackageQuantities(model));
    if(model.redundancyFactor != 0) {
      buffer.write('Ten zestaw ma ${model.redundancyFactor} ${UtilityStringFormatter.formatDosageWord(model.redundancyFactor)} za dużo');
    } else {
      buffer.write('Ten zestaw nie ma nadmiarowych dawek');
    }

    return buffer.toString();
  }

  String _getTitle(DosageResultSet model) {
    return model.medicine.productName;
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
        actions: [
          IconButton(
              onPressed: () => CloseWizardDialog.show(
                  context, 'Czy na pewno chcesz wyjść?\nWprowadzone informacje nie zostaną zapisane'),
              icon: const Icon(Icons.home))
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SearchInputDataSummary(searchWrapper: widget.searchWrapper),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) => Card(
                    elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ListTile(
                              title: Text(_getTitle(_dosageResultWrappers[index])),
                              subtitle: Text(_formatPackageModels(_dosageResultWrappers[index])),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalculationResultDetails(
                                        resultModel: _dosageResultWrappers[index],
                                      )),
                                ),
                              )
                          )
                        ],
                      )),
                  itemCount: _dosageResultWrappers.length,
                )),
              ],
            ),
    );
  }
}
