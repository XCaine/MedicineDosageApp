import 'package:collection/collection.dart';
import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_result_set.dart';

class UtilityStringFormatter{
  static String formatQuantityWork(int quantity) {
    if(quantity == 0) {
      return 'sztuk';
    } else if(quantity == 1) {
      return 'sztuka';
    } else if(quantity >= 2 && quantity <= 4) {
      return 'sztuki';
    } else {
      return 'sztuk';
    }
  }

  static String formatDosageWord(int quantity) {
    if(quantity == 0) {
      return 'dawek';
    } else if(quantity == 1) {
      return 'dawkę';
    } else if(quantity >= 2 && quantity <= 4) {
      return 'dawki';
    } else {
      return 'dawek';
    }
  }

  static String formatPackageQuantities(DosageResultSet model, {bool trimLastNewLine = false}) {
    Map<int, int> countsMap = model.quantityToPackageVariantMap;
    List<int> sortedKeys = countsMap.keys.sorted((b, a) => a.compareTo(b));
    StringBuffer buffer = StringBuffer();

    sortedKeys.forEachIndexed((index, key) {
      buffer.write('${countsMap[key]} ${formatQuantityWork(countsMap[key]!)} x $key ${formatDosageWord(key)}');
      if(index == sortedKeys.length - 1 && trimLastNewLine) {
        //don't append last newLine
      } else {
        buffer.write('\n');
      }
    });
    return buffer.toString();
  }
}