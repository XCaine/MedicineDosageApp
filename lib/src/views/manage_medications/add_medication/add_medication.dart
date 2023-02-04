import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/constants/drug_categories.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final _formKey = GlobalKey<FormBuilderState>();
  static final Logger _logger = LogDistributor.getLoggerFor("finalMedication");

  var potencies = <String>['10', '20'];
  var packages = <String>['10', '30'];

  void addPotencyOption() {
    var value = _formKey.currentState!.fields[Medication.potencyFieldName]?.value.toString();
    if (value != null && value != '') {
      setState(() {
        potencies.add(value);
      });
    }
  }

  void removePotencyOption(int index) {
    setState(() {
      potencies.removeAt(index);
    });
  }

  void addPackagingOption() {
    var value = _formKey.currentState!.fields[Package.countFieldName]?.value.toString();
    if (value != null && value != '') {
      setState(() {
        packages.add(value);
      });
    }
  }

  void removePackageOption(int index) {
    setState(() {
      packages.removeAt(index);
    });
  }

  void reset() {
    _formKey.currentState?.reset();
    setState(() {
      packages.clear();
      potencies.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj lek'),
        actions: [
          IconButton(onPressed: reset, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            FormBuilder(
                key: _formKey,
                child: Column(children: [
                  FormBuilderTextField(
                    name: Medication.productIdentifierFieldName,
                    decoration: const InputDecoration(labelText: 'Identyfikator produktu'),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderTextField(
                    name: Medication.productNameFieldName,
                    decoration: const InputDecoration(labelText: 'Nazwa leku'),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderTextField(
                    name: Medication.commonlyUsedNameFieldName,
                    decoration: const InputDecoration(labelText: 'Substancja aktywna'),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderDropdown(
                    name: Package.categoryFieldName,
                    decoration: const InputDecoration(labelText: 'Kategoria leku'),
                    items: DrugCategories.categoryExplanations
                        .map((explanation) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: explanation,
                              child: Text(explanation),
                            ))
                        .toList(),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderTextField(
                    name: Medication.pharmaceuticalFormFieldName,
                    decoration: const InputDecoration(labelText: 'Postać farmaceutyczna'),
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: Medication.potencyFieldName,
                          decoration: InputDecoration(
                              labelText: 'Moc',
                              suffix: IconButton(onPressed: addPotencyOption, icon: const Icon(Icons.add))),
                          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FormBuilderTextField(
                          name: Package.countFieldName,
                          decoration: InputDecoration(
                              labelText: 'Wariant opakowania',
                              suffix: IconButton(onPressed: addPackagingOption, icon: const Icon(Icons.add))),
                          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                        ),
                      )
                    ],
                  )
                ])),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Column(
                        children: [
                          const Text(
                            'Dodane moce',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: potencies.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                      color: Colors.white70,
                                      child: GestureDetector(
                                        onTap: () => removePotencyOption(index),
                                        child: Center(child: Text(potencies[index])),
                                      )),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Column(
                        children: [
                          const Text(
                            'Dodane opakowania',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: packages.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                      color: Colors.white70,
                                      child: GestureDetector(
                                        onTap: () => removePackageOption(index),
                                        child: Center(child: Text(packages[index])),
                                      )),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  debugPrint(_formKey.currentState?.value.toString());
                } else {
                  debugPrint(_formKey.currentState?.value.toString());
                  debugPrint('validation failed');
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
