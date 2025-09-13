import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ExcelPikDataController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;

  /// Tabs storage: { "filename.xlsx": [ {row1}, {row2}, ... ] }
  var allExcelData = <String, List<Map<String, dynamic>>>{}.obs;
  var currentTab = 0.obs;

  final storage = GetStorage();

  /// Allowed aliases for headers
  final fieldAliases = {
    "index": ["ક્રમ નંબર", "Index", "index"],
    "oldHomeNumber": ["જૂના ઘર નંબર", "Old House No", "oldHomeNumber"],
    "ownerName": ["મુળ માલિકનું નામ", "માલિકનું નામ", "Owner", "ownerName"],
    "occupantName": [
      "કબજેદારનું નામ",
      "કબ્જેદારનું નામ",
      "Occupant",
      "occupantName"
    ],
    "area": ['ક્ષેત્રફળ (ચો.મી.)', 'Area', 'area'],
    "surveyNumber": ['સર્વે નંબર / પ્લોટ નંબર', 'Survey No', 'surveyNumber'],
    "address": ["વિસ્તાર", "Address", "address"],
    "mobileNumber": ["મોબાઇલ નંબર", "Mobile", "mobileNumber"],
  };

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  /// Get field value by checking aliases
  String getField(Map<String, dynamic> row, String fieldKey) {
    final aliases = fieldAliases[fieldKey] ?? [fieldKey];
    for (final alias in aliases) {
      if (row.containsKey(alias) && row[alias] != null) {
        return row[alias].toString().trim();
      }
    }
    return "";
  }

  void _loadFromStorage() {
    final savedData = storage.read("excel_data");
    if (savedData != null) {
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

  /// Pick excel
  Future<void> pickExcelFile() async {
    try {
      errorMessage.value = "";
      isLoading.value = true;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null) {
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

        //  header row
        List<String> headers = sheet.rows.first.map((cell) {
          return cell?.value.toString().trim() ?? "";
        }).toList();

        //  data rows
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
      _saveToStorage();

      if (currentTab.value >= allExcelData.length) {
        currentTab.value = allExcelData.isEmpty ? 0 : allExcelData.length - 1;
      }
    }
  }

  /// Upload all rows from current tab
  Future<void> uploadAllFromCurrentTab() async {
    final fileNames = allExcelData.keys.toList();
    if (fileNames.isEmpty) return;

    final rows = allExcelData[fileNames[currentTab.value]] ?? [];
    isLoading.value = true;

    for (final row in rows) {
      await uploadExcelRow(row);
    }

    isLoading.value = false;
    AppSnackbar.showSnackbar(
        message: 'Uploaded ${rows.length} rows.', title: "Success");
  }

  /// Upload single row with update-or-insert logic
  Future<void> uploadExcelRow(Map<String, dynamic> row) async {
    try {
      final oldHomeNo = getField(row, "oldHomeNumber");
      final indexNo = getField(row, "index");
      final ownerName = getField(row, "ownerName");
      final rentPersonName = getField(row, "occupantName");
      //final area = getField(row, "area");
      final surveyNumber = getField(row, "surveyNumber");
      final address = getField(row, "address");
      final mobileNumber = getField(row, "mobileNumber");

      String docId;

      docId = "SUR${DateTime.now().millisecondsSinceEpoch}";

      final survey = SurveyModel(
        userId: "",
        userRole: "",
        userName: "",
        id: docId,
        surveyNumber: surveyNumber,
        oldHomeNumber: oldHomeNo,
        ownerName: ownerName,
        rentPersonName: rentPersonName,
        address: address,
        mobileNumber: mobileNumber,
        index: indexNo,
        newHomeNumber: "",
        propertyStayType: "",
        propertyType: {},
        propertyDescription: {},
        waterPipeline: "0",
        banthkamYear: "0",
        totalFloors: "0",
        area: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        gamName: "",
        locationMap: {},
        isFormEdit: false,
        remarks: "",
        isDabaan: "ના",
        signature: "",
        isOffProperty: false,
        isNonResidential: false,
        rcNumber: [],
        ecNumber: "",
      );

      await FirebaseFirestore.instance
          .collection("pending_survey")
          .doc(docId)
          .set(survey.toJson(), SetOptions(merge: true));
    } catch (e) {
      Get.snackbar(" Error", e.toString());
    }
  }
}
