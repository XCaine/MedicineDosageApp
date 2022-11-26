import 'package:drugs_dosage_app/src/shared/providers/impl/registered_medicine_provider.dart';
import 'package:flutter/material.dart';

class MedicalDataButton extends StatefulWidget {
  const MedicalDataButton({Key? key}) : super(key: key);

  @override
  State<MedicalDataButton> createState() => _MedicalDataButtonState();
}

class _MedicalDataButtonState extends State<MedicalDataButton> {

  void fetchMedicalData() async {
    await RegisteredMedicineProvider().loadMedicalData();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
        ),
        onPressed: fetchMedicalData,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.download),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Text('Fetch medical records'),
            ),
          ],
        ));
  }
}
