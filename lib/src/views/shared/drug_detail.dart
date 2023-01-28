import 'package:drugs_dosage_app/src/code/browser_file_launchers/pdf_launcher.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/custom_snack_bar.dart';
import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/file_download/file_download_facade.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/constants/drug_categories.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class DrugDetail extends StatefulWidget {
  const DrugDetail({Key? key, required this.medicine}) : super(key: key);
  final Medication medicine;

  @override
  State<StatefulWidget> createState() => _DrugDetailState();
}

class _DrugDetailState extends State<DrugDetail> {
  late Medication _medicine;
  final List<Package> _packages = [];
  String _drugCategoryDescription = '';
  final _dbHandler = DatabaseBroker();
  static final Logger _logger = LogDistributor.getLoggerFor('DrugDetail');

  void _loadPackageDetails() async {
    try {
      final db = _dbHandler.database;
      List<Map<String, dynamic>> rawPackages = await db.rawQuery(
          'select * from ${Package.tableName()} where ${Package.medicineIdFieldName} = ${_medicine.id}');
      List<Package> packageInstances = [];
      for (Map<String, Object?> package in rawPackages) {
        packageInstances.add(Package.fromJson(package));
      }
      setState(() {
        _packages.addAll(packageInstances);
        if (packageInstances.isNotEmpty) {
          _drugCategoryDescription = DrugCategories.categoryExplanationMap[packageInstances.first.category]!;
        }
      });
    } catch (e, stackTrace) {
      _logger.severe('Could not fetch package data from db for medicine ${_medicine.id}', e, stackTrace);
    }
  }

  void _launchPdf(String url) {
    PdfLauncher.launch(url);
  }

  void _downloadPdf(BuildContext context, String url, String docType) {
    _logger.info('Starting to download file from $url');
    String productNameWithNoWhitespaces = _medicine.productName.replaceAll(' ', '');
    String fileName = '${productNameWithNoWhitespaces}_$docType.pdf';

    showSnackBar() => CustomSnackBar.show(context, 'Zakończono ściąganie pliku\n $fileName');
    //FileDownloadFacade.startDownload(url, fileName, showSnackBar);
  }

  EdgeInsets _edgeInsetsForCards() => const EdgeInsets.symmetric(vertical: 2, horizontal: 6);

  Card _medicineInfoCard(String title, String subtitle) => Card(
        margin: _edgeInsetsForCards(),
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
    return Expanded(
      child: ListView(
        children: [
          _medicineInfoCard(_medicine.productName, 'nazwa produktu'),
          _medicineInfoCard(_medicine.commonlyUsedName, 'substancja czynna'),
          _medicineInfoCard(_drugCategoryDescription, 'kategoria leku'),
          _medicineInfoCard(_medicine.pharmaceuticalForm, 'forma farmaceutyczna'),
          if (_drugCategoryDescription.isNotEmpty) _medicineInfoCard(_medicine.potency, 'moc'),
          if (_packages.isNotEmpty) _medicineInfoCard(_packages.map((e) => e.rawCount).join(' '), 'dostępne warianty opakowań'),
          if (_medicine.flyer != null || _medicine.characteristics != null)
            Row(
              children: [
                if (_medicine.flyer != null)
                  Expanded(
                    flex: 6,
                    child: Card(
                      //margin: _edgeInsetsForCards(),
                      child: ListTile(
                          title: Row(
                        children: [
                          const Text('Pobierz\nulotkę'),
                          IconButton(
                              onPressed: () => _launchPdf(_medicine.flyer!),//_downloadPdf(context, _medicine.flyer!, 'ulotka'),
                              icon: const Icon(Icons.picture_as_pdf_sharp)),
                        ],
                      )),
                    ),
                  ),
                if (_medicine.characteristics != null)
                  Expanded(
                    flex: 8,
                    child: Card(
                      //margin: _edgeInsetsForCards(),
                      child: ListTile(
                          title: Row(
                        children: [
                          const Text('Pobierz\ncharakterystykę'),
                          IconButton(
                              onPressed: () => _launchPdf(_medicine.characteristics!),//_downloadPdf(context, _medicine.characteristics!, 'charakterystyka'),
                              icon: const Icon(Icons.picture_as_pdf_sharp)),
                        ],
                      )),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
