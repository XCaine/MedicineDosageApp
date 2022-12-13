import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/models/database/packaging_option.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

class DosageResultWrapper implements Comparable<DosageResultWrapper> {
  static final Logger _logger = LogDistributor.getLoggerFor('DosageResultsWrapper');
  final List<Medicine> medicines;
  final List<PackagingOption> packages;
  final int target;

  //how many dosages are we losing on this set compared to target
  late final int redundancyFactor;

  DosageResultWrapper({
    required this.medicines,
    required this.packages,
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
  int compareTo(DosageResultWrapper other) {
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
