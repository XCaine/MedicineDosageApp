import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:drugs_dosage_app/src/shared/util/drug_category_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DrugDetail extends StatefulWidget {
  const DrugDetail({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  @override
  State<StatefulWidget> createState() => _DrugDetailState();
}

class _DrugDetailState extends State<DrugDetail> {
  late Medicine _medicine;
  final List<PackagingOption> _packages = [];
  String _drugCategoryDescription = '';
  final _dbHandler = DatabaseBroker();
  static final Logger _logger = LogDistributor.getLoggerFor('DrugDetail');

  void _loadPackageDetails() async {
    try {
      final db = await _dbHandler.database;
      List<Map<String, dynamic>> rawPackages = await db.rawQuery(
          'select * from ${PackagingOption.databaseName()} where ${PackagingOption.medicineIdFieldName} = ${_medicine.id}');
      List<PackagingOption> packageInstances = [];
      for (Map<String, Object?> package in rawPackages) {
        packageInstances.add(PackagingOption.fromJson(package));
      }
      setState(() {
        _packages.addAll(packageInstances);
        if (packageInstances.isNotEmpty) {
          _drugCategoryDescription = DrugCategoryUtil.categoryExplanationMap[packageInstances.first.category]!;
        }
      });
    } catch (e, stackTrace) {
      _logger.severe('Could not fetch package data from db for medicine ${_medicine.id}', e, stackTrace);
    }
  }

  EdgeInsets edgeInsetsForCards() => const EdgeInsets.symmetric(vertical: 2, horizontal: 6);

  Card medicineInfoCard(String title, String subtitle) => Card(
    margin: edgeInsetsForCards(),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    ),
  );

  @override
  void initState() {
    super.initState();
    _medicine = widget.medicine;
    _loadPackageDetails();
  }

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
                medicineInfoCard(_medicine.productName, 'nazwa produktu'),
                medicineInfoCard(_medicine.commonlyUsedName, 'substancja czynna'),
                medicineInfoCard(_drugCategoryDescription, 'kategoria leku'),
                medicineInfoCard(_medicine.pharmaceuticalForm, 'forma farmaceutyczna'),
                if (_drugCategoryDescription.isNotEmpty)
                  medicineInfoCard(_medicine.potency, 'moc'),
                if(_packages.isNotEmpty)
                  medicineInfoCard(_packages.map((e) => e.rawCount).join('\n'), 'warianty opakowań'),
                if(_medicine.flyer != null)
                  Text(_medicine.flyer!),
                if(_medicine.characteristics != null)
                  Text(_medicine.characteristics!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*class DrugDetail extends StatelessWidget {
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
    );
  }
}*/
/*
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _packages.length,
                  itemBuilder: (context, index) => {
                    SizedBox(
                      width: MediaQuery.of(context).size.width * _packages.length,
                      child: const ListTile(title: Text((_packages[index]).freeText))
                    )
    },
                    ),
* */
