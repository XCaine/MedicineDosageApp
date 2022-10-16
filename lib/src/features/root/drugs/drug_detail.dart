import 'package:flutter/material.dart';

import '../../../shared/classes/medicine.dart';

class DrugDetail extends StatelessWidget {
  const DrugDetail({Key? key, required this.medicine}) : super(key: key);

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły leku'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(medicine.productName),
                    subtitle: const Text('nazwa produktu'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(medicine.commonlyUsedName),
                    subtitle: const Text('substancja czynna'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(medicine.potency),
                    subtitle: const Text('moc'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(medicine.pharmaceuticalForm),
                    subtitle: const Text('forma farmaceutyczna'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    title: Text(medicine.packaging),
                    subtitle: const Text('opakowanie'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      /*body: ListView(
          children: [
            ListTile(
              title: Text(medicine.productIdentifier),
            ),
            ListTile(
              title: Text(medicine.productName),
            ),
            ListTile(
              title: Text(medicine.createTime.toString()),
            ),
          ],
        )*/
    );
  }
}
