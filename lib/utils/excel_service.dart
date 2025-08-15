import 'dart:io';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class ExcelService {
  Future<void> generateAndSaveExcel(List<Map<String, dynamic>> dataList) async {
    // Request permission for Android
    if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        debugPrint("Permission denied");
        return;
      }
    }

    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // Row 1: Main headers
    sheet.appendRow([
      TextCellValue('ક્રમ નંબર'),
      TextCellValue('જૂના ઘર નંબર'),
      TextCellValue('મકાન માલિકનું નામ'),
      TextCellValue('ક્ષેત્રફળ (ચો.મી.)'),
      TextCellValue('ખુલ્લું'),
      TextCellValue('ગ્રાઉન્ડ ફ્લોર'),
      TextCellValue(''),
      TextCellValue('ગ્રાઉન્ડ ફ્લોર +1,2,3'),
      TextCellValue(''),
      TextCellValue('ઉપયોગ'),
      TextCellValue('વિસ્તાર'),
      TextCellValue('સર્વે નંબર / પ્લોટ નંબર'),
      TextCellValue('મોબાઇલ નંબર'),
      TextCellValue('દબાણ'),
      TextCellValue('નળ'),
    ]);

    // Row 2: Sub-headers
    sheet.appendRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('સ્લેબ तथा પાપડા'),
      TextCellValue('નળીયા तथा પટારા'),
      TextCellValue('સ્લેબ तथा પાપડા'),
      TextCellValue('નળીયા तथा પટારા'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
    ]);

    // Merge headers
    sheet.merge(CellIndex.indexByString("F1"), CellIndex.indexByString("G1"));
    sheet.merge(CellIndex.indexByString("H1"), CellIndex.indexByString("I1"));

    int counter = 1; // start from 1

    // Add data rows
    for (var data in dataList) {
      final areaGround = data['area']?['Ground'] ?? {};
      final area123 = data['area']?['Ground+123'] ?? {};
      final propertyTypeMap = data['propertyType'] ?? {};
      final propertyTypeKey =
          propertyTypeMap.keys.isNotEmpty ? propertyTypeMap.keys.first : null;
      final propertyType = propertyTypeMap[propertyTypeKey] ?? {};

      // Ground floor sums
      final gfSlabPapda = (areaGround['slab']?['totalCount'] ?? 0) +
          (areaGround['papda']?['totalCount'] ?? 0);
      final gfNadiyaPatara = (areaGround['nadiya']?['totalCount'] ?? 0) +
          (areaGround['patara']?['totalCount'] ?? 0);

      // Ground+1,2,3 sums
      final gf123SlabPapda = (area123['slab']?['totalCount'] ?? 0) +
          (area123['papda']?['totalCount'] ?? 0);
      final gf123NadiyaPatara = (area123['nadiya']?['totalCount'] ?? 0) +
          (area123['patara']?['totalCount'] ?? 0);

      // WaterPipeline sum (if list)
      int waterPipelineTotal = 0;
      if (data['waterPipeline'] is List) {
        for (var item in data['waterPipeline']) {
          waterPipelineTotal += (int.tryParse(item.toString()) ?? 0);
        }
      } else {
        waterPipelineTotal =
            int.tryParse(data['waterPipeline']?.toString() ?? '0') ?? 0;
      }

      // Append the data row
      sheet.appendRow([
        IntCellValue(counter),
        TextCellValue(data['oldHomeNumber'] ?? ''),
        TextCellValue(data['ownerName'] ?? ''),
        DoubleCellValue(areaGround['totalArea'] ?? 0.0),
        DoubleCellValue(areaGround['open']?['totalCount'] ?? 0.0),
        DoubleCellValue(gfSlabPapda.toDouble()),
        DoubleCellValue(gfNadiyaPatara.toDouble()),
        DoubleCellValue(gf123SlabPapda.toDouble()),
        DoubleCellValue(gf123NadiyaPatara.toDouble()),
        TextCellValue(propertyType['propertyName'] ?? ''),
        TextCellValue(data['address'] ?? ''),
        TextCellValue(data['surveyNumber'] ?? ''),
        TextCellValue(data['mobileNumber'] ?? ''),
        TextCellValue(data['isDabaan']?.toString() ?? ''),
        IntCellValue(waterPipelineTotal),
      ]);

      counter++;
    }

    // Save Excel
    final bytes = excel.encode();
    final downloads = Directory('/storage/emulated/0/Download');
    if (!await downloads.exists()) return;

    // Save Excel with dynamic name
    final now = DateTime.now();
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}_${now.month.toString().padLeft(2, '0')}_${now.year}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}";

    final fileName = "DVG_Survey_$formattedDate.xlsx";

    final file = File('${downloads.path}/$fileName');
    await file.writeAsBytes(bytes!, flush: true);
    AppSnackbar.showSnackbar(
      title: 'Excel Exported',
      message: 'Survey data has been exported to ${file.path}',
    );

    debugPrint("Excel saved: ${file.path}");
  }
}
