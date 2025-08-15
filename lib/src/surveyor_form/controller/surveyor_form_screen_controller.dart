import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyorFormScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
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
  final newFloorController = TextEditingController();
  final surveyNumber = TextEditingController();
  final remarks = TextEditingController();

  // Dropdown Selections
  RxnString selectedUsageId = RxnString();
  RxnString selectedPropertyType = RxnString();
  RxnString selectedPropertyDescription = RxnString();

  // Loading Flags
  RxBool isUsageLoad = false.obs;
  RxBool isPropertyTypeLoad = false.obs;
  RxBool isPropertyDesLoad = false.obs;

  // Dropdown Data
  RxList<UsageTypeModel> usageData = <UsageTypeModel>[].obs;
  RxList<PropertyTypeModel> propertyData = <PropertyTypeModel>[].obs;
  RxList<PropertyDescriptionModel> propertyDesData =
      <PropertyDescriptionModel>[].obs;

  // Area & Floors
  final RxMap<String, AreaDetail> areaData = <String, AreaDetail>{}.obs;
  final List<String> categories = [
    'સ્લેબ',
    'પાપડા',
    'પતરા',
    'નળિયા',
    'ખુલ્લું'
  ];
  final RxString selectedBaseFloor = ''.obs;
  final List<String> baseFloors = [
    'ground',
    'first',
    'second',
    'Third',
    'basementOne',
  ];

  RxBool isFormSubmit = false.obs;
  final RxBool isEditMode = false.obs;

  RxBool isDabaan = false.obs;

  SurveyModel? survey;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['isEdit'] == true) {
      survey = args['surveyData'];
      isEditMode.value = args['isEdit'] ?? false;

      prefillForm(survey!);
    }
    fetchData();
  }

  void prefillForm(SurveyModel survey) async {
    surveyNumber.text = survey.surveyNumber ?? '';
    ownerName.text = survey.ownerName;
    junagharNumber.text = survey.oldHomeNumber;
    kabjedarName.text = survey.rentPersonName;
    address.text = survey.address;
    mobileNumber.text = survey.mobileNumber;
    waterConnectionNumber.text = survey.waterPipeline;
    constructionYear.text = survey.banthkamYear;
    totalFloors.text = survey.totalFloors;

    // Dropdown values
    selectedUsageId.value = survey.propertyStayType;
    usageType.text = selectedUsageId.value ?? '';
    selectedPropertyType.value = survey.propertyType.keys.first;
    selectedPropertyDescription.value = survey.propertyDescription.keys.first;

    propertyType.text = survey.propertyType.values.first.propertyName ?? '';
    propertyDescription.text =
        survey.propertyDescription.values.first.propertyDes ?? '';
    // Load property descriptions for the selected type
    await getPropertyDescription();

    // Area
    areaData.clear();
    areaData.addAll(survey.area);
  }

  Future<void> fetchData() async {
    //if (isEditMode.value == true) return;
    await getUsageType();
    await getPropertyType();
  }

  Future<void> getUsageType() async {
    isUsageLoad.value = true;
    usageData.value = await authRepo.getUsageType();
    isUsageLoad.value = false;
  }

  Future<void> getPropertyType() async {
    isPropertyTypeLoad.value = true;
    if (isEditMode.value == false) {
      selectedPropertyType.value = null;
      selectedPropertyDescription.value = null;
      propertyType.clear();
      propertyDescription.clear();
      propertyData.clear();
      propertyDesData.clear();
    }

    try {
      propertyData.value = (await authRepo.getPropertyType()).toSet().toList();
    } catch (e) {
      log('Error: $e');
    } finally {
      isPropertyTypeLoad.value = false;
    }
  }

  Future<void> getPropertyDescription() async {
    if (selectedPropertyType.value == null) return;

    if (isEditMode.value != true) {
      isPropertyDesLoad.value = true;
      selectedPropertyDescription.value = null;
      propertyDescription.clear();
      propertyDesData.clear();
    }

    try {
      final data = await authRepo.getPropertyDescription(
        propertyId: selectedPropertyType.value!,
      );
      propertyDesData.value = data.toSet().toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      log('Error: $e');
    } finally {
      isPropertyDesLoad.value = false;
    }
  }

  void addNewFloorBasedOn(String baseFloor) {
    final matches = areaData.keys
        .where((key) => key == baseFloor || key.startsWith('$baseFloor\_'))
        .toList();
    final newKey =
        matches.isEmpty ? baseFloor : '$baseFloor\_${matches.length}';

    if (!areaData.containsKey(newKey)) {
      areaData[newKey] = AreaDetail();
      areaData.refresh();
      AppSnackbar.showSnackbar(title: 'Success', message: 'Added $newKey');
    } else {
      AppSnackbar.showErrorSnackbar(message: '$newKey already exists.');
    }
  }

  void addItem(String floor, String category) {
    areaData[floor]
        ?.categoriesMap[category]
        ?.items
        .add(AreaItem(length: 0, width: 0));
    areaData.refresh();
  }

  void removeItem(String floor, String category, int index) {
    areaData[floor]?.categoriesMap[category]?.items.removeAt(index);
    areaData.refresh();
  }

  void updateItem(String floor, String category, int index, AreaItem updated) {
    final cat = getCategory(areaData[floor]!, category);
    if (cat != null && index < cat.items.length) {
      cat.items[index] = updated;
      areaData.refresh();
    }
  }

  void removeFloor(String floor) {
    areaData.remove(floor);
    update(); // or setState / notifyListeners based on your state management
  }

  AreaCategory? getCategory(AreaDetail detail, String category) {
    switch (category) {
      case 'સ્લેબ':
        return detail.slab;
      case 'પાપડા':
        return detail.papda;
      case 'પતરા':
        return detail.patara;
      case 'નળિયા':
        return detail.nadiya;
      case 'ખુલ્લું':
        return detail.open;
      default:
        return null;
    }
  }

  Future<void> submitForm() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isFormSubmit.value = true;

    try {
      final user = SessionManager.getUser();
      final location = await LocationHelper().getCurrentPosition();
      final now = DateTime.now();

      final bool isEdit = isEditMode.value;
      final id =
          isEdit ? (survey?.id ?? '') : 'SUR${now.millisecondsSinceEpoch}';
      final newIndex = isEdit
          ? (survey?.index ?? '')
          : (await authRepo.getSurveyData(userId: user?.id ?? '')).length + 1;

      final surveyData = SurveyModel(
        id: id,
        userId: user?.id ?? '',
        userRole: user?.role ?? '',
        userName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
        ownerName: ownerName.text.trim(),
        oldHomeNumber: junagharNumber.text.trim(),
        newHomeNumber:
            isEdit ? (survey?.newHomeNumber ?? '') : newIndex.toString(),
        index: isEdit ? (survey?.index ?? '') : newIndex.toString(),
        rentPersonName: kabjedarName.text.trim(),
        address: address.text.trim(),
        propertyStayType: selectedUsageId.value ?? '',
        propertyType: {
          selectedPropertyType.value ?? '': PropertyTypeItem(
            pId: selectedPropertyType.value,
            propertyName: propertyType.text.trim(),
          )
        },
        propertyDescription: {
          selectedPropertyDescription.value ?? '': PropertyDescriptionItem(
            propertyDesId: selectedPropertyDescription.value,
            propertyId: selectedPropertyType.value,
            propertyDes: propertyDescription.text.trim(),
          )
        },
        mobileNumber: mobileNumber.text.trim(),
        waterPipeline: waterConnectionNumber.text.trim(),
        banthkamYear: constructionYear.text.trim(),
        totalFloors: totalFloors.text.trim(),
        area: Map<String, AreaDetail>.from(areaData),
        createdAt: isEdit ? survey?.createdAt : now,
        updatedAt: now,
        gamName: user?.gamName ?? '',
        locationMap: {
          'loc': LocationMap(
            lag: location.latitude.toString(),
            lug: location.longitude.toString(),
          )
        },
        isFormEdit: isEdit,
        surveyNumber: surveyNumber.text.trim(),
        remarks: remarks.text.trim(),
        isDabaan: isDabaan.value == true ? 'હા' : 'ના',
      );

      final result = await authRepo.saveSurveyForm(
        surveyData: surveyData,
        isEditData: isEdit,
      );

      if (result != null) {
        AppSnackbar.showSnackbar(title: 'Success', message: 'Form Submitted');
        await Future.delayed(const Duration(seconds: 1));
        Get.offNamedUntil(AppRoutes.dashScreen, (route) => false);
      } else {
        AppSnackbar.showErrorSnackbar(message: 'Failed to submit form');
      }
    } catch (e) {
      AppSnackbar.showErrorSnackbar(message: 'Error: ${e.toString()}');
    } finally {
      isFormSubmit.value = false;
    }
  }

  @override
  void onClose() {
    for (var c in [
      ownerName,
      junagharNumber,
      kabjedarName,
      address,
      usageType,
      mobileNumber,
      propertyType,
      propertyDescription,
      waterConnectionNumber,
      constructionYear,
      totalFloors,
      newFloorController
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
