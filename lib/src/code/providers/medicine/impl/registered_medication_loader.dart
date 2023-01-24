import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drugs_dosage_app/src/code/data_fetch/mappers/medication_api_mapper.dart';
import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_loader.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class RegisteredMedicationLoader implements AbstractLoader<Medication> {
  final _apiUrl = 'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';
  static final Logger _logger = LogDistributor.getLoggerFor('RegisteredMedicineLoader');

  @override
  load({Function? onFinishCallback}) async {
    _logger.info('Started the load of medical data');
    http.Response? response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode != 200) {
      _logger.warning('There was an error while fetching medical data from host');
      throw Exception('Failed to load medical records');
    }
    _logger.info('Decoding received response to utf8');
    String responseBodyString = utf8.decode(response.bodyBytes);

    _logger.info('Converting csv to list of values');
    List<List<dynamic>> decodedCsv = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(responseBodyString);

    List<dynamic> headerData = decodedCsv.first;

    ApiMedicationMapper medicineMapper = ApiMedicationMapper(incomingHeader: headerData);
    List<List<dynamic>> instances = decodedCsv.skip(1).toList();
    List<Medication> medicineList = [];
    _logger.info('Beginning mapping of received data to DataModel objects');
    for (List<dynamic> instanceData in instances) {
      Medication? medicineInstance = medicineMapper.map(instanceData);
      if (medicineInstance != null) {
        medicineList.add(medicineInstance);
      }
    }

    try {
      _logger.info('Inserting medical records into database');
      await DatabaseFacade.medicineHandler.insertMedicineList(medicineList);
      _logger.info('Loaded medical records into database');
      //TODO add table with metadata, and there specify that a load has already occurred with a flag
    } catch (e, stackTrace) {
      _logger.severe('Failed to load medical data to database', e, stackTrace);
    }

    if(onFinishCallback != null) {
      onFinishCallback();
    }
  }
}
