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
    if(sizeVariants.isEmpty || total <= 0) {
      throw ArgumentError('Given arguments are invalid');
    }
    var finalResults = _applyInternal(sizeVariants, [CalculationModel([], total)]);

    for(List<int> resultSet in finalResults) {
      resultSet.sort((a,b) => a.compareTo(b));
    }
    final deduplicationSet = <String>{};
    finalResults.retainWhere((resultSet) => deduplicationSet.add(resultSet.toString()));

    return finalResults;
  }

  //TODO separate invocation options that are sources from invocation options that are results
  static List<List<int>> _applyInternal(List<int> sizeVariants, List<CalculationModel> models) {
    List<List<int>> finalResults = [];

    //TODO will produce a lot of results for unbalanced input, e.g. [1,2,3,60], 100
    //Still works correctly, just a room for optimization
    for(CalculationModel model in models) {

      List<List<int>> invocationOptions = [List<int>.from(model.options)];
      int total = model.total;
      int biggestPackage = max(sizeVariants)!;
      int smallestPackage = min(sizeVariants)!;

      if (total <= 0) {
        _logger.finest('Ending processing');
      } else if(total >= 2 * biggestPackage) {
        //just add biggest package, we're guaranteed 2 more iterations in this case
        invocationOptions.single.add(biggestPackage);
        int newTotal = total - biggestPackage;
        invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, newTotal)]);
      } else if(sizeVariants.any((package) => package == total)) {
        //exact match of one of available packages
        int package = sizeVariants.firstWhere((package) => package == total);
        invocationOptions.single.add(package);
        int newTotal = total - package;
        invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, newTotal)]);
      } else if(2 * biggestPackage > total && total > biggestPackage) {
        sizeVariants.sort((b,a)=>a.compareTo(b));
        //TODO be careful of how many packages available there are, SHOULD BE FIXED NOW
        List<int> nBiggestPackages = sizeVariants.take(2).toList();
        int biggestPackage = nBiggestPackages.first;
        int secondBiggestPackage = nBiggestPackages.length == 1 ? nBiggestPackages.first : nBiggestPackages.skip(1).first;
        if(total - biggestPackage >= secondBiggestPackage || nBiggestPackages.length == 1) {
          //just one case
          int newTotal = total - biggestPackage;
          invocationOptions.single.add(biggestPackage);
          invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, newTotal)]);
        } else {
          //two cases -> to handle
          invocationOptions.add(List<int>.from(invocationOptions[0])); //make duplicate
          int package1 = nBiggestPackages[0];
          int newTotal1 = total - package1;
          int package2 = nBiggestPackages[1];
          int newTotal2 = total - package2;

          invocationOptions[0].add(package1);
          invocationOptions[1].add(package2);
          invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions[0], newTotal1)]) +
              _applyInternal(sizeVariants, [CalculationModel(invocationOptions[1], newTotal2)]);
        }
      } else if(2 * smallestPackage > total && total > smallestPackage && !sizeVariants.any((variant) => (total - variant) <= 0 && variant < 2 * smallestPackage)) {
        int newSmallestPackageTotal = total - smallestPackage;
        bool equivalentExists = sizeVariants.any((variant) => variant == 2 * smallestPackage);
        if(equivalentExists) {
          int equivalent2xPackage = sizeVariants.firstWhere((variant) => variant == 2 * smallestPackage);
          int newTotalForEquivalent = total - equivalent2xPackage;
          invocationOptions.add(List<int>.from(invocationOptions[0]));
          invocationOptions[0].add(smallestPackage);
          invocationOptions[1].add(equivalent2xPackage);
          invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions[0], newSmallestPackageTotal)]) +
              _applyInternal(sizeVariants, [CalculationModel(invocationOptions[1], newTotalForEquivalent)]);
        } else {
          invocationOptions.single.add(smallestPackage);
          invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, newSmallestPackageTotal)]);
        }

      } else {
        //total < biggestPackage
        //we get n closest matches of packages to total
        List<int> nBestMatchingPackages = _getNClosestMatches(sizeVariants, total, 2);
        if(nBestMatchingPackages.length == 1) {
          int package = nBestMatchingPackages[0];
          int newTotal = total - package;
          invocationOptions.single.add(package);
          invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, newTotal)]);
        } else {
          //two cases
          int package1 = nBestMatchingPackages[0];
          int newTotal1 = total - package1;
          int package2 = nBestMatchingPackages[1];
          int newTotal2 = total - package2;

          //both packages are sufficient, so it's enough to choose a single better one
          if(newTotal1 < 0 && newTotal2 < 0) {
            int chosenPackage = newTotal1 < newTotal2 ? package2 : package1;
            int chosenTotal = total - chosenPackage;
            invocationOptions.single.add(chosenPackage);
            invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions.single, chosenTotal)]);
          } else {
            bool thereIsAVariantThatIsSufficient = sizeVariants.any((variant) => variant > total);

            invocationOptions.add(List<int>.from(invocationOptions[0]));
            if(thereIsAVariantThatIsSufficient) {
              invocationOptions.add(List<int>.from(invocationOptions[0]));
            }
            invocationOptions[0].add(package1);
            invocationOptions[1].add(package2);

            if(thereIsAVariantThatIsSufficient) {
              sizeVariants.sort((a,b)=>a.compareTo(b));
              int smallestSufficientPackage = sizeVariants.firstWhere((variant) => variant > total);
              int totalForSmallestSufficientPackage = total - smallestSufficientPackage;

              invocationOptions[2].add(smallestSufficientPackage);
              invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions[0], newTotal1)]) +
                  _applyInternal(sizeVariants, [CalculationModel(invocationOptions[1], newTotal2)]) +
                  _applyInternal(sizeVariants, [CalculationModel(invocationOptions[2], totalForSmallestSufficientPackage)]);
            } else {
              invocationOptions = _applyInternal(sizeVariants, [CalculationModel(invocationOptions[0], newTotal1)]) +
                  _applyInternal(sizeVariants, [CalculationModel(invocationOptions[1], newTotal2)]);
            }
          }
        }
      }
      finalResults += invocationOptions;
    }

    return finalResults;
  }

  static List<int> _getNClosestMatches(List<int> options, int target, int howMany) {
    options.sort((a,b) {
      if((a - target).abs() == (b - target).abs()) {
        return 0;
      } else {
        return (a - target).abs() < (b - target).abs() ? -1 : 1;
      }
    });
    return options.take(howMany).toList();
  }
}