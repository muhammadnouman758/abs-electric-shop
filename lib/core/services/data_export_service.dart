// core/services/data_export_service.dart
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class DataExportService {
  static Future<String> exportToCSV(List<List<dynamic>> data) async {
    final csv = const ListToCsvConverter().convert(data);
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/report_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(filePath);
    await file.writeAsString(csv);
    return filePath;
  }

  static Future<String> exportToExcel(List<List<dynamic>> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    for (var row in data) {
      // sheet.appendRow(row);
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File(filePath);
    final encoded = excel.encode();

    if (encoded == null) {
      throw Exception('Failed to encode Excel file.');
    }

    await file.writeAsBytes(encoded, flush: true);
    return filePath;
  }


  static Future<void> shareFile(String filePath) async {
    // await Share.shareXFiles([filePath]);
  }

  static Future<void> backupToGoogleDrive() async {
    // Implement Google Drive backup using google_sign_in and googleapis
    // Requires proper authentication setup
  }
}