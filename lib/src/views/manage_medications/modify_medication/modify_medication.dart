import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class ModifyMedication extends StatefulWidget {
  const ModifyMedication({Key? key}) : super(key: key);

  @override
  State<ModifyMedication> createState() => _ModifyMedicationState();
}

class _ModifyMedicationState extends State<ModifyMedication> {
  static final Logger _logger = LogDistributor.getLoggerFor("ModifyMedication");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Zmodyfikuj lek'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: Text('test'));
  }
}
