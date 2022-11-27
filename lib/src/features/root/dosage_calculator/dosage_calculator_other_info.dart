import 'package:drugs_dosage_app/src/shared/models/basic_medical_record.dart';
import 'package:flutter/material.dart';

class DosageCalculatorOtherInfo extends StatefulWidget {
  const DosageCalculatorOtherInfo({super.key, required this.medicalRecord});

  final BasicMedicalRecord medicalRecord;

  @override
  State<DosageCalculatorOtherInfo> createState() => _DosageCalculatorOtherInfoState();
}

class _DosageCalculatorOtherInfoState extends State<DosageCalculatorOtherInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wypełnij szczegóły'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(widget.medicalRecord.productName),
                    subtitle: const Text('nazwa produktu'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(widget.medicalRecord.commonlyUsedName),
                    subtitle: const Text('substancja czynna'),
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