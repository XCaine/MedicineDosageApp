import 'package:drugs_dosage_app/src/code/providers/medicine/impl/sample_medicine_loader.dart';
import 'package:flutter/material.dart';


class SampleMedicalDataButton extends StatefulWidget {
  const SampleMedicalDataButton({Key? key}) : super(key: key);

  @override
  State<SampleMedicalDataButton> createState() => _SampleMedicalDataButtonState();
}

class _SampleMedicalDataButtonState extends State<SampleMedicalDataButton> {

  void fetchSampleData() async {
    await SampleMedicineLoader().load();
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
