import 'dart:convert';

import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class JsonFileReader {
  final String filePath;
  static final Logger _logger = LogDistributor.getLoggerFor('JsonFileReader');

  JsonFileReader({required this.filePath});

  Future<List<dynamic>> read() async {
    List<dynamic> jsonMap = [];
    try {
      String inputString = await rootBundle.loadString(filePath);
      jsonMap = jsonDecode(inputString);
    } catch(e, stackTrace) {
      _logger.severe('Failed to load data from file $filePath', e, stackTrace);
    }
    return jsonMap;
  }
}