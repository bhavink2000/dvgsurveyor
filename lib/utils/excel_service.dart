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

    // Define center alignment style
    final centerStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
    );

    // Helper function to append and center style
    void appendCenteredRow(List<CellValue> values) {
      sheet.appendRow(values);
      final rowIndex = sheet.maxRows - 1; // last row index
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex));
        cell.cellStyle = centerStyle;
      }
    }

    // Row 1: Main headers
    appendCenteredRow([
      TextCellValue('ક્રમ નંબર'),
      TextCellValue('જૂના ઘર નંબર'),
      TextCellValue('મુળ માલિકનું નામ'),
      TextCellValue('કબજેદારનું નામ'),
      TextCellValue('ક્ષેત્રફળ (ચો.મી.)'),
      TextCellValue('ગ્રાઉન્ડ ફ્લોર'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('FF/SF/...'),
      TextCellValue(''),
      TextCellValue('ઉપયોગ'),
      TextCellValue('સર્વે નંબર / પ્લોટ નંબર'),
      TextCellValue('વિસ્તાર'),
      TextCellValue('મોબાઇલ નંબર'),
      TextCellValue('દબાણ'),
      TextCellValue('નળ'),
    ]);

    // Row 2: Sub-headers
    appendCenteredRow([
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue('ખુલ્લું'),
      TextCellValue('સ્લેબ તથા પાપડા'),
      TextCellValue('નળીયા તથા પતરા'),
      TextCellValue('સ્લેબ તથા પાપડા'),
      TextCellValue('નળીયા તથા પતરા'),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
      TextCellValue(''),
    ]);
// Merge headers
    sheet.merge(CellIndex.indexByString("F1"),
        CellIndex.indexByString("H1")); // Ground Floor
    sheet.merge(CellIndex.indexByString("I1"),
        CellIndex.indexByString("J1")); // FF/SF/...

    // Helpers (place above your loop)
    int sumCounts(dynamic node) {
      if (node == null) return 0;
      int total = 0;
      if (node is Map) {
        // Prefer counts inside items[]
        if (node['items'] is List) {
          for (var it in node['items']) {
            if (it is Map) {
              final c = it['count'];
              if (c is num) {
                total += c.toInt();
              } else {
                total += int.tryParse(c?.toString() ?? '0') ?? 0;
              }
            }
          }
          if (total > 0) return total;
        }
        // fallback to node-level totalCount
        if (node['totalCount'] != null) {
          final tc = node['totalCount'];
          if (tc is num) return tc.toInt();
          return int.tryParse(tc?.toString() ?? '0') ?? 0;
        }
      }
      return 0;
    }

    double sumAreas(dynamic node) {
      if (node == null) return 0.0;
      double total = 0.0;
      if (node is Map) {
        // If items[] exist sum their totalArea or compute from count*length*width
        if (node['items'] is List) {
          for (var it in node['items']) {
            if (it is Map) {
              if (it['totalArea'] is num) {
                total += (it['totalArea'] as num).toDouble();
              } else {
                final len = it['length'];
                final wid = it['width'];
                final l = (len is num)
                    ? len.toDouble()
                    : double.tryParse(len?.toString() ?? '0') ?? 0.0;
                final w = (wid is num)
                    ? wid.toDouble()
                    : double.tryParse(wid?.toString() ?? '0') ?? 0.0;
                total += l * w;
              }
            }
          }
        }
        // If node has an explicit totalArea at node-level, prefer that (useful when items empty)
        if (node['totalArea'] is num) {
          return (node['totalArea'] as num).toDouble();
        }
      }
      return total;
    }

// --- Main loop (drop this where you append Excel rows) ---
    int counter = 1;

    for (var data in dataList) {
      final areaMap = (data['area'] is Map)
          ? Map<String, dynamic>.from(data['area'])
          : <String, dynamic>{};

      // Ground floor
      final ground = (areaMap['Ground'] is Map)
          ? Map<String, dynamic>.from(areaMap['Ground'])
          : <String, dynamic>{};

      // Ground counts (what you expect to show in Excel for counts)
      final int gfOpenCount = sumCounts(ground['open']);
      final int gfSlabCount = sumCounts(ground['slab']);
      final int gfPapdaCount = sumCounts(ground['papda']);
      final int gfSlabPapdaCount = gfSlabCount + gfPapdaCount;
      final int gfNadiyaCount = sumCounts(ground['nadiya']);
      final int gfPataraCount = sumCounts(ground['patara']);
      final int gfNadiyaPataraCount = gfNadiyaCount + gfPataraCount;

      // Ground areas (for total-area calculation)
      final double gfOpenArea = sumAreas(ground['open']);
      final double gfSlabPapdaArea =
          sumAreas(ground['slab']) + sumAreas(ground['papda']);
      final double gfNadiyaPataraArea =
          sumAreas(ground['nadiya']) + sumAreas(ground['patara']);
      final double groundTotalArea =
          gfOpenArea + gfSlabPapdaArea + gfNadiyaPataraArea;

      // Upper floors: sum counts and areas for all non-Ground keys
      double upperTotalArea = 0.0;
      int ffSlabPapdaCount = 0;
      int ffNadiyaPataraCount = 0;
      double ffSlabPapdaArea = 0.0;
      double ffNadiyaPataraArea = 0.0;

      final upperFloorKeys =
          areaMap.keys.where((k) => k != 'Ground' && areaMap[k] is Map);
      for (final key in upperFloorKeys) {
        final floor = Map<String, dynamic>.from(areaMap[key] ?? {});
        // area sum for the floor (open + slab + papda + nadiya + patara)
        upperTotalArea += sumAreas(floor['open']) +
            sumAreas(floor['slab']) +
            sumAreas(floor['papda']) +
            sumAreas(floor['nadiya']) +
            sumAreas(floor['patara']);

        // counts and area for slab+papda
        ffSlabPapdaCount +=
            sumCounts(floor['slab']) + sumCounts(floor['papda']);
        ffSlabPapdaArea += sumAreas(floor['slab']) + sumAreas(floor['papda']);

        // counts and area for nadiya+patara
        ffNadiyaPataraCount +=
            sumCounts(floor['nadiya']) + sumCounts(floor['patara']);
        ffNadiyaPataraArea +=
            sumAreas(floor['nadiya']) + sumAreas(floor['patara']);
      }

      // Property type (unchanged)
      final propertyTypeMap = data['propertyType'] ?? {};
      final propertyTypeKey =
          propertyTypeMap.keys.isNotEmpty ? propertyTypeMap.keys.first : null;
      final propertyType = propertyTypeMap[propertyTypeKey] ?? {};

      // water pipeline total
      int waterPipelineTotal = 0;
      if (data['waterPipeline'] is List) {
        for (var item in data['waterPipeline']) {
          waterPipelineTotal += (int.tryParse(item.toString()) ?? 0);
        }
      } else {
        waterPipelineTotal =
            int.tryParse(data['waterPipeline']?.toString() ?? '0') ?? 0;
      }

      // final total area (Ground totalArea + Upper floors totalArea)
      final double totalArea = groundTotalArea + upperTotalArea;

      // Append row (columns match your requested order)
      appendCenteredRow([
        IntCellValue(counter), // ક્રમ નંબર
        TextCellValue(data['oldHomeNumber'] ?? ''), // જૂના ઘર નંબર
        TextCellValue(data['ownerName'] ?? ''), // મુળ માલિકનું નામ
        TextCellValue(data['rentPersonName'] ?? ''), // કબજેદારનું નામ
        DoubleCellValue(totalArea), // ક્ષેત્રફળ (ચો.મી.) — area sum (170)
        IntCellValue(gfOpenCount), // Ground open (count) — 10
        IntCellValue(gfSlabPapdaCount), // Ground slab+papda (count) — 50
        IntCellValue(gfNadiyaPataraCount), // Ground nadiya+patara (count)
        IntCellValue(ffSlabPapdaCount), // FF/SF/... slab+papda (count) — 100
        IntCellValue(ffNadiyaPataraCount), // FF/SF/... nadiya+patara (count)
        TextCellValue(propertyType['propertyName'] ?? ''), // ઉપયોગ
        TextCellValue(data['surveyNumber'] ?? ''), // સર્વે નંબર / પ્લોટ નંબર
        TextCellValue(data['address'] ?? ''), // વિસ્તાર
        TextCellValue(data['mobileNumber'] ?? ''), // મોબાઇલ નંબર
        TextCellValue(data['isDabaan']?.toString() ?? ''), // દબાણ
        IntCellValue(waterPipelineTotal), // નળ
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
