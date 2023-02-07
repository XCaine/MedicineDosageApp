import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/database/commons/drugs_in_database_verifier.dart';
import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/basic_medical_record.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/manage_medications_dao.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/modify_medication/modify_medication.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/no_drugs_in_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqlite_api.dart';

class ModifyMedicationSearch extends StatefulWidget {
  const ModifyMedicationSearch({Key? key}) : super(key: key);

  @override
  State<ModifyMedicationSearch> createState() => _ModifyMedicationSearchState();
}

enum _SearchMethod { byActiveSubstanceName, byProductName }

enum _MatchType { exact, flexible }

class _ModifyMedicationSearchState extends State<ModifyMedicationSearch> {
  static final Logger _logger = LogDistributor.getLoggerFor("ModifyMedication");
  final DatabaseBroker _dbHandler = DatabaseBroker();
  String _input = '';
  List<BasicMedicalRecord> _medicalRecords = [];
  bool _showFilters = false;
  bool _loading = false;
  bool _drugsPresentInDatabase = false;
  final _manageMedicationsDao = ManageMedicationsDao();
  late TextEditingController _textEditingController;

  _SearchMethod _searchMethod = _SearchMethod.byActiveSubstanceName;
  _MatchType _matchType = _MatchType.exact;

  void _searchForPrompts(String input) async {
    setState(() {
      _medicalRecords = [];
      _input = input;
      _loading = true;
    });
    if (_input.isNotEmpty) {
      Database db = _dbHandler.database;
      String sql = '''
      SELECT ${RootDatabaseModel.idFieldName}, 
        ${Medication.commonlyUsedNameFieldName},
        ${Medication.productNameFieldName} 
      FROM ${Medication.tableName()}
      WHERE ${_searchMethod == _SearchMethod.byProductName ? Medication.productNameFieldName : Medication.commonlyUsedNameFieldName}  
      LIKE ${_matchType == _MatchType.exact ? "'$input%'" : "'%$input%'"}
      LIMIT 30;
    ''';
      var queryResult = await db.rawQuery(sql);
      var instances = queryResult.map((e) => BasicMedicalRecord.fromJson(e));
      setState(() {
        _medicalRecords = instances.toList();
      });
    }

    setState(() {
      _loading = false;
    });
  }

  _checkIfThereAreDrugsInDatabase() async {
    bool drugsPresentInDatabase = await DrugsInDatabaseVerifier().anyDrugsInDatabase;
    setState(() {
      _drugsPresentInDatabase = drugsPresentInDatabase;
    });
  }

  void _onInputClear() {
    _textEditingController.clear();
    setState(() {
      _loading = false;
      _input = '';
      _medicalRecords = [];
    });
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _checkIfThereAreDrugsInDatabase();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void proceedToMedicationModification(BasicMedicalRecord medicalRecord) async {
    var medicationWithPackagesPair = await _manageMedicationsDao.getMedicationWithPackagesById(medicalRecord.id);
    var medication = medicationWithPackagesPair.first;
    var packages = medicationWithPackagesPair.second;
    if(medication != null && packages.isNotEmpty) {
      gotToModifyMedicationScreen(medication, packages);
    }

  }

  gotToModifyMedicationScreen(Medication medication, List<Package> packages) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ModifyMedication(
                medication: medication,
                packages: packages,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wyszukaj lek do zmiany'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        //drawer: const MainMenu(),
        body: _drugsPresentInDatabase
            ? Column(
                children: [
                  if (_showFilters)
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text('Sposób wyszukiwana', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                ListTile(
                                  dense: true,
                                  title: const Text('Po substancji czynnej'),
                                  leading: Radio(
                                    value: _SearchMethod.byActiveSubstanceName,
                                    groupValue: _searchMethod,
                                    onChanged: (e) => setState(() {
                                      _searchMethod = _searchMethod == _SearchMethod.byProductName
                                          ? _SearchMethod.byActiveSubstanceName
                                          : _SearchMethod.byProductName;
                                      _searchForPrompts(_input);
                                    }),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  title: const Text('Po nazwie produktu'),
                                  leading: Radio(
                                    value: _SearchMethod.byProductName,
                                    groupValue: _searchMethod,
                                    onChanged: (e) => setState(() {
                                      _searchMethod = _searchMethod == _SearchMethod.byProductName
                                          ? _SearchMethod.byActiveSubstanceName
                                          : _SearchMethod.byProductName;
                                      _searchForPrompts(_input);
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 2,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const ListTile(
                                  visualDensity: VisualDensity(vertical: -4),
                                  title: Text('Sposób dopasowania', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                ListTile(
                                    dense: true,
                                    title: const Text('Dokładne dopasowanie'),
                                    leading: Radio(
                                      value: _MatchType.exact,
                                      groupValue: _matchType,
                                      onChanged: (e) => setState(() {
                                        _matchType =
                                            _matchType == _MatchType.exact ? _MatchType.flexible : _MatchType.exact;
                                        _searchForPrompts(_input);
                                      }),
                                    )),
                                ListTile(
                                    dense: true,
                                    title: const Text('Elastyczne dopasowanie'),
                                    leading: Radio(
                                      value: _MatchType.flexible,
                                      groupValue: _matchType,
                                      onChanged: (e) => setState(() {
                                        _matchType =
                                            _matchType == _MatchType.exact ? _MatchType.flexible : _MatchType.exact;
                                        _searchForPrompts(_input);
                                      }),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText:
                              _searchMethod == _SearchMethod.byProductName ? "Nazwa produktu" : "Substancja czynna",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          prefixIcon: IconButton(
                              icon: _showFilters ? const Icon(Icons.filter_alt) : const Icon(Icons.filter_alt_outlined),
                              onPressed: () => setState(() => _showFilters = !_showFilters)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _onInputClear(),
                          )),
                      controller: _textEditingController,
                      onChanged: _searchForPrompts,
                    ),
                  ),
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!_loading && _medicalRecords.isNotEmpty)
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: ListTile(
                            title: Text(_medicalRecords[index].commonlyUsedName),
                            subtitle: Text(_medicalRecords[index].productName),
                            onTap: () => proceedToMedicationModification(_medicalRecords[index]),
                        ),
                      ),
                      itemCount: _medicalRecords.length,
                    )),
                ],
              )
            : const NoDrugsInDatabase());
  }
}
