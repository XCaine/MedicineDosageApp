import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddMedicationConfirmation extends StatefulWidget {
  const AddMedicationConfirmation({Key? key}) : super(key: key);

  @override
  State<AddMedicationConfirmation> createState() => _AddMedicationConfirmationState();
}

class _AddMedicationConfirmationState extends State<AddMedicationConfirmation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dodaj lek'),
          actions: [
            IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))
          ],
        ),
        body: const Center(
          child: Card(
            child: Text(
              'Pomyślnie dodano leki',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
        )
    );
  }
}
