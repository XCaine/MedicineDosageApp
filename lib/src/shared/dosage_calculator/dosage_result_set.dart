import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

class DosageResultSet implements Comparable<DosageResultSet> {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageResultsWrapper');
  final Medicine medicine;
  final List<PackagingOption> packages;
  final List<int> packageVariants;
  final int target;

  //how many dosages are we losing on this set compared to target
  late final int redundancyFactor;

  DosageResultSet({
    required this.medicine,
    required this.packages,
    required this.packageVariants,
    required this.target
  }) {
    _calculateRedundancyFactor();
  }

  _calculateRedundancyFactor() {
    redundancyFactor = packages.map((package) => package.count!).sum - target;
    if(redundancyFactor < 0) {
      _logger.severe('redundancyFactor < 0, this should now happen!');
    }
  }

  @override
  int compareTo(DosageResultSet other) {
    int result;
    if(redundancyFactor == other.redundancyFactor && packages.length == other.packages.length) {
      result = 0;
    } else if(redundancyFactor == other.redundancyFactor) {
      result = packages.length < other.packages.length ? -1 : 1;
    } else {
      result = redundancyFactor < other.redundancyFactor ? -1 : 1;
    }
    return result;
  }
}
