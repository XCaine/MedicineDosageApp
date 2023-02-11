import 'package:drugs_dosage_app/src/code/dosage_calculator/dosage_calculation_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

Function listEquals = const ListEquality().equals;

void main() {

  test('Test multiplications of biggest package', () {
    var results = DosageCalculationAlgorithm.apply([10, 20, 30, 60], 180);
    var expected = [60, 60, 60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition of smaller packages 1', () {
    var results = DosageCalculationAlgorithm.apply([10, 20, 30, 60], 100);
    var expected = [10, 30, 60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  //edge case - a lot of results
  test('Test composition of smaller packages 2', () {
    var results = DosageCalculationAlgorithm.apply([1, 2, 3, 60], 100);
    var expected = [60, 60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition of smaller packages 3', () {
    var results = DosageCalculationAlgorithm.apply([30, 60, 90, 120], 40);
    var expected = [60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test single package available', () {
    var results = DosageCalculationAlgorithm.apply([10], 25);
    var expected = [10, 10, 10];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition 4', () {
    var results = DosageCalculationAlgorithm.apply([30, 60], 80);
    var expected = [30, 60];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition 5', () {
    var results = DosageCalculationAlgorithm.apply([25, 28, 30, 50, 56, 60, 100, 250], 32);
    var expected = [50];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition 6', () {
    var results = DosageCalculationAlgorithm.apply([25, 28, 30, 50, 56, 60, 100, 250], 29);
    var expected = [30];

    expect(results.any((result) => listEquals(result, expected)), true);
  });

  test('Test composition 7 - no package variant for 2*smallestPackage', () {
    var results = DosageCalculationAlgorithm.apply([25, 28, 30, 56, 60, 100, 250], 29);
    var expected = [30];

    expect(results.any((result) => listEquals(result, expected)), true);
  });
}