import 'package:flutter/material.dart';

import '../../medical_data_fetch/medical_data_fetch_button.dart';
import '../../medical_data_fetch/sample_data_fetch_button.dart';

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
      ),
      body: ListView(
        children: const [
          MedicalDataButton(),
          SampleMedicalDataButton(),
        ],
      ),
    );


    /*ListView(
      children: const [
        MedicalDataButton(),
        SampleMedicalDataButton(),
      ],
    );*/
  }
}
