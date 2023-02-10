import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/views/shared/drug_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddMedicationConfirmation extends StatefulWidget {
  const AddMedicationConfirmation({Key? key, required this.medication}) : super(key: key);

  final Medication medication;

  @override
  State<AddMedicationConfirmation> createState() => _AddMedicationConfirmationState();
}

class _AddMedicationConfirmationState extends State<AddMedicationConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły leku'),
          automaticallyImplyLeading: false,
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: Card(
                    color: Colors.white70,
                    elevation: 1,
                    child: ListTile(
                      title: Text(
                        'Pomyślnie zapisano lek',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            DrugDetail(medicine: widget.medication)
          ],
        ));
  }
}
