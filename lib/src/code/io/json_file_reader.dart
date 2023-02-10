import 'dart:convert';

import 'package:drugs_dosage_app/src/code/io/abstract_file_reader.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class JsonFileReader extends AbstractFileReader<List<dynamic>> {
  static final Logger _logger = LogDistributor.getLoggerFor('JsonFileReader');

  JsonFileReader({required super.filePath});

  @override
  Future<List<dynamic>> read() async {
    List<dynamic> jsonMap = [];
    _logger.info('Loading data from file $filePath');
    try {
      String inputString = await rootBundle.loadString(filePath);
      jsonMap = jsonDecode(inputString);
    } catch (e, stackTrace) {
      _logger.severe('Failed to load data from file $filePath', e, stackTrace);
    }
    return jsonMap;
  }
}
