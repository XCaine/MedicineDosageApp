import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/database/commons/drugs_in_database_verifier.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/modify_medication/modify_medication.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/remove_medication/remove_medication.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/no_drugs_in_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class ManageMedications extends StatefulWidget {
  const ManageMedications({Key? key}) : super(key: key);

  @override
  State<ManageMedications> createState() => _ManageMedicationsState();
}

class _ManageMedicationsState extends State<ManageMedications> {
  static final Logger _logger = LogDistributor.getLoggerFor('ManageMedications');
  bool _drugsPresentInDatabase = false;

  _checkIfThereAreDrugsInDatabase() async {
    bool drugsPresentInDatabase = await DrugsInDatabaseVerifier().anyDrugsInDatabase;
    setState(() {
      _drugsPresentInDatabase = drugsPresentInDatabase;
    });
  }

  @override
  void initState() {
    _checkIfThereAreDrugsInDatabase();
    super.initState();
  }

  GestureDetector medicationAdministrationOption(String title, IconData iconData, StatefulWidget targetWidget) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetWidget)),
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              Expanded(flex: 1, child: Icon(iconData, size: 24))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Zarządzanie lekami'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: _drugsPresentInDatabase
            ? ListView(
                children: [
                  medicationAdministrationOption('Dodaj lek', Icons.add, const AddMedication()),
                  if(_drugsPresentInDatabase) medicationAdministrationOption('Usuń lek', Icons.remove, const RemoveMedication()),
                  if(_drugsPresentInDatabase) medicationAdministrationOption('Zmodyfikuj lek', Icons.edit, const ModifyMedication()),
                ],
              )
            : const NoDrugsInDatabase());
  }
}
