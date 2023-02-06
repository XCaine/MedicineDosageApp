import 'package:form_builder_validators/form_builder_validators.dart';

class AddMedicationFormValidators {

  static const String _fieldCannotBeEmpty = 'To pole nie może być puste';
  static const String _anotherMedicationWithSameIdentifierExists = 'Istnieje już inny lek z tym identyfikatorem';
  static const String _duplicateElementInCollection = 'Element jest już dodany';

  static String? productIdentifierValidator(String? productIdentifier, bool productIdentifierAlreadyExists) {
    if(productIdentifier == null || productIdentifier == '') {
      return _fieldCannotBeEmpty;
    } else if(productIdentifierAlreadyExists) {
      return _anotherMedicationWithSameIdentifierExists;
    } else {
      return null;
    }
  }

  static String? Function(String?) requiredFieldWithPolishExplanation() {
    return FormBuilderValidators.required(errorText: _fieldCannotBeEmpty);
  }

  static String? atLeastOneValueInCollection(String? newValue, List<String> collection, String errorMessage) {
    if(collection.isEmpty) {
      return errorMessage;
    } else if(newValue == null || newValue == '') {
      return _fieldCannotBeEmpty;
    } else if(collection.contains(newValue)) {
      return _duplicateElementInCollection;
    } else {
      return null;
    }
  }
}
