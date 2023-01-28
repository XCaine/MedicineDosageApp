import 'package:drugs_dosage_app/src/code/io/abstract_file_reader.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

class CsvFileReader extends AbstractFileReader<String> {
  static final Logger _logger = LogDistributor.getLoggerFor('CsvFileReader');

  CsvFileReader({required super.filePath});

  @override
  Future<String> read() async {
    String csvFileContent = '';
    _logger.info('Loading data from file $filePath');
    try {
      csvFileContent = await rootBundle.loadString(filePath);
    } catch(e, stackTrace) {
      _logger.severe('Failed to load data from file $filePath', e, stackTrace);
    }
    return csvFileContent;
  }

}