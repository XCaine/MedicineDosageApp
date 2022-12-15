import 'dart:convert';

import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/io/json_file_reader.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/code/providers/abstract_loader.dart';

import '../../../data_fetch/packaging_options_parser.dart';

class SampleMedicineLoader implements AbstractLoader<Medicine> {
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
    List<Medicine> medicineList = [];
    _logger.info('Creating Medicine instances');
    for(Map<String, dynamic> jsonInstance in data) {
      String packagingInfo = jsonInstance[Medicine.packagingFieldName];
      Map<String, dynamic> packages =
      PackagingOptionsParser(rawData: packagingInfo).parseToJson();
      String jsonEncodedPackages = jsonEncode(packages);
      jsonInstance[Medicine.packagingFieldName] = jsonEncodedPackages;
      Medicine instance = Medicine.fromJson(jsonInstance);
      medicineList.add(instance);
    }
    try {
      _logger.info('Inserting sample data to db');
      DatabaseFacade.medicineHandler.insertMedicineList(medicineList);
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