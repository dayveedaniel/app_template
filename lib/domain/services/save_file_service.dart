import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:new_project_template/util/formatters.dart';

import '../../util/log_service.dart';

class SaveFileService {
  static String? downloadPath;

  static Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      println("Cannot get download folder path $stack");
    }
    downloadPath = directory?.path;
    return downloadPath;
  }

  static Future<String> saveBytesToFile({
    required String ticker,
    required Uint8List byte,
    bool isShortReport = false,
  }) async {
    final shortReport = isShortReport ? ' — Snapshot for ' : ' — ';
    final fileName =
        'PRAAMS InvestWatch$shortReport$ticker — ${DateTime.now().fullDateTime()}';

    final file =
        await File('${downloadPath ?? await getDownloadPath()}/$fileName.pdf')
            .writeAsBytes(byte);
    return file.path;
  }
}
