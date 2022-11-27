import 'package:drugs_dosage_app/src/features/root/dosage_calculator/dosage_calculator_other_info.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/basic_medical_record.dart';
import 'package:drugs_dosage_app/src/shared/models/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/root_model.dart';
import 'package:drugs_dosage_app/src/shared/views/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../shared/database/database.dart';

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
  bool _exactMatch = false;
  bool _searchByProductName = false;
  late TextEditingController _textEditingController;

  void _searchForPrompts(String input) async {
    setState(() {
      _medicalRecords = [];
      _input = input;
      _loading = true;
    });
    if(_input.isNotEmpty) {
      Database db = await _dbHandler.database;
      String sql = '''
      SELECT ${RootDatabaseModel.idFieldName}, 
        ${Medicine.commonlyUsedNameFieldName},
        ${Medicine.productNameFieldName} 
      FROM ${Medicine.databaseName()}
      WHERE ${_searchByProductName ? Medicine.productNameFieldName : Medicine.commonlyUsedNameFieldName}  
      LIKE ${_exactMatch ? "'$input%'" : "'%$input%'"}
      LIMIT 10;
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
          title: const Text('Wyszukaj lek'),
        ),
        drawer: const MainMenu(),
        body: Column(
          children: [
            if(_showFilters)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                          'Dokładne dopasowanie',
                      ),
                      Switch(
                          value: _exactMatch,
                          onChanged: (e) => setState(() => {
                            _exactMatch = !_exactMatch,
                            _searchForPrompts(_input)
                          })
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Sposób wyszukiwania'),
                      Switch(
                          value: _searchByProductName,
                          onChanged: (e) => setState(() => {
                            _searchByProductName = !_searchByProductName,
                            _searchForPrompts(_input)
                          })
                      ),
                    ],
                  ),
                ],
              ),
            TextField(
                decoration: InputDecoration(
                    hintText: _searchByProductName ? "Nazwa produktu" : "Substancja czynna",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    prefixIcon: IconButton(
                        icon: _showFilters ? const Icon(Icons.filter_alt) : const Icon(Icons.filter_alt_outlined),
                        onPressed: () => setState(() => _showFilters = !_showFilters)
                    ),
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
                  child: ListTile(
                    title: Text(_medicalRecords[index].commonlyUsedName),
                    subtitle: Text(_medicalRecords[index].productName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DosageCalculatorOtherInfo(medicalRecord: _medicalRecords[index])
                        ),
                      );
                    },
                  ),
                ),
                itemCount: _medicalRecords.length,
              )),
          ],
        ));
  }
}
