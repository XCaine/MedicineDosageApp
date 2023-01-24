import 'package:drugs_dosage_app/src/views/shared/widgets/custom_snack_bar.dart';
import 'package:drugs_dosage_app/src/code/providers/medicine/impl/registered_medication_loader.dart';
import 'package:flutter/material.dart';

class MedicalDataButton extends StatefulWidget {
  const MedicalDataButton({Key? key}) : super(key: key);

  @override
  State<MedicalDataButton> createState() => _MedicalDataButtonState();
}

class _MedicalDataButtonState extends State<MedicalDataButton> {
  bool _loading = false;

  void _fetchMedicalData(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    showSnackBar() => CustomSnackBar.show(context, 'Zakończono ładowanie danych medycznych');
    await RegisteredMedicationLoader().load(onFinishCallback: () => showSnackBar());
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
            ),
            onPressed: () => _fetchMedicalData(context),
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
