import 'dart:developer';
import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyorFormScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  // Form Controllers
  final formKey = GlobalKey<FormState>();
  final ownerName = TextEditingController();
  final junagharNumber = TextEditingController();
  final kabjedarName = TextEditingController();
  final address = TextEditingController();
  final usageType = TextEditingController();
  final mobileNumber = TextEditingController();
  final propertyType = TextEditingController();
  final propertyDescription = TextEditingController();
  final waterConnectionNumber = TextEditingController();
  final constructionYear = TextEditingController();
  final totalFloors = TextEditingController();

  // Dropdown selections
  String? selectedUsageId;
  RxnString selectedPropertyType = RxnString();
  RxnString selectedPropertyDescription = RxnString();

  // Loading indicators
  RxBool isUsageLoad = false.obs;
  RxBool isPropertyTypeLoad = false.obs;
  RxBool isPropertyDesLoad = false.obs;

  // Dropdown data
  RxList<UsageTypeModel> usageData = <UsageTypeModel>[].obs;
  RxList<PropertyTypeModel> propertyData = <PropertyTypeModel>[].obs;
  RxList<PropertyDescriptionModel> propertyDesData =
      <PropertyDescriptionModel>[].obs;

  // Area Details (dynamic floor-wise)
  final RxMap<String, AreaDetail> areaData = <String, AreaDetail>{}.obs;
  final List<String> categories = [
    // FormLabels.slab.tr,
    // FormLabels.papda.tr,
    // FormLabels.patara.tr,
    // FormLabels.nadiya.tr,
    // FormLabels.khulu.tr,
    // 'slab': slab,
    'સ્લેબ',
    'પાપડા',
    'પાટરા',
    'નાળિયા',
    'ખુલ્લું'
  ];
  final TextEditingController newFloorController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    await getUsageType();
    await getPropertyType();
  }

  Future<void> getUsageType() async {
    isUsageLoad.value = true;
    usageData.value = await authRepo.getUsageType();
    isUsageLoad.value = false;
  }

  // Fetch Property Types
  Future<void> getPropertyType() async {
    isPropertyTypeLoad.value = true;

    // Clear selections and data
    selectedPropertyType.value = null;
    selectedPropertyDescription.value = null;
    propertyType.clear();
    propertyDescription.clear();
    propertyData.clear();
    propertyDesData.clear();

    try {
      final data = await authRepo.getPropertyType();
      propertyData.value = data.toSet().toList();
    } catch (e) {
      log('Error fetching property types: $e');
    } finally {
      isPropertyTypeLoad.value = false;
    }
  }

  // Fetch Descriptions based on selected type
  Future<void> getPropertyDescription() async {
    if (selectedPropertyType.value == null) return;

    isPropertyDesLoad.value = true;
    propertyDescription.clear();
    selectedPropertyDescription.value = null;
    propertyDesData.clear();

    try {
      final data = await authRepo.getPropertyDescription(
        propertyId: selectedPropertyType.value!,
      );
      propertyDesData.value = data.toSet().toList();
      propertyDesData.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      log('Error fetching property descriptions: $e');
    } finally {
      isPropertyDesLoad.value = false;
    }
  }

  final RxString selectedBaseFloor = ''.obs;

// Define base floors (dropdown options)
  final List<String> baseFloors = [
    'ground',
    'first',
    'second',
    'basementOne',
    'basementTwo',
  ];

  void addNewFloorBasedOn(String baseFloor) {
    // Count existing floors with this prefix
    final matchingFloors = areaData.keys
        .where((key) => key == baseFloor || key.startsWith('${baseFloor}_'))
        .toList();

    // Determine new floor key
    String newKey;
    if (matchingFloors.isEmpty) {
      newKey = baseFloor;
    } else {
      newKey = "${baseFloor}_${matchingFloors.length}";
    }

    // Add to areaData
    if (!areaData.containsKey(newKey)) {
      areaData[newKey] = AreaDetail();
      areaData.refresh();
      AppSnackbar.showSnackbar(title: 'Success', message: 'Added $newKey');
    } else {
      AppSnackbar.showErrorSnackbar(message: "$newKey already exists.");
    }
  }

  void addItem(String floor, String category) {
    final detail = areaData[floor];
    final target = detail?.categoriesMap[category];
    if (target != null) {
      target.items.add(AreaItem(length: 0, width: 0));
      areaData.refresh();
    }
  }

  void removeItem(String floor, String category, int index) {
    final detail = areaData[floor];
    final target = detail?.categoriesMap[category];
    if (target != null && index < target.items.length) {
      target.items.removeAt(index);
      areaData.refresh();
    }
  }

  void updateItem(String floor, String category, int index, AreaItem updated) {
    final detail = areaData[floor];
    if (detail != null) {
      final target = getCategory(detail, category);
      if (target != null && index < target.items.length) {
        // Auto update count here
        final newItem = AreaItem(
          length: updated.length,
          width: updated.width,
          //count: updated.length * updated.width, // <--- fix
        );
        target.items[index] = newItem;
        areaData.refresh();
      }
    }
  }

  /// Helper function to map string category name to AreaCategory field
  AreaCategory? getCategory(AreaDetail detail, String category) {
    switch (category.toLowerCase()) {
      case 'slab':
      case 'સ્લેબ':
        return detail.slab;
      case 'papda':
      case 'પાપડા':
        return detail.papda;
      case 'patara':
      case 'પાટરા':
        return detail.patara;
      case 'nadiya':
      case 'નાળિયા':
        return detail.nadiya;
      case 'open':
      case 'ખુલ્લું':
        return detail.open;
      default:
        return null;
    }
  }

  void submitForm() async {
    if (formKey.currentState?.validate() ?? false) {
      final String timestampId = 'SUR${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      final surveyData = SurveyModel(
        userId: SessionManager.getUser()?.id ?? '',
        userRole: SessionManager.getUser()?.role ?? '',
        userName:
            '${SessionManager.getUser()?.firstName ?? ''} ${SessionManager.getUser()?.lastName ?? ''}',
        id: timestampId,
        ownerName: ownerName.text.trim(),
        oldHomeNumber: junagharNumber.text.trim(),
        index: '1',
        newHomeNumber: '1',
        rentPersonName: kabjedarName.text.trim(),
        address: address.text.trim(),
        propertyStayType: selectedUsageId ?? '',
        propertyType: {
          (selectedPropertyType.value ?? ''): PropertyTypeItem(
            propertyName: propertyType.text.trim(),
            pId: selectedPropertyType.value,
          )
        },
        propertyDescription: {
          (selectedPropertyDescription.value ?? ''): PropertyDescriptionItem(
            propertyId: selectedPropertyType.value,
            propertyDes: propertyDescription.text.trim(),
            propertyDesId: selectedPropertyDescription.value,
          )
        },
        mobileNumber: mobileNumber.text.trim(),
        waterPipeline: waterConnectionNumber.text.trim(),
        banthkamYear: constructionYear.text.trim(),
        totalFloors: totalFloors.text.trim(),
        area:
            Map<String, AreaDetail>.from(areaData), // Ensure correct conversion
        createdAt: now,
        updatedAt: now,
      );

      log('Form--->${surveyData.toFirebase()}');

      final response = await authRepo.saveSurveyForm(surveyData: surveyData);
      if (response != null) {
        AppSnackbar.showSnackbar(
            title: 'Success', message: 'Data submit successfuly');
        //Get.back();
      } else {
        AppSnackbar.showErrorSnackbar(message: 'Data failed to save');
      }
    }
  }

  @override
  void onClose() {
    ownerName.dispose();
    junagharNumber.dispose();
    kabjedarName.dispose();
    address.dispose();
    usageType.dispose();
    mobileNumber.dispose();
    propertyType.dispose();
    propertyDescription.dispose();
    waterConnectionNumber.dispose();
    constructionYear.dispose();
    totalFloors.dispose();
    newFloorController.dispose();
    super.onClose();
  }
}
