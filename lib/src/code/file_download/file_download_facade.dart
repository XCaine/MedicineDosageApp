import 'dart:io';

import 'package:drugs_dosage_app/src/code/logging/log_distributor.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadFacade {
  /*
  static final _logger = LogDistributor.getLoggerFor('FileDownloadFacade');

  static late final String _path;

  static void initialize() {
    _logger.info('Initializing path for document downloads');
    _initPath();
  }

  //https://www.evertop.pl/en/how-to-write-a-simple-downloading-app-with-flutter/
  static void _initPath() async {
    if(Platform.isAndroid) {
      _path = (await getExternalStorageDirectory())!.path;
    } else if(Platform.isIOS) {
      _path = (await getApplicationSupportDirectory()).path;
    } else {
      _path = (await getDownloadsDirectory())!.path;
    }
  }

  static Future<DownloaderCore> startDownload(String url, String fileName, [Function? onFinishedCallback]) async {
    initialize();
    if(url.isEmpty || fileName.isEmpty) {
      throw ArgumentError('Invalid arguments');
    }
    final options = DownloaderUtils(
      progressCallback: (current, total) {
        final progress = (current / total) * 100;
        _logger.info('Downloading: $progress');
      },
      file: File('$_path/$fileName'),
      progress: ProgressImplementation(),
      onDone: () {
        _logger.info('Download done. File available at $_path/$fileName');
        if(onFinishedCallback != null) {
          onFinishedCallback();
        }
      },
      deleteOnCancel: true,
    );

    DownloaderCore core = await Flowder.download(url, options);
    return core;
  }
*/
}