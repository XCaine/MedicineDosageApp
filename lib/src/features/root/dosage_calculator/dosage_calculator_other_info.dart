import 'package:drugs_dosage_app/src/features/root/dosage_calculator/other_info_form_handler.dart';
import 'package:drugs_dosage_app/src/shared/database/database.dart';
import 'package:drugs_dosage_app/src/shared/models/basic_medical_record.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/dosage_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DosageCalculatorOtherInfo extends StatefulWidget {
  const DosageCalculatorOtherInfo({super.key, required this.medicalRecord});

  final BasicMedicalRecord medicalRecord;

  @override
  State<DosageCalculatorOtherInfo> createState() => _DosageCalculatorOtherInfoState();
}

class _DosageCalculatorOtherInfoState extends State<DosageCalculatorOtherInfo> {
  final DatabaseBroker _dbHandler = DatabaseBroker();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _potencyTextController;
  late final TextEditingController _firstDateController;
  late final TextEditingController _lastDateController;
  late final OtherInfoFormHandler _formHandler;
  DosageSearchWrapper? _searchWrapper;

  @override
  void initState() {
    _formHandler = OtherInfoFormHandler(key: _formKey);
    _potencyTextController = TextEditingController();
    _firstDateController = TextEditingController();
    _lastDateController = TextEditingController();
    fetchFullMedicineData(widget.medicalRecord);
    super.initState();
  }

  @override
  void dispose() {
    _potencyTextController.dispose();
    _firstDateController.dispose();
    _lastDateController.dispose();
    super.dispose();
  }

  Future<void> fetchFullMedicineData(BasicMedicalRecord record) async {
    var db = await _dbHandler.database;
    var result = await db.query(Medicine.databaseName(), where: 'id = ?', whereArgs: [record.id]);
    setState(() {
      Medicine medicine = Medicine.fromJson(result.single);
      _searchWrapper = DosageSearchWrapper(selectedMedicine: medicine);
    });
  }

  Future<Iterable<String>> _potencyOptionsForAutocomplete(String input) async {
    var db = await _dbHandler.database;
    String sql = '''
      SELECT ${Medicine.potencyFieldName}
      FROM ${Medicine.databaseName()}
      WHERE ${Medicine.commonlyUsedNameFieldName} = '${_searchWrapper!.selectedMedicine.commonlyUsedName}' 
      AND ${Medicine.potencyFieldName} LIKE '$input%'
      LIMIT 5;
    ''';
    var queryResult = await db.rawQuery(sql);
    var suggestedPotencies = queryResult.map((e) => e[Medicine.potencyFieldName] as String);
    return suggestedPotencies.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wypełnij szczegóły'),
      ),
      body: _searchWrapper != null
          ? SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: _searchWrapper!.selectedMedicine.commonlyUsedName),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                            labelText: 'substancja aktywna',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            prefixIcon: const Icon(Icons.medication_outlined)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) async {
                          return (await _potencyOptionsForAutocomplete(textEditingValue.text))
                              .where((String option) => option.startsWith(textEditingValue.text.toLowerCase()));
                        },
                        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                            FocusNode focusNode, VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            //TODO should only allow values from database for given active substance
                            onChanged: (String value) {
                              setState(() => _searchWrapper!.potency = value);
                            },
                            validator: (value) => _formHandler.validate(value),
                            decoration: InputDecoration(
                                labelText: 'moc',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => {
                                    textEditingController.clear(),
                                    focusNode.unfocus()
                                  },
                                )),
                          );
                        },
                        onSelected: (String value) {
                          setState(() => _searchWrapper!.potency = value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                      child: TextFormField(
                        onChanged: (String value) {
                          setState(() => _searchWrapper!.dosagesPerDay = int.parse(value));
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) => _formHandler.validate(value),
                        decoration: InputDecoration(
                          labelText: 'ilość tabletek na dobę',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                    TextFormField(
                        controller: _firstDateController, //editing controller of this TextField
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today), //icon of text field
                            labelText: "Data początkowa" //label text of field
                        ),
                        validator: (value) => _formHandler.validate(value),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100)
                          );
                          if(pickedDate != null) {
                            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                            setState(() {
                              if(_searchWrapper!.dateEnd != null &&
                                  pickedDate.compareTo(_searchWrapper!.dateEnd!) > 0) {
                                _lastDateController.clear();
                                _searchWrapper!.dateEnd = null;
                              }
                              _firstDateController.text = formattedDate;
                              _searchWrapper!.dateStart = pickedDate;
                            });
                          }
                        }
                    ),
                    if(_searchWrapper!.dateStart != null)
                      TextFormField(
                          controller: _lastDateController, //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Data końcowa" //label text of field
                          ),
                          validator: (value) => _formHandler.validate(value),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _searchWrapper!.dateStart!,
                                firstDate: _searchWrapper!.dateStart!,
                                lastDate: DateTime(2100)
                            );
                            if(pickedDate != null) {
                              String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                              setState(() {
                                _lastDateController.text = formattedDate;
                                _searchWrapper!.dateEnd = pickedDate;
                              });
                            }
                          }
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _formHandler.submit(context, _searchWrapper!),
                        child: const Text('Kolejny krok'),
                      ),
                    )
                  ],
                ),
              ),
          )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
