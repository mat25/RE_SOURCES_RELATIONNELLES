import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class Logger {
  static Future<void> log(String message) async {
    final timestamp = DateTime.now().toIso8601String();
    final formatted = '[LOG - $timestamp] $message\n';

    if (kDebugMode) {
      print(formatted);
    }

    final file = await _getLogFile();
    await file.writeAsString(formatted, mode: FileMode.append);
  }

  static Future<File> _getLogFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/app_logs.txt';
    return File(path);
  }

  static Future<String> readLogs() async {
    final file = await _getLogFile();
    return await file.readAsString();
  }

  static Future<void> clearLogs() async {
    final file = await _getLogFile();
    await file.writeAsString('');
  }
}
