import 'package:drugs_dosage_app/src/shared/database/database_facade.dart';
import 'package:drugs_dosage_app/src/shared/providers/sample_medicine_provider.dart';
import 'package:flutter/material.dart';

import '../../shared/classes/medicine.dart';

class SampleMedicalDataButton extends StatefulWidget {
  const SampleMedicalDataButton({Key? key}) : super(key: key);

  @override
  State<SampleMedicalDataButton> createState() => _SampleMedicalDataButtonState();
}

class _SampleMedicalDataButtonState extends State<SampleMedicalDataButton> {
  final DatabaseFacade _dbClient = DatabaseFacade();

  void fetchSampleData() {
    List<Medicine> medicineList = SampleMedicineProvider().data;
    _dbClient.insertMedicineList(medicineList);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
        ),
        onPressed: fetchSampleData,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.download),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Text('Fetch sample medical records'),
            ),
          ],
        ));
  }
}
