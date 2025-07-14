import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelService {
  Future<void> generateAndSaveExcel(List<Map<String, dynamic>> dataList) async {
    // Request storage permission
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        debugPrint("Permission denied");
        return;
      }
    }

    // Create Excel and headers
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow([
      TextCellValue('અનુક્રમણિકા'),
      TextCellValue('નવા ઘરનો નંબર'),
      TextCellValue('જૂના ઘરનો નંબર'),
      TextCellValue('ઘરના માલિકનું નામ'),
      TextCellValue('કુલ વિસ્તાર'),
      TextCellValue('સ્લેબ'),
      TextCellValue('પાપડા'),
      TextCellValue('નાદિયા'),
      TextCellValue('પટારા'),
      TextCellValue('ખુલ્લું'),
      TextCellValue('ઉપયોગ'),
      TextCellValue('વિસ્તાર'),
      TextCellValue('મોબાઇલ નંબર'),
    ]);

    // 3. Loop over all documents
    for (var data in dataList) {
      final area = data['area']?['Ground'] ?? {};
      final propertyTypeMap = data['propertyType'] ?? {};
      final propertyTypeKey =
          propertyTypeMap.keys.isNotEmpty ? propertyTypeMap.keys.first : null;
      final propertyType = propertyTypeMap[propertyTypeKey] ?? {};

      sheet.appendRow([
        IntCellValue(int.tryParse(data['index'] ?? '') ?? 0),
        IntCellValue(int.tryParse(data['newHomeNumber'] ?? '') ?? 0),
        IntCellValue(int.tryParse(data['oldHomeNumber'] ?? '') ?? 0),
        TextCellValue(data['ownerName'] ?? ''),
        DoubleCellValue(area['totalArea'] ?? 0.0),
        DoubleCellValue(area['slab']?['totalCount'] ?? 0.0),
        DoubleCellValue(area['papda']?['totalCount'] ?? 0.0),
        DoubleCellValue(area['nadiya']?['totalCount'] ?? 0.0),
        DoubleCellValue(area['patara']?['totalCount'] ?? 0.0),
        DoubleCellValue(area['open']?['totalCount'] ?? 0.0),
        TextCellValue(propertyType['propertyName'] ?? ''),
        TextCellValue(data['address'] ?? ''),
        TextCellValue(data['mobileNumber'] ?? ''),
      ]);
    }

    // Save to public Download folder
    final bytes = excel.encode();
    final downloads = Directory('/storage/emulated/0/Download');

    if (!await downloads.exists()) {
      debugPrint("Download directory not found");
      return;
    }

    final file = File('${downloads.path}/survey_data_list.xlsx');
    await file.writeAsBytes(bytes!, flush: true);

    debugPrint("Excel saved to: ${file.path}");
  }
}
