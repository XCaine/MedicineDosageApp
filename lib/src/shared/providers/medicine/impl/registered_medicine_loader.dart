import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drugs_dosage_app/src/shared/data_fetch/mappers/medicine_api_mapper.dart';
import 'package:drugs_dosage_app/src/shared/database/database_facade.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/providers/abstract_loader.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class RegisteredMedicineLoader implements AbstractLoader<Medicine> {
  final _apiUrl =
      'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';
  static final Logger _logger =
      LogDistributor.getLoggerFor('RegisteredMedicineLoader');

  @override
  load() async {
    http.Response? response;
    try {
      _logger.info('Started the load of medical data');
      http.Response response = await http.get(Uri.parse(_apiUrl));
    } catch(e, stackTrace) {
      _logger.severe('Could not fetch medical data via http', e, stackTrace);
    }
    if(response == null) {
      return;
    } else if (response.statusCode != 200) {
      _logger.warning('There was an error while fetching medical data from host');
      throw Exception('Failed to load medical records');
    } else {
      _logger.info('Decoding received response to utf8');
      String responseBodyString = utf8.decode(response.bodyBytes);

      _logger.info('Converting csv to list of values');
      List<List<dynamic>> decodedCsv = const CsvToListConverter(
        fieldDelimiter: ';',
        eol: '\n',
      ).convert(responseBodyString);

      List<dynamic> headerData = decodedCsv.first;

      ApiMedicineMapper medicineMapper = ApiMedicineMapper(incomingHeader: headerData);
      List<List<dynamic>> instances = decodedCsv.skip(1).toList();
      List<Medicine> medicineList = [];
      _logger.info('Beginning mapping of received data to DataModel objects');
      for (List<dynamic> instanceData in instances) {
        Medicine? medicineInstance = medicineMapper.map(instanceData);
        if(medicineInstance != null) {
          medicineList.add(medicineInstance);
        }
      }

      try {
        _logger.info('Inserting medical records into database');
        await DatabaseFacade.medicineHandler.insertMedicineList(medicineList);
        _logger.info('Loaded medical records into database');
        //TODO add table with metadata, and there specify that a load has already occurred with a flag
      } catch (e, stackTrace) {
        _logger.severe(
            'Failed to load medical data to database', e, stackTrace);
      }
    }
  }
}
