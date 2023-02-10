import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_result_set.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/shared/utility_string_formatter.dart';
import 'package:drugs_dosage_app/src/views/shared/drug_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalculationResultDetails extends StatefulWidget {
  const CalculationResultDetails({Key? key, required this.resultModel}) : super(key: key);

  final DosageResultSet resultModel;

  @override
  State<StatefulWidget> createState() => _CalculationResultDetailsState();
}

class _CalculationResultDetailsState extends State<CalculationResultDetails> {
  String _getFormattedChosenPackages() {
    return UtilityStringFormatter.formatPackageQuantities(widget.resultModel, trimLastNewLine: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wyniki'),
        actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: ListTile(
                    title: Text(_getFormattedChosenPackages()),
                    subtitle: const Text('wybrane opakowania'),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: ListTile(
                    title: Center(child: Text('${widget.resultModel.target}')),
                    subtitle: const Text('całkowita liczba dawek'),
                  ),
                ),
              ),
            ],
          ),
          DrugDetail(medicine: widget.resultModel.medicine)
        ],
      ),
    );
  }
}
