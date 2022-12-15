import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/views/settings/medical_data_fetch/medical_data_fetch_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
              onPressed: () => context.go(Constants.homeScreenRoute),
              icon: const Icon(Icons.home))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(
          children: const [
            MedicalDataButton(),
            //SampleMedicalDataButton(),
          ],
        ),
      ),
    );
  }
}
