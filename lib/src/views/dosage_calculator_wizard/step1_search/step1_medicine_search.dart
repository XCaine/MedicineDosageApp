import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/views/dosage_calculator_wizard/step2_additional_info/step2_other_info.dart';
import 'package:drugs_dosage_app/src/code/database/database.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/basic_medical_record.dart';
import 'package:drugs_dosage_app/src/code/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/code/models/database/root_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../shared/widgets/no_drugs_in_database.dart';

class DosageCalculatorSearch extends StatefulWidget {
  const DosageCalculatorSearch({super.key});

  @override
  State<DosageCalculatorSearch> createState() => _DosageCalculatorSearchState();
}

class _DosageCalculatorSearchState extends State<DosageCalculatorSearch> {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageCalculatorSearch');
  final DatabaseBroker _dbHandler = DatabaseBroker();
  String _input = '';
  List<BasicMedicalRecord> _medicalRecords = [];
  bool _showFilters = false;
  bool _loading = false;
  bool _exactMatch = true;
  bool _searchByProductName = false;
  bool _drugsPresentInDatabase = false;
  late TextEditingController _textEditingController;

  void _searchForPrompts(String input) async {
    setState(() {
      _medicalRecords = [];
      _input = input;
      _loading = true;
    });
    if (_input.isNotEmpty) {
      Database db = await _dbHandler.database;
      String sqlForProductName = '''
        SELECT ${RootDatabaseModel.idFieldName}, 
        ${Medicine.commonlyUsedNameFieldName},
        ${Medicine.productNameFieldName} 
        FROM ${Medicine.databaseName()}
        WHERE ${Medicine.productNameFieldName}  
        LIKE ${_exactMatch ? "'$input%'" : "'%$input%'"}
        LIMIT 10;
      ''';
      String windowedSqlForActiveSubstance = '''
        SELECT ${RootDatabaseModel.idFieldName}, 
        ${Medicine.commonlyUsedNameFieldName},
        ${Medicine.productNameFieldName} 
        FROM (
          SELECT ${RootDatabaseModel.idFieldName}, ${Medicine.commonlyUsedNameFieldName}, ${Medicine.productNameFieldName},
          ROW_NUMBER() OVER (PARTITION BY  ${Medicine.commonlyUsedNameFieldName} ORDER BY ${RootDatabaseModel.idFieldName}) rn
          FROM ${Medicine.databaseName()}
          WHERE ${Medicine.commonlyUsedNameFieldName} LIKE ${_exactMatch ? "'$input%'" : "'%$input%'"}
        )
        where rn = 1
        LIMIT 10;
      ''';

      var queryResult = await db.rawQuery(_searchByProductName ? sqlForProductName : windowedSqlForActiveSubstance);
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
    Database db = await _dbHandler.database;
    String sql = 'select count(*) as count from ${Medicine.databaseName()}';
    var result = (await db.rawQuery(sql)).single;
    int count = result['count'] as int;
    setState(() {
      _drugsPresentInDatabase = count != 0;
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

  ListTile drugListTile(BasicMedicalRecord medicalRecord) {
    onListTileTap() => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DosageCalculatorOtherInfo(medicalRecord: medicalRecord)),
        );

    return _searchByProductName
        ? ListTile(
            title: Text(medicalRecord.productName),
            subtitle: Text(medicalRecord.commonlyUsedName),
            onTap: onListTileTap)
        : ListTile(
            title: Text(medicalRecord.commonlyUsedName),
            subtitle: Text('na przykład: ${medicalRecord.productName}'),
            onTap: onListTileTap,
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kalkulator leków - Wyszukaj lek'),
          actions: [
            IconButton(
                onPressed: () => context.go(Constants.homeScreenRoute),
                icon: const Icon(Icons.home))
          ],
        ),
        //drawer: const MainMenu(),
        body: _drugsPresentInDatabase
            ? Column(
                children: [
                  if (_showFilters)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Sposób wyszukiwania'),
                            Switch(
                                value: _searchByProductName,
                                onChanged: (e) => setState(
                                    () => {_searchByProductName = !_searchByProductName, _searchForPrompts(_input)})),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Dokładne dopasowanie',
                            ),
                            Switch(
                                value: _exactMatch,
                                onChanged: (e) =>
                                    setState(() => {_exactMatch = !_exactMatch, _searchForPrompts(_input)})),
                          ],
                        ),
                      ],
                    ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: _searchByProductName ? "Nazwa produktu" : "Substancja czynna",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
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
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!_loading && _medicalRecords.isNotEmpty)
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: drugListTile(_medicalRecords[index]),
                      ),
                      itemCount: _medicalRecords.length,
                    )),
                ],
              )
            : const NoDrugsInDatabase());
  }
}
