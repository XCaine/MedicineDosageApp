import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class LogDistributor {
  static void initialize() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) => _onRecord(record));
  }

  static _onRecord(LogRecord record) {
    if (kDebugMode) {
      String msg = '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}';
      if (record.error != null) {
        msg = '$msg with Exception\n${record.error}\n${record.stackTrace}';
      }
      print(msg);
    }
  }

  static final Map<String, Logger> _cache = {};

  static Logger getLoggerFor(String className) {
    _cache.putIfAbsent(className, () => Logger(className));
    final logger = _cache[className];
    return logger!;
  }
}
