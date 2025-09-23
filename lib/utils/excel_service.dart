import 'dart:convert';
import 'dart:io';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

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

    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // Center alignment style
    final Style centerStyle = workbook.styles.add('centerStyle');
    centerStyle.hAlign = HAlignType.center;
    centerStyle.vAlign = VAlignType.center;

    int currentRow = 1;

    // Helper: append a row with center style
    void appendCenteredRow(List<dynamic> values) {
      for (int col = 0; col < values.length; col++) {
        final cell = sheet.getRangeByIndex(currentRow, col + 1);
        if (values[col] != null) {
          cell.setText(values[col].toString());
        } else {
          cell.setText('');
        }
        cell.cellStyle = centerStyle;
      }
      currentRow++;
    }

    // Row 1: Main headers
    appendCenteredRow([
      'ક્રમ નંબર',
      'Sr.No',
      'જૂના ઘર નંબર',
      'મુળ માલિકનું નામ',
      'કબજેદારનું નામ',
      'ક્ષેત્રફળ (ચો.મી.)',
      'ગ્રાઉન્ડ ફ્લોર',
      '',
      '',
      'FF/SF/...',
      '',
      'ઉપયોગ',
      'સર્વે નંબર / પ્લોટ નંબર',
      'વિસ્તાર',
      'મોબાઇલ નંબર',
      'દબાણ',
      'નળ',
      'Worker',
      'EC Number',
      'RC Numbers',
      'Created Date', // ✅ New
      'Updated Date', // ✅ New
      'Signature',
    ]);

    // Row 2: Sub headers
    appendCenteredRow([
      '',
      '',
      '',
      '',
      '',
      'ખુલ્લું',
      'સ્લેબ તથા પાપડા',
      'નળીયા તથા પતરા',
      'સ્લેબ તથા પાપડા',
      'નળીયા તથા પતરા',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ]);

    // Merge headers
    sheet.getRangeByName("F1:H1").merge();
    sheet.getRangeByName("I1:J1").merge();

    // === Helper functions ===
    double sumCounts(dynamic node) {
      if (node == null) return 0.0;
      double total = 0.0;
      if (node is Map) {
        if (node['items'] is List) {
          for (var it in node['items']) {
            if (it is Map) {
              final c = it['count'];
              if (c is num) {
                total += c.toDouble();
              } else {
                total += double.tryParse(c?.toString() ?? '0') ?? 0.0;
              }
            }
          }
          if (total > 0) return total;
        }
        if (node['totalCount'] != null) {
          final tc = node['totalCount'];
          if (tc is num) return tc.toDouble();
          return double.tryParse(tc?.toString() ?? '0') ?? 0.0;
        }
      }
      return total;
    }

    double sumAreas(dynamic node) {
      if (node == null) return 0.0;
      double total = 0.0;
      if (node is Map) {
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
        if (node['totalArea'] is num) {
          return (node['totalArea'] as num).toDouble();
        }
      }
      return total;
    }

    // === Main loop ===
    int counter = 1;
    for (var data in dataList.reversed) {
      final createdAtRaw = data['createdAt'];
      final updatedAtRaw = data['updatedAt'];

      final areaMap = (data['area'] is Map)
          ? Map<String, dynamic>.from(data['area'])
          : <String, dynamic>{};

      final ground = (areaMap['Ground'] is Map)
          ? Map<String, dynamic>.from(areaMap['Ground'])
          : <String, dynamic>{};

      final double gfOpenCount = sumCounts(ground['open']);
      final double gfSlabPapdaCount =
          sumCounts(ground['slab']) + sumCounts(ground['papda']);
      final double gfNadiyaPataraCount =
          sumCounts(ground['nadiya']) + sumCounts(ground['patara']);

      final double groundTotalArea = sumAreas(ground['open']) +
          sumAreas(ground['slab']) +
          sumAreas(ground['papda']) +
          sumAreas(ground['nadiya']) +
          sumAreas(ground['patara']);

      double upperTotalArea = 0.0;
      double ffSlabPapdaCount = 0.0;
      double ffNadiyaPataraCount = 0.0;

      final upperFloorKeys =
          areaMap.keys.where((k) => k != 'Ground' && areaMap[k] is Map);
      String formatNumber(num value) {
        if (value == 0) return "0";
        double rounded = double.parse(value.toStringAsFixed(2));
        if (rounded % 1 == 0) {
          return rounded.toInt().toString();
        }
        return rounded.toStringAsFixed(2);
      }

      for (final key in upperFloorKeys) {
        final floor = Map<String, dynamic>.from(areaMap[key] ?? {});
        upperTotalArea += sumAreas(floor['open']) +
            sumAreas(floor['slab']) +
            sumAreas(floor['papda']) +
            sumAreas(floor['nadiya']) +
            sumAreas(floor['patara']);

        ffSlabPapdaCount +=
            sumCounts(floor['slab']) + sumCounts(floor['papda']);
        ffNadiyaPataraCount +=
            sumCounts(floor['nadiya']) + sumCounts(floor['patara']);
      }

      final propertyTypeDescMap = data['propertyDescription'] ?? {};
      final propertyTypeDescKey = propertyTypeDescMap.keys.isNotEmpty
          ? propertyTypeDescMap.keys.first
          : null;
      final propertyType = propertyTypeDescMap[propertyTypeDescKey] ?? {};

      int waterPipelineTotal = 0;
      if (data['waterPipeline'] is List) {
        for (var item in data['waterPipeline']) {
          waterPipelineTotal += (int.tryParse(item.toString()) ?? 0);
        }
      } else {
        waterPipelineTotal =
            int.tryParse(data['waterPipeline']?.toString() ?? '0') ?? 0;
      }

      final double totalArea = groundTotalArea + upperTotalArea;

      // === EC Number ===
      final ecNumber = data['ecNumber']?.toString() ?? '';

      // === RC Numbers ===
      String rcCombined = '';
      if (data['rcNumber'] is List) {
        final rcList = List<Map<String, dynamic>>.from(data['rcNumber']);
        rcCombined = rcList
            .map((e) =>
                "${e['contractorName'] ?? ''} - RC.${e['rcNumber'] ?? ''}")
            .where((s) => s.trim().isNotEmpty)
            .join(', ');
      }

      String formatDate(dynamic ts) {
        if (ts == null) return '';
        try {
          if (ts is int) {
            return DateTime.fromMillisecondsSinceEpoch(ts)
                .toString()
                .split('.')
                .first;
          } else if (ts is String) {
            return DateTime.tryParse(ts)?.toString().split('.').first ?? ts;
          } else if (ts is DateTime) {
            return ts.toString().split('.').first;
          }
        } catch (_) {}
        return ts.toString();
      }

      final createdDate = formatDate(createdAtRaw);
      final updatedDate = formatDate(updatedAtRaw);

      // Append row (without signature first)
      appendCenteredRow([
        counter,
        data['srNo'] ?? '',
        data['oldHomeNumber'] ?? '',
        data['ownerName'] ?? '',
        data['rentPersonName'] ?? '',
        formatNumber(totalArea),
        formatNumber(gfOpenCount),
        formatNumber(gfSlabPapdaCount),
        formatNumber(gfNadiyaPataraCount),
        formatNumber(ffSlabPapdaCount),
        formatNumber(ffNadiyaPataraCount),
        propertyType['propertyDes'] ?? '',
        data['surveyNumber'] ?? '',
        data['address'] ?? '',
        data['mobileNumber'] ?? '',
        data['isDabaan']?.toString() ?? '',
        waterPipelineTotal,
        data['userName'] ?? '',
        ecNumber,
        rcCombined,
        createdDate, // ✅ new field
        updatedDate, // ✅ new field
        '', // Signature
      ]);

      // Add signature image if available
      String? signatureBase64 = data['signature'];
      if (signatureBase64 != null && signatureBase64.isNotEmpty) {
        try {
          Uint8List signatureBytes = base64Decode(signatureBase64);
          final Picture picture = sheet.pictures.addBase64(
            currentRow - 1,
            23, // Signature column
            base64Encode(signatureBytes),
          );
          picture.height = 40;
          picture.width = 100;
        } catch (e) {
          debugPrint("Signature decode error: $e");
        }
      }

      counter++;
    }

    // === Formatting ===
    final Style headerStyle = workbook.styles.add('headerStyle');
    headerStyle.bold = true;
    headerStyle.hAlign = HAlignType.center;
    headerStyle.vAlign = VAlignType.center;
    headerStyle.borders.all.lineStyle = LineStyle.thin;
    headerStyle.fontSize = 12;
    headerStyle.wrapText = true;
    sheet.getRangeByName("A1:U2").cellStyle = headerStyle;
    final usedRange =
        sheet.getRangeByIndex(1, 1, currentRow, 23); // ✅ now 23 cols
    usedRange.cellStyle.borders.all.lineStyle = LineStyle.thin;

    // Auto fit columns
    for (int i = 1; i <= 23; i++) {
      sheet.autoFitColumn(i);
    }

    // Custom widths
    sheet.setColumnWidthInPixels(1, 60); // ક્રમ નંબર
    sheet.setColumnWidthInPixels(2, 80); // Sr.No
    sheet.setColumnWidthInPixels(3, 80); // Old home no
    sheet.setColumnWidthInPixels(4, 120); // Owner name
    sheet.setColumnWidthInPixels(5, 120); // Tenant name
    sheet.setColumnWidthInPixels(6, 90); // Area
    sheet.setColumnWidthInPixels(13, 120); // Survey No
    sheet.setColumnWidthInPixels(14, 150); // Address
    sheet.setColumnWidthInPixels(15, 120); // Mobile
    sheet.setColumnWidthInPixels(18, 120); // Worker
    sheet.setColumnWidthInPixels(19, 120); // EC Number
    sheet.setColumnWidthInPixels(20, 200); // RC Numbers
    sheet.setColumnWidthInPixels(21, 120); // Created Date
    sheet.setColumnWidthInPixels(22, 120); // Updated Date
    sheet.setColumnWidthInPixels(23, 100); // Signature

    // Apply borders

    usedRange.cellStyle.borders.all.lineStyle = LineStyle.thin;

    // Wrap text for address & RC numbers
    sheet.getRangeByName("K1:M$currentRow").cellStyle.wrapText = true;
    sheet.getRangeByName("R1:S$currentRow").cellStyle.wrapText = true;

    // Adjust row heights
    for (int row = 3; row < currentRow; row++) {
      sheet.setRowHeightInPixels(row, 50);
    }

    // Freeze headers
    sheet.getRangeByName('A3').freezePanes();

    // === Save Excel ===
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final downloads = Directory('/storage/emulated/0/Download');
    if (!await downloads.exists()) return;

    final now = DateTime.now();
    final formattedDate =
        "${now.day.toString().padLeft(2, '0')}_${now.month.toString().padLeft(2, '0')}_${now.year}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}";

    final fileName = "DVG_Survey_$formattedDate.xlsx";
    final file = File('${downloads.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    AppSnackbar.showSnackbar(
      title: 'Excel Exported',
      message: 'Survey data has been exported to ${file.path}',
    );

    debugPrint("Excel saved: ${file.path}");
  }
}
