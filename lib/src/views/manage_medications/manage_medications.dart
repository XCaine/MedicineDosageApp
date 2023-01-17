import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/no_drugs_in_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageMedications extends StatefulWidget {
  const ManageMedications({Key? key}) : super(key: key);

  @override
  State<ManageMedications> createState() => _ManageMedicationsState();
}

class _ManageMedicationsState extends State<ManageMedications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Zarządzanie lekami'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: const NoDrugsInDatabase());
  }
}
