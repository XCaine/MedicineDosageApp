class BootstrapQueryProvider {
  static const String _query = '''
    CREATE TABLE medicine(
      id INTEGER PRIMARY KEY, 
      productIdentifier VARCHAR(255), 
      productName VARCHAR(255),
      commonlyUsedName VARCHAR(255),
      medicineType VARCHAR(255),
      previousName VARCHAR(255),
      targetSpecies VARCHAR(255),
      gracePeriod VARCHAR(255),
      potency VARCHAR(255),
      pharmaceuticalForm VARCHAR(255),
      procedureType VARCHAR(255),
      permitNumber VARCHAR(255),
      permitValidity VARCHAR(255),
      atcCode VARCHAR(255),
      responsibleParty VARCHAR(255),
      packaging TEXT,
      activeSubstance VARCHAR(255),
      flyer VARCHAR(255),
      characteristics VARCHAR(255)
    )
    ''';

  static String getDatabaseBootstrapQuery() {
    return _query;
  }
}
