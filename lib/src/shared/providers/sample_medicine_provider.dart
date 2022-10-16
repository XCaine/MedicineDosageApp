import '../classes/medicine.dart';

class SampleMedicineProvider {
  List<Medicine> get data {
    List<Medicine> medicineList = [
      Medicine(productIdentifier: '100000001', productName: 'productName1', commonlyUsedName: 'commonlyUserName1', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000002', productName: 'productName2', commonlyUsedName: 'commonlyUserName2', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000003', productName: 'productName3', commonlyUsedName: 'commonlyUserName3', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000004', productName: 'productName4', commonlyUsedName: 'commonlyUserName4', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000005', productName: 'productName5', commonlyUsedName: 'commonlyUserName5', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000006', productName: 'productName6', commonlyUsedName: 'commonlyUserName6', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000007', productName: 'productName7', commonlyUsedName: 'commonlyUserName7', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000008', productName: 'productName8', commonlyUsedName: 'commonlyUserName8', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000009', productName: 'productName9', commonlyUsedName: 'commonlyUserName9', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
      Medicine(productIdentifier: '100000010', productName: 'productName10', commonlyUsedName: 'commonlyUserName10', potency: '2.5 mg', pharmaceuticalForm: 'tabletka', packaging: 'test'),
    ];
    return medicineList;
  }
}