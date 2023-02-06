import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class RemoveMedication extends StatefulWidget {
  const RemoveMedication({Key? key}) : super(key: key);

  @override
  State<RemoveMedication> createState() => _RemoveMedicationState();
}

class _RemoveMedicationState extends State<RemoveMedication> {
  static final Logger _logger = LogDistributor.getLoggerFor("RemoveMedication");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Usuń lek'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: const Text('test'));
  }
}
