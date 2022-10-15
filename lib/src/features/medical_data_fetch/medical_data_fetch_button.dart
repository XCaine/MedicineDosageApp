import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared/classes/medicine.dart';
import '../../shared/database/database.dart';

class MedicalDataFetchButton extends StatefulWidget {
  const MedicalDataFetchButton({Key? key}) : super(key: key);

  @override
  State<MedicalDataFetchButton> createState() => _MedicalDataFetchButtonState();
}

class _MedicalDataFetchButtonState extends State<MedicalDataFetchButton> {
  final String url =
      'https://api.dane.gov.pl/resources/29618,wykaz-produktow-leczniczych-plik-w-formacie-csv/file';

  setData(http.Response response) {
    print('gotcha');
  }

  fetchMedicalData() async {
    //Future<http.Response> res = http.get(Uri.parse(url)).then((value) => setData(value));
    //print(res);

    DatabaseHandler handler = DatabaseHandler();

    // Create a Dog and add it to the dogs table
    var newDrug = const Medicine(
      productIdentifier: '100000014',
      productName: 'Zoledronic acid Fresenius Kabi',
    );

    await handler.insertMedicine(newDrug);

    // Now, use the method above to retrieve all the dogs.
    List<Medicine> results = await handler.fetchMedicine();
    print(results); // Prints a list that include Fido.

    // Update Fido's age and save it to the database.
    newDrug = Medicine(
      id: results.first.id,
      productIdentifier: '100000014',
      productName: 'Zoledronic acid Fresenius Kabi version2',
    );
    await handler.updateMedicine(newDrug);

    // Print the updated results.
    results = await handler.fetchMedicine();
    print(results); // Prints Fido with age 42.

    // Delete Fido from the database.
    await handler.deleteMedicine(results.first.id!);

    // Print the list of dogs (empty).
    print(await handler.fetchMedicine());
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
