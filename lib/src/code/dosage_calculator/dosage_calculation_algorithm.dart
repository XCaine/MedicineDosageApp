import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:logging/logging.dart';
import 'package:quiver/iterables.dart';

class CalculationModel {
  List<int> options;
  int total;

  CalculationModel(this.options, this.total);
}

class DosageCalculationAlgorithm {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageCalculationAlgorithm');

  static List<List<int>> apply(List<int> sizeVariants, int total) {
    if (sizeVariants.isEmpty || total <= 0) {
      throw ArgumentError('Given arguments are invalid');
    }
    var finalResults = _applyAlgorithm(sizeVariants, [CalculationModel([], total)]);
    for (List<int> resultSet in finalResults) {
      resultSet.sort((a, b) => a.compareTo(b));
    }
    final deduplicationSet = <String>{};
    finalResults.retainWhere((resultSet) => deduplicationSet.add(resultSet.toString()));

    return finalResults;
  }

  static List<List<int>> _applyAlgorithm(List<int> sizeVariants, List<CalculationModel> modelsSoFar) {
    List<List<int>> currentIterationResults = [];

    for (CalculationModel model in modelsSoFar) {
      List<List<int>> tempResultHolder = [List<int>.from(model.options)];
      List<List<int>> currentModelResults = tempResultHolder;
      int total = model.total;
      int biggestPackage = max(sizeVariants)!;
      int smallestPackage = min(sizeVariants)!;

      if (total <= 0) {
        _logger.finest('Ending processing');
      } else if (total >= 2 * biggestPackage) {
        //just add biggest package, we're guaranteed 2 more iterations in this case
        tempResultHolder.single.add(biggestPackage);
        int newTotal = total - biggestPackage;
        currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, newTotal)]);
      } else if (sizeVariants.any((package) => package == total)) {
        //exact match of one of available packages
        int package = sizeVariants.firstWhere((package) => package == total);
        tempResultHolder.single.add(package);
        int newTotal = total - package;
        currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, newTotal)]);
      } else if (2 * biggestPackage > total && total > biggestPackage) {
        sizeVariants.sort((b, a) => a.compareTo(b));
        List<int> nBiggestPackages = sizeVariants.take(2).toList();
        int biggestPackage = nBiggestPackages.first;
        int secondBiggestPackage =
            nBiggestPackages.length == 1 ? nBiggestPackages.first : nBiggestPackages.skip(1).first;
        if (total - biggestPackage >= secondBiggestPackage || nBiggestPackages.length == 1) {
          //just one case
          int newTotal = total - biggestPackage;
          tempResultHolder.single.add(biggestPackage);
          currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, newTotal)]);
        } else {
          //two cases -> to handle
          tempResultHolder.add(List<int>.from(tempResultHolder[0])); //make duplicate
          int firstPackage = nBiggestPackages[0];
          int firstNewTotal = total - firstPackage;
          int secondPackage = nBiggestPackages[1];
          int secondNewTotal = total - secondPackage;

          tempResultHolder[0].add(firstPackage);
          tempResultHolder[1].add(secondPackage);
          currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[0], firstNewTotal)]) +
              _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[1], secondNewTotal)]);
        }
      } else if (2 * smallestPackage > total &&
          total > smallestPackage &&
          !sizeVariants.any((variant) => (total - variant) <= 0 && variant < 2 * smallestPackage)) {
        int newSmallestPackageTotal = total - smallestPackage;
        bool equivalentExists = sizeVariants.any((variant) => variant == 2 * smallestPackage);
        if (equivalentExists) {
          int equivalent2xPackage = sizeVariants.firstWhere((variant) => variant == 2 * smallestPackage);
          int newTotalForEquivalent = total - equivalent2xPackage;
          tempResultHolder.add(List<int>.from(tempResultHolder[0]));
          tempResultHolder[0].add(smallestPackage);
          tempResultHolder[1].add(equivalent2xPackage);
          currentModelResults =
              _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[0], newSmallestPackageTotal)]) +
                  _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[1], newTotalForEquivalent)]);
        } else {
          tempResultHolder.single.add(smallestPackage);
          currentModelResults =
              _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, newSmallestPackageTotal)]);
        }
      } else {
        //total < biggestPackage
        //we get n closest matches of packages to total
        List<int> nBestMatchingPackages = _getNClosestMatches(sizeVariants, total, 2);
        if (nBestMatchingPackages.length == 1) {
          int package = nBestMatchingPackages[0];
          int newTotal = total - package;
          tempResultHolder.single.add(package);
          currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, newTotal)]);
        } else {
          //two cases
          int firstPackage = nBestMatchingPackages[0];
          int firstNewTotal = total - firstPackage;
          int secondPackage = nBestMatchingPackages[1];
          int secondNewTotal = total - secondPackage;

          //both packages are sufficient, so it's enough to choose a single better one
          if (firstNewTotal < 0 && secondNewTotal < 0) {
            int chosenPackage = firstNewTotal < secondNewTotal ? secondPackage : firstPackage;
            int chosenTotal = total - chosenPackage;
            tempResultHolder.single.add(chosenPackage);
            currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder.single, chosenTotal)]);
          } else {
            bool thereIsAVariantThatIsSufficient = sizeVariants.any((variant) => variant > total);

            tempResultHolder.add(List<int>.from(tempResultHolder[0]));
            if (thereIsAVariantThatIsSufficient) {
              tempResultHolder.add(List<int>.from(tempResultHolder[0]));
            }
            tempResultHolder[0].add(firstPackage);
            tempResultHolder[1].add(secondPackage);

            if (thereIsAVariantThatIsSufficient) {
              //A package exists that would result in processing finish - let's find it
              sizeVariants.sort((a, b) => a.compareTo(b));
              int smallestSufficientPackage = sizeVariants.firstWhere((variant) => variant > total);
              int totalForSmallestSufficientPackage = total - smallestSufficientPackage;

              tempResultHolder[2].add(smallestSufficientPackage);
              currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[0], firstNewTotal)]) +
                  _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[1], secondNewTotal)]) +
                  _applyAlgorithm(
                      sizeVariants, [CalculationModel(tempResultHolder[2], totalForSmallestSufficientPackage)]);
            } else {
              currentModelResults = _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[0], firstNewTotal)]) +
                  _applyAlgorithm(sizeVariants, [CalculationModel(tempResultHolder[1], secondNewTotal)]);
            }
          }
        }
      }
      currentIterationResults += currentModelResults;
    }

    return currentIterationResults;
  }

  static List<int> _getNClosestMatches(List<int> options, int target, int howMany) {
    options.sort((a, b) {
      if ((a - target).abs() == (b - target).abs()) {
        return 0;
      } else {
        return (a - target).abs() < (b - target).abs() ? -1 : 1;
      }
    });
    return options.take(howMany).toList();
  }
}
