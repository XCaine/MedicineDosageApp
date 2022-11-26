import 'package:drugs_dosage_app/src/shared/database/database_facade.dart';
import 'package:drugs_dosage_app/src/shared/io/json_file_reader.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:drugs_dosage_app/src/shared/providers/abstract_medicine_provider.dart';

class SampleMedicineProvider implements AbstractMedicineProvider {
  final DatabaseFacade _dbClient;
  static final _logger = LogDistributor.getLoggerFor('SampleMedicineProvider');

  SampleMedicineProvider() :
        _dbClient = DatabaseFacade();

  @override
  loadMedicalData() async {
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
      Medicine instance = Medicine.fromJson(jsonInstance);
      medicineList.add(instance);
    }
    try {
      _logger.info('Inserting sample data to db');
      _dbClient.medicineHandler.insertMedicineList(medicineList);
      _logger.info('Finished loading sample records into database');
    } catch(e, stackTrace) {
      String msg = 'Could not load sample medicine data';
      _logger.severe(msg, e, stackTrace);
    }

  }
}