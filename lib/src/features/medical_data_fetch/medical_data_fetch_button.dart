import 'package:csv/csv.dart';
import 'package:drugs_dosage_app/src/shared/classes/medicine.dart';
import 'package:drugs_dosage_app/src/shared/data_fetch/medicine_header_mapper.dart';
import 'package:drugs_dosage_app/src/shared/database/database_facade.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicalDataButton extends StatefulWidget {
  const MedicalDataButton({Key? key}) : super(key: key);

  @override
  State<MedicalDataButton> createState() => _MedicalDataButtonState();
}

class _MedicalDataButtonState extends State<MedicalDataButton> {
  final _dbClient = DatabaseFacade();
  final _apiUrl = 'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';

  fetchMedicalData() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load medical records');
    } else {
      List<List<dynamic>> decoded = const CsvToListConverter(
        fieldDelimiter: ';',
        eol: '\n',
      ).convert(response.body);

      List<List<dynamic>> instances = decoded.skip(1).toList();
      List<Medicine> medicineList = [];
      for (List<dynamic> instanceData in instances) {
        Medicine medicineInstance = ApiMedicineMapper().mapData(instanceData);
        medicineList.add(medicineInstance);
      }
      await _dbClient.insertMedicineList(medicineList);
      print('Loaded data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
        ),
        onPressed: fetchMedicalData,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.download),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: const Text('Fetch medical records'),
            ),
          ],
        ));
  }
}
