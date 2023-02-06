import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:drugs_dosage_app/src/code/data_fetch/mappers/medication_api_mapper.dart';
import 'package:drugs_dosage_app/src/code/database/app_metadata_dao.dart';
import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/io/csv_file_reader.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_loader.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';

class RegisteredMedicationLoader implements AbstractLoader<Medication> {
  final _apiUrl = 'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';
  final _backupFilePath = 'resources/files/dane_medyczne_20230128.csv';

  static final Logger _logger = LogDistributor.getLoggerFor('RegisteredMedicineLoader');

  @override
  load({Function? onFinishCallback}) async {
    _logger.info('Started the load of medical data');
    String? csvContent;
    if(await InternetConnectionChecker().hasConnection) {
      try {
        http.Response response = await http
            .get(Uri.parse(_apiUrl))
            .timeout(const Duration(seconds: 60))
            .catchError((e){
              _logger.warning('Error during API call', e);
              throw Exception('Failed to load medical records');
            });
        if (response.statusCode != 200) {
          _logger.warning('Host indicated that there was an error while fetching medical data');
          throw Exception('Failed to load medical records');
        }
        _logger.info('Decoding received response to utf8');
        csvContent = utf8.decode(response.bodyBytes);
      } catch(e) {
        _logger.warning('Could not fetch up-to-date medical data from the server', e);
        _logger.info('Loading data from backup file');
        //open backup file
        csvContent = await CsvFileReader(filePath: _backupFilePath).read();
      }
    } else {
      _logger.warning('No internet connection');
      _logger.info('Loading data from backup file');
      csvContent = await CsvFileReader(filePath: _backupFilePath).read();
    }

    _logger.info('Converting csv to list of values');
    List<List<dynamic>> decodedCsv = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(csvContent);

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
      await DatabaseFacade.medicineHandler.insertMedicineList(medicineList, custom: false);
      AppMetadataDao().setInitialLoadStatus(newStatus: true);
      _logger.info('Loaded medical records into database');
    } catch (e, stackTrace) {
      _logger.severe('Failed to load medical data to database', e, stackTrace);
    }

    if(onFinishCallback != null) {
      onFinishCallback();
    }
  }
}
