import 'package:collection/collection.dart';
import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/code/models/database/medication.dart';
import 'package:drugs_dosage_app/src/code/models/database/package.dart';
import 'package:logging/logging.dart';

class DosageResultSet implements Comparable<DosageResultSet> {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageResultsWrapper');
  final Medication medicine;
  final List<Package> packages;
  final List<int> packageVariants;
  final int target;

  //how many dosages are we losing on this set compared to target
  late final int redundancyFactor;

  DosageResultSet(
      {required this.medicine, required this.packages, required this.packageVariants, required this.target}) {
    _calculateRedundancyFactor();
  }

  _calculateRedundancyFactor() {
    redundancyFactor = packages.map((package) => package.count!).sum - target;
    if (redundancyFactor < 0) {
      _logger.severe('redundancyFactor < 0, this should not happen!');
    }
  }

  @override
  int compareTo(DosageResultSet other) {
    int result;
    if (redundancyFactor == other.redundancyFactor && packages.length == other.packages.length) {
      result = 0;
    } else if (redundancyFactor == other.redundancyFactor) {
      result = packages.length < other.packages.length ? -1 : 1;
    } else {
      result = redundancyFactor < other.redundancyFactor ? -1 : 1;
    }
    return result;
  }

  Map<int, int> get quantityToPackageVariantMap {
    var countsMap = packages.fold<Map<int, int>>({}, (map, element) {
      int key = element.count!;
      map[key] = (map[key] ?? 0) + 1;
      return map;
    });
    return countsMap;
  }
}
