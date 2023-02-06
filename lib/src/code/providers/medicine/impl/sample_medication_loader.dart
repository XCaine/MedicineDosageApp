import 'dart:convert';

import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/io/json_file_reader.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_loader.dart';

import '../../../data_fetch/packages_parser.dart';

class SampleMedicationLoader implements AbstractLoader<Medication> {
  static final _logger = LogDistributor.getLoggerFor('SampleMedicineLoader');

  @override
  load({Function? onFinishCallback}) async {
    String filePath = 'resources/files/sample_medical_data.json';
    _logger.info('Reading medical data from file $filePath');
    List<dynamic> data = await JsonFileReader(filePath: filePath).read();
    if(data.isEmpty) {
      _logger.warning('Nothing was read from file $filePath');
      return;
    }
    List<Medication> medicineList = [];
    _logger.info('Creating Medicine instances');
    for(Map<String, dynamic> jsonInstance in data) {
      String packagingInfo = jsonInstance[Medication.packagingFieldName];
      Map<String, dynamic> packages =
      PackagesParser(rawData: packagingInfo).parseToJson();
      String jsonEncodedPackages = jsonEncode(packages);
      jsonInstance[Medication.packagingFieldName] = jsonEncodedPackages;
      Medication instance = Medication.fromJson(jsonInstance);
      medicineList.add(instance);
    }
    try {
      _logger.info('Inserting sample data to db');
      DatabaseFacade.medicineHandler.insertMedicineList(medicineList, custom: false);
      _logger.info('Finished loading sample records into database');
    } catch(e, stackTrace) {
      String msg = 'Could not load sample medicine data';
      _logger.severe(msg, e, stackTrace);
    }
    if(onFinishCallback != null) {
      onFinishCallback();
    }
  }
}