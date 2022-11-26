import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drugs_dosage_app/src/shared/data_fetch/medicine_api_mapper.dart';
import 'package:drugs_dosage_app/src/shared/database/database_facade.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:drugs_dosage_app/src/shared/providers/abstract_medicine_provider.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class RegisteredMedicineProvider implements AbstractMedicineProvider {
  final _apiUrl =
      'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';
  final DatabaseFacade _dbClient;
  static final Logger _logger =
      LogDistributor.getLoggerFor('RegisteredMedicineProvider');

  RegisteredMedicineProvider() : _dbClient = DatabaseFacade();

  @override
  loadMedicalData() async {
    _logger.info('Started the load of medical data');
    http.Response response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode != 200) {
      _logger.warning('Fetching medical data from URL was unsuccessful');
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

      ApiMedicineMapper mapper = ApiMedicineMapper(incomingHeader: headerData);
      List<List<dynamic>> instances = decodedCsv.skip(1).toList();
      List<Medicine> medicineList = [];
      _logger.info('Beginning mapping of received data to DataModel objects');
      for (List<dynamic> instanceData in instances) {
        Medicine? medicineInstance = mapper.mapData(instanceData);
        if(medicineInstance != null) {
          medicineList.add(medicineInstance);
        }
      }

      try {
        _logger.info('Inserting medical records into database');
        await _dbClient.medicineHandler.insertMedicineList(medicineList);
        _logger.info('Loaded medical records into database');
      } catch (e, stackTrace) {
        _logger.severe(
            'Failed to load medical data to database', e, stackTrace);
      }
    }
  }
}
