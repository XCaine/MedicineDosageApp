import 'package:drugs_dosage_app/src/shared/dosage_calculator/dosage_calculation_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  Function listEquals = const ListEquality().equals;

  test('Test multiplications of biggest package', () {
    var results = DosageCalculationAlgorithm.apply([10, 20, 30, 60], 180);
    var expected = [60, 60, 60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition of smaller packages 1', () {
    var results = DosageCalculationAlgorithm.apply([10, 20, 30, 60], 100);
    var expected = [60, 30, 10];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition of smaller packages 2', () {
    var results = DosageCalculationAlgorithm.apply([1, 2, 3, 60], 100);
    var expected1 = [60, 60];

    expect(results.any((result) => listEquals(result, expected1)), true);
  });

  test('Test composition of smaller packages 3', () {
    var results = DosageCalculationAlgorithm.apply([30, 60, 90, 120], 40);
    var expected1 = [60];

    expect(results.any((result) => listEquals(result, expected1)), true);
  });
}