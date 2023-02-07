import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/constants/drug_categories.dart';
import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/shared/map_util.dart';
import 'package:drugs_dosage_app/src/code/shared/medication_package_json_generator.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_confirmation.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_dao.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  late GlobalKey<FormBuilderState> _formKey;
  static final Logger _logger = LogDistributor.getLoggerFor("AddMedication");

  List<String> packages = [];

  final List<String> availablePotencyUnits = ['mcg', 'mg', 'g'];

  final addMedicationDao = AddMedicationDao();
  bool productIdentifierAlreadyExists = false;
  late FocusNode packageCountInputFocusNode;

  String get addedPackagesTitle {
    return packages.isEmpty ? 'Brak dodanych opakowań' : 'Dodane opakowania';
  }

  Future<bool> validateAndCommitRecord() async {
    var validationStatus = await validate();
    if (validationStatus == null || !validationStatus) {
      return false;
    }

    var category = _formKey.currentState!.fields[Package.categoryFieldName]!.value;
    var originalCategory = MapUtil.reverse(DrugCategories.categoryExplanationMap)[category] ?? '';

    String packageDataForMedication = MedicationPackageJsonGenerator.generate(packages, originalCategory);
    _logger.info(packageDataForMedication);

    var medicationInstance = Medication(
        productIdentifier: _formKey.currentState!.fields[Medication.productIdentifierFieldName]!.value,
        productName: _formKey.currentState!.fields[Medication.productNameFieldName]!.value,
        commonlyUsedName: _formKey.currentState!.fields[Medication.commonlyUsedNameFieldName]!.value,
        pharmaceuticalForm: _formKey.currentState!.fields[Medication.pharmaceuticalFormFieldName]!.value,
        packaging: packageDataForMedication,
        permitValidity: 'Bezterminowe',
        potency: _formKey.currentState!.fields[Medication.potencyFieldName]!.value);

    var status = false;
    try {
      status = await DatabaseFacade().medicineHandler.insertMedicineList([medicationInstance]);
      var insertedMedicationWithId =
          await addMedicationDao.getMedicationByProductIdentifier(medicationInstance.productIdentifier);
      if (status && insertedMedicationWithId != null) {
        goToConfirmationPage(insertedMedicationWithId);
      }
    } catch (e, stackTrace) {
      _logger.severe('Commit of medical records failed', stackTrace);
    }

    return status;
  }

  void goToConfirmationPage(Medication medication) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddMedicationConfirmation(medication: medication)));
  }

  Future<bool?> validate() async {
    String? productIdentifier = _formKey.currentState?.fields[Medication.productIdentifierFieldName]?.value;
    if (productIdentifier != null && productIdentifier != '') {
      bool exists = await addMedicationDao.anotherMedicationWithSameProductIdentifierExists(productIdentifier);
      setState(() {
        productIdentifierAlreadyExists = exists;
      });
    }

    //hack for validation
    _formKey.currentState?.fields[Package.countFieldName]?.didChange('0');

    var validationResult = _formKey.currentState?.saveAndValidate();

    _formKey.currentState?.fields[Package.countFieldName]?.didChange('');

    return validationResult;
  }

  void addPackagingOption() {
    var value = _formKey.currentState!.fields[Package.countFieldName]?.value.toString();
    //hack for validating with same function the 'adding' field and the whole collection
    var doValidateHack = false;
    if (packages.isEmpty) {
      doValidateHack = true;
      packages.add('');
    }
    bool? validationResult = _formKey.currentState!.fields[Package.countFieldName]?.validate();

    if (doValidateHack) {
      packages.removeAt(0);
    }

    if (validationResult != null && validationResult == true) {
      setState(() {
        packages.add(value!);
        _formKey.currentState!.fields[Package.countFieldName]!.didChange('');
      });
    }

    packageCountInputFocusNode.requestFocus();
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
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _formKey = GlobalKey<FormBuilderState>();
      packageCountInputFocusNode = FocusNode();
    });
  }

  @override
  void dispose() {
    packageCountInputFocusNode.dispose();
    super.dispose();
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
                    validator: (productIdentifier) => AddMedicationFormValidators.productIdentifierValidator(
                        productIdentifier, productIdentifierAlreadyExists),
                  ),
                  FormBuilderTextField(
                    name: Medication.productNameFieldName,
                    decoration: const InputDecoration(labelText: 'Nazwa leku'),
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                  ),
                  FormBuilderTextField(
                    name: Medication.commonlyUsedNameFieldName,
                    decoration: const InputDecoration(labelText: 'Substancja aktywna'),
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
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
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                  ),
                  FormBuilderTextField(
                    name: Medication.pharmaceuticalFormFieldName,
                    decoration: const InputDecoration(labelText: 'Postać farmaceutyczna'),
                    initialValue: 'Tabletki',
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: FormBuilderTextField(
                            name: Medication.potencyFieldName,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(labelText: 'Moc'),
                            validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation()),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: FormBuilderDropdown(
                          name: 'potencyUnit',
                          initialValue: 'mg',
                          items: availablePotencyUnits
                              .map((unit) => DropdownMenuItem(
                                  alignment: AlignmentDirectional.center, value: unit, child: Text(unit)))
                              .toList(),
                          validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                        ),
                      ))
                    ],
                  ),
                  FormBuilderTextField(
                    name: Package.countFieldName,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    focusNode: packageCountInputFocusNode,
                    decoration: InputDecoration(
                        labelText: 'Wariant opakowania',
                        suffix: IconButton(onPressed: addPackagingOption, icon: const Icon(Icons.add))),
                    validator: (value) => AddMedicationFormValidators.atLeastOneValueInCollection(
                        value, packages, 'Dodaj przynamniej jeden\nwariant opakowania'),
                  ),
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
                          Text(
                            addedPackagesTitle,
                            style: const TextStyle(fontSize: 16),
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
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await validateAndCommitRecord();
              },
              child: const Text(
                'Kontynuuj',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
