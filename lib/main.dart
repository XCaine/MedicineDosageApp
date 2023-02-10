import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/material.dart';

import 'src/views/app.dart';

void main() {
  LogDistributor.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  //DB IS LOCATED IN data/data/com.pw.drugs_dosage_app/databases/medical_app_database.db
  DatabaseBroker.initialize();
  runApp(const RestartHandler(
    child: MedicalCalculatorApp(),
  ));
}

class RestartHandler extends StatefulWidget {
  static final _logger = LogDistributor.getLoggerFor('RestartHandler');

  const RestartHandler({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) async {
    _logger.warning('Restarting application');
    _logger.warning('Clearing all state');
    context.findAncestorStateOfType<_RestartHandlerState>()?.restartApp();
    _logger.warning('Recreating database');
    DatabaseBroker.dropExistingAndInitialize();
    _logger.warning('Restart complete');
  }

  @override
  State<RestartHandler> createState() => _RestartHandlerState();
}

class _RestartHandlerState extends State<RestartHandler> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
}
