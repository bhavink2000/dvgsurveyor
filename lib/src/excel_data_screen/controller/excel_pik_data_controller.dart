import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ExcelPikDataController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;

  /// ✅ Tabs storage: { "filename.xlsx": [ {row1}, {row2}, ... ] }
  var allExcelData = <String, List<Map<String, dynamic>>>{}.obs;

  /// Active tab index
  var currentTab = 0.obs;

  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  /// Allowed aliases for headers
  final fieldAliases = {
    "ownerName": ["મુળ માલિકનું નામ", "માલિકનું નામ", "Owner", "ownerName"],
    "occupantName": ["કબજેદારનું નામ", "કબ્જેદારનું નામ", "Occupant", "occupantName"],
  };

  /// Get field value by checking aliases
  String getField(Map<String, dynamic> row, String fieldKey) {
    final aliases = fieldAliases[fieldKey] ?? [fieldKey];
    for (final alias in aliases) {
      if (row.containsKey(alias) && row[alias] != null) {
        return row[alias].toString();
      }
    }
    return "";
  }

  void _loadFromStorage() {
    final savedData = storage.read("excel_data");
    if (savedData != null) {
      // Convert dynamic back into proper Map<String, List<Map<String, dynamic>>>
      allExcelData.assignAll(
        Map<String, dynamic>.from(savedData).map((key, value) {
          List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(
              value.map((e) => Map<String, dynamic>.from(e)));
          return MapEntry(key, list);
        }),
      );
    }
  }

  void _saveToStorage() {
    storage.write("excel_data", allExcelData);
  }

  Future<void> pickExcelFile() async {
    try {
      errorMessage.value = "";
      isLoading.value = true;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) {
        errorMessage.value = "No file selected";
        isLoading.value = false;
        return;
      }

      String? path = result.files.single.path;
      String fileName = result.files.single.name;

      if (path == null || !path.endsWith(".xlsx")) {
        errorMessage.value = "Only .xlsx files are supported";
        isLoading.value = false;
        return;
      }

      File file = File(path);
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);

      List<Map<String, dynamic>> tempData = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        if (sheet.rows.isEmpty) continue;

        // ✅ header row
        List<String> headers = sheet.rows.first.map((cell) {
          return cell?.value.toString().trim() ?? "";
        }).toList();

        // ✅ data rows
        for (var row in sheet.rows.skip(1)) {
          Map<String, dynamic> rowData = {};
          for (int i = 0; i < headers.length; i++) {
            String key = headers[i];
            String value = row[i]?.value?.toString() ?? "";
            rowData[key] = value;
          }
          tempData.add(rowData);
        }
      }

      allExcelData[fileName] = tempData;
      _saveToStorage();
      currentTab.value = allExcelData.keys.toList().indexOf(fileName);
    } catch (e) {
      errorMessage.value = "Error reading Excel: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete Excel file data
  void deleteExcel(String fileName) {
    if (allExcelData.containsKey(fileName)) {
      allExcelData.remove(fileName);

      // remove from local storage
      final box = GetStorage();
      box.remove(fileName);

      if (currentTab.value >= allExcelData.length) {
        currentTab.value = allExcelData.isEmpty ? 0 : allExcelData.length - 1;
      }
    }
  }
}
