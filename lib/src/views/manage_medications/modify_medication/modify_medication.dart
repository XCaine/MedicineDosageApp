import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/constants/drug_categories.dart';
import 'package:drugs_dosage_app/src/code/database/database_facade.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:drugs_dosage_app/src/code/shared/map_util.dart';
import 'package:drugs_dosage_app/src/code/shared/medication_package_json_generator.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_confirmation.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/add_medication/add_medication_form_validators.dart';
import 'package:drugs_dosage_app/src/views/manage_medications/manage_medications_dao.dart';
import 'package:drugs_dosage_app/src/views/shared/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class ModifyMedication extends StatefulWidget {
  const ModifyMedication({Key? key, required this.medication, required this.packages}) : super(key: key);

  final Medication medication;
  final List<Package> packages;

  @override
  State<ModifyMedication> createState() => _ModifyMedicationState();
}

class _ModifyMedicationState extends State<ModifyMedication> {

  late GlobalKey<FormBuilderState> _formKey;
  static final Logger _logger = LogDistributor.getLoggerFor("ModifyMedication");

  List<String> packages = [];

  final List<String> availablePotencyUnits = ['mcg', 'mg', 'g'];

  final manageMedicationsDao = ManageMedicationsDao();
  late FocusNode packageCountInputFocusNode;

  String get addedPackagesTitle {
    return packages.isEmpty ? 'Brak dodanych opakowań' : 'Dodane opakowania';
  }

  Future<bool> validateAndUpdateRecord() async {
    var validationStatus = await validate();
    if (validationStatus == null || !validationStatus) {
      return false;
    }

    var category = _formKey.currentState!.fields[Package.categoryFieldName]!.value;
    var originalCategory = MapUtil.reverse(DrugCategories.categoryExplanationMap)[category] ?? '';

    String packageDataForMedication = MedicationPackageJsonGenerator.generate(packages, originalCategory);
    _logger.info(packageDataForMedication);

    var potencyValue = _formKey.currentState!.fields[Medication.potencyFieldName]!.value;
    var potencyUnit = _formKey.currentState!.fields['potencyUnit']!.value;

    var medicationInstance = Medication(
        id: widget.medication.id,
        productIdentifier: widget.medication.productIdentifier,
        productName: _formKey.currentState!.fields[Medication.productNameFieldName]!.value,
        commonlyUsedName: _formKey.currentState!.fields[Medication.commonlyUsedNameFieldName]!.value,
        pharmaceuticalForm: _formKey.currentState!.fields[Medication.pharmaceuticalFormFieldName]!.value,
        packaging: packageDataForMedication,
        permitValidity: widget.medication.permitValidity,
        potency: '$potencyValue $potencyUnit');

    var status = false;
    try {
      status = await DatabaseFacade().medicineHandler.updateMedicationWithPackages(medicationInstance, widget.packages);
      if (status) {
        showSnackBar();
      }

      _logger.info('Record updated');
    } catch (e, stackTrace) {
      _logger.severe('Commit of medical records failed', stackTrace);
    }

    return status;
  }

  void showSnackBar() {
    CustomSnackBar.show(context, 'Dane leku zostały zaktualizowane');
  }

  Future<bool?> validate() async {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _formKey = GlobalKey<FormBuilderState>();
      packageCountInputFocusNode = FocusNode();
      packages = widget.packages.map((package) => package.count.toString()).toSet().toList();
    });
  }

  @override
  void dispose() {
    packageCountInputFocusNode.dispose();
    super.dispose();
  }
  
  String getUnitFromPotencyString(String potency) {
    return potency.split(' ').last;
  }

  String getValueFromPotencyString(String potency) {
    return potency.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zmodyfikuj lek'),
        actions: [
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
                    initialValue: widget.medication.productIdentifier,
                    decoration: const InputDecoration(labelText: 'Identyfikator produktu'),
                    readOnly: true,
                  ),
                  FormBuilderTextField(
                    name: Medication.productNameFieldName,
                    initialValue: widget.medication.productName,
                    decoration: const InputDecoration(labelText: 'Nazwa leku'),
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                  ),
                  FormBuilderTextField(
                    name: Medication.commonlyUsedNameFieldName,
                    initialValue: widget.medication.commonlyUsedName,
                    decoration: const InputDecoration(labelText: 'Substancja aktywna'),
                    validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation(),
                  ),
                  FormBuilderDropdown(
                    name: Package.categoryFieldName,
                    decoration: const InputDecoration(labelText: 'Kategoria leku'),
                    initialValue: DrugCategories.categoryExplanationMap[widget.packages.first.category],
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
                    initialValue: widget.medication.pharmaceuticalForm,
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
                            initialValue: getValueFromPotencyString(widget.medication.potency),
                            decoration: const InputDecoration(labelText: 'Moc'),
                            validator: AddMedicationFormValidators.requiredFieldWithPolishExplanation()),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11),
                            child: FormBuilderDropdown(
                              name: 'potencyUnit',
                              initialValue: getUnitFromPotencyString(widget.medication.potency),
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
                await validateAndUpdateRecord();
              },
              child: const Text(
                'Zapisz',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
