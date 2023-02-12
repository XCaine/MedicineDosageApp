import 'package:drugs_dosage_app/main.dart';
import 'package:drugs_dosage_app/src/code/browser_file_launchers/pdf_launcher.dart';
import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/data_fetch/loaders/impl/registered_medication_loader.dart';
import 'package:drugs_dosage_app/src/code/database/app_metadata_dao.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/shared/close_wizard_dialog.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool loading = false;
  var appMetadataDao = AppMetadataDao();
  String _dataLoadingMessage = 'Ładujemy dane';

  void setDataLoadingMessageCallback(String newMessage) {
    setState(() {
      _dataLoadingMessage = newMessage;
    });
  }

  set dataLoadingMessage(String newMessage) {
    dataLoadingMessage = newMessage;
  }

  bool initialLoadDone = true;

  void _fetchMedicalData(BuildContext context) async {
    setState(() {
      loading = true;
    });
    showSnackBar() => CustomSnackBar.show(context, 'Zakończono ładowanie danych medycznych');
    await RegisteredMedicationLoader()
        .load(onFinishCallback: () => showSnackBar(), setMessageOnProgress: setDataLoadingMessageCallback);
    setState(() {
      loading = false;
      initialLoadDone = true;
    });
  }

  void triggerAppRestart() {
    CloseWizardDialog.show(context, 'Czy na pewno chcesz usunąć wszystkie dane z aplikacji?', 'Tak, usuń dane',
        () => RestartHandler.restartApp(context));
  }

  @override
  void initState() {
    super.initState();
    verifyIfInitialLoadIsDone();
  }

  void verifyIfInitialLoadIsDone() async {
    var loadAlreadyDone = await appMetadataDao.initialLoadDone;
    setState(() {
      initialLoadDone = loadAlreadyDone;
    });
  }

  void _launchBrowserWithMedicalData() {
    PdfLauncher.launch(Constants.sourceMedicationsFileAddress);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ustawienia'),
          actions: loading
              ? []
              : [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: loading
            ? Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 50),
                  Text(
                    _dataLoadingMessage,
                    style: const TextStyle(fontSize: 24),
                  )
                ]),
              )
            : Column(
                children: [
                  if (!initialLoadDone)
                    GestureDetector(
                      onTap: () => _fetchMedicalData(context),
                      child: Card(
                        color: Colors.green[300],
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: SizedBox(
                          height: 100,
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 4,
                                child: ListTile(
                                  title: Text(
                                    'Pobierz aktualne dane medyczne',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              Expanded(flex: 1, child: Icon(Icons.download, size: 24))
                            ],
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () => triggerAppRestart(),
                    child: Card(
                      color: Colors.red[300],
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 4,
                              child: ListTile(
                                title: Text(
                                  'Usuń wszystkie dane',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            Expanded(flex: 1, child: Icon(Icons.clear, size: 24))
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _launchBrowserWithMedicalData(),
                    child: Card(
                      color: Colors.yellow[300],
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 4,
                              child: ListTile(
                                title: Text(
                                  'Pobierz plik z danymi medycznymi \n(źródło - dane.gov.pl)',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            Expanded(flex: 1, child: Icon(Icons.download, size: 24))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
