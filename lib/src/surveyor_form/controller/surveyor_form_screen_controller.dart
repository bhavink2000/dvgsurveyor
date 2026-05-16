import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:signature/signature.dart';

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
  final ecNumber = TextEditingController();
  final srNo = TextEditingController();

  RxBool isNonResedential = false.obs;

  var rcNumberControllers = <Map<String, TextEditingController>>[].obs;

  void addRcNumberField({String contractorName = '', String rcNumber = ''}) {
    rcNumberControllers.add({
      "contractorName": TextEditingController(text: contractorName),
      "rcNumber": TextEditingController(text: rcNumber),
    });
  }

  void removeRcNumberField(int index) {
    if (rcNumberControllers.length > 1) {
      rcNumberControllers.removeAt(index);
    }
  }

  List<RcNumberItem> get rcNumbers => rcNumberControllers
      .map((map) => RcNumberItem(
            contractorName: map["contractorName"]!.text.trim(),
            rcNumber: map["rcNumber"]!.text.trim(),
          ))
      .where((e) => e.contractorName.isNotEmpty || e.rcNumber.isNotEmpty)
      .toList();

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
    'basement',
  ];

  RxBool isFormSubmit = false.obs;
  final RxBool isEditMode = false.obs;
  final RxBool isPendingMode = false.obs;

  RxBool isDabaan = false.obs;

  SurveyModel? survey;

  final MapController mapController = MapController();
  var selectedLocation = LatLng(0, 0).obs;
  var satelliteMode = false.obs;

  var locationMap = <String, LocationMap>{}.obs;
  LocationData? location;
  var currentLocation = LatLng(0, 0).obs; // ADDED
  var workerPicked = false.obs; // ADDED
  // internal
  StreamSubscription<MapEvent>? mapEventSub;
  var hooksAttached = false.obs;

  RxBool isOffProperty = false.obs;

  Rx<UserCollectionModel?> userData = Rx<UserCollectionModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getUserDataFromStorage();
    final args = Get.arguments;
    if (args != null && args['isEdit'] == true) {
      survey = args['surveyData'];
      isEditMode.value = args['isEdit'] ?? false;
      isPendingMode.value = args['isPending'] ?? false;

      prefillForm(survey!);
    }
    fetchData();
    addRcNumberField(); // add at least one by default
  }

  Future<void> getUserDataFromStorage() async {
    userData.value =
        await AuthRepo.instance.getUser(userId: SessionManager.getUser()?.id);
    // if (userData.value?.role == 'Admin') {
    //   await getAllWorker();
    // }
  }

  // signature controller
  final signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final isEditingSignature = false.obs;

  void prefillForm(SurveyModel survey) async {
    isOffProperty.value = survey.isOffProperty;
    isNonResedential.value = survey.isNonResidential;

    // ✅ Common fields
    surveyNumber.text = survey.surveyNumber ?? '';
    ownerName.text = survey.ownerName;
    junagharNumber.text = survey.oldHomeNumber;
    address.text = survey.address;
    mobileNumber.text = survey.mobileNumber;

    if (isOffProperty.value == true) {
      // Off property only needs a few fields
      return;
    }

    // ✅ Extra fields for normal survey
    kabjedarName.text = survey.rentPersonName;
    waterConnectionNumber.text = survey.waterPipeline;
    constructionYear.text = survey.banthkamYear;
    totalFloors.text = survey.totalFloors;

    // ✅ Dropdown values (null + empty check)
    selectedUsageId.value = survey.propertyStayType;
    usageType.text = selectedUsageId.value ?? '';

    if (survey.propertyType.isNotEmpty) {
      selectedPropertyType.value = survey.propertyType.keys.first;
      propertyType.text = survey.propertyType.values.first.propertyName ?? '';
    } else {
      selectedPropertyType.value = '';
      propertyType.text = '';
    }

    if (survey.propertyDescription.isNotEmpty) {
      selectedPropertyDescription.value = survey.propertyDescription.keys.first;
      propertyDescription.text =
          survey.propertyDescription.values.first.propertyDes ?? '';
    } else {
      selectedPropertyDescription.value = '';
      propertyDescription.text = '';
    }

    isDabaan.value = survey.isDabaan == 'હા';

    // ✅ Non-residential specific
    if (isNonResedential.value == true) {
      ecNumber.text = survey.ecNumber ?? '';

      rcNumberControllers.clear();
      if (survey.rcNumber != null && survey.rcNumber!.isNotEmpty) {
        for (var item in survey.rcNumber!) {
          addRcNumberField(
            contractorName: item.contractorName,
            rcNumber: item.rcNumber,
          );
        }
      } else {
        addRcNumberField(); // empty one
      }
    }
    srNo.text = survey.srNo ?? '';

    // ✅ Load property descriptions (after type selected)
    await getPropertyDescription();

    // ✅ Area
    areaData.clear();
    if (survey.area.isNotEmpty) {
      areaData.addAll(survey.area);
    }
  }

  Future<void> fetchData() async {
    //if (isEditMode.value == true) return;
    await getUsageType();
    await getPropertyType();
    location = await LocationHelper().getCurrentPosition();
    currentLocation.value = LatLng(location!.latitude!, location!.longitude!);
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
    isPropertyDesLoad.value = true;
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

      final now = DateTime.now();

      final bool isEdit = isEditMode.value;
      final id =
          isEdit ? (survey?.id ?? '') : 'SUR${now.millisecondsSinceEpoch}';
      // final newIndex = isEdit && isPendingMode.value == false
      //     ? (survey?.index ?? '')
      //     : (await authRepo.getSurveyData(userId: '')).length + 1;

      final newIndex = isEdit && isPendingMode.value == false
          ? (survey?.index ?? 0) // keep old index if editing
          : await authRepo.getNextSurveyIndex(
              workerId: user?.id ?? '',
              cityName: user?.gamName ?? ''); // fetch next index

      Uint8List? signatureBytes = await signatureController.toPngBytes();

      final surveyData = SurveyModel(
        id: id,
        userId: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userId ?? userData.value?.id ?? ''
            : user?.id ?? userData.value?.id ?? '',
        userRole: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userRole ?? userData.value?.role ?? ''
            : user?.role ?? userData.value?.role ?? '',
        userName: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userName ?? userData.value?.username ?? ''
            : '${user?.firstName ?? userData.value?.firstName ?? ''} ${user?.lastName ?? userData.value?.lastName ?? ''}',
        ownerName: ownerName.text.trim(),
        oldHomeNumber: junagharNumber.text.trim(),
        newHomeNumber: isEdit && isPendingMode.value == false
            ? (survey?.newHomeNumber ?? '')
            : newIndex.toString(),
        index: isEdit && isPendingMode.value == false
            ? (survey?.index ?? '')
            : newIndex.toString(),
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
          'loc': locationMap['loc'] ??
              LocationMap(
                lag: location?.latitude?.toString() ?? '0',
                lug: location?.longitude?.toString() ?? '0',
              )
        },
        isFormEdit: isEdit,
        surveyNumber: surveyNumber.text.trim(),
        remarks: remarks.text.trim(),
        isDabaan: isDabaan.value == true ? 'હા' : 'ના',
        signature: signatureBytes != null ? base64Encode(signatureBytes) : null,

        isNonResidential: isNonResedential.value,
        rcNumber: rcNumbers, // List<String>
        ecNumber: ecNumber.text.trim(),
        srNo: srNo.text.trim(),
      );

      final result = await authRepo.saveSurveyInsideWorkerCityWise(
        surveyData: surveyData,
        isEditData: isEdit,
        isPendingData: isPendingMode.value,
        workerId: user?.id ?? surveyData.userId,
        cityName: '${user?.gamName ?? surveyData.gamName}',
      );

      if (result != null) {
        AppSnackbar.showSnackbar(title: 'Success', message: 'Form Submitted');
        await Future.delayed(const Duration(seconds: 1));
        Get.offNamedUntil(AppRoutes.dashScreen, (route) => false);
      } else {
        AppSnackbar.showErrorSnackbar(message: 'Failed to submit form');
      }
    } catch (e) {
      //AppSnackbar.showErrorSnackbar(message: 'Error: ${e.toString()}');
    } finally {
      isFormSubmit.value = false;
    }
  }

  Future<void> closePropertySubmit() async {
    try {
      isFormSubmit.value = true;

      final user = SessionManager.getUser();

      final now = DateTime.now();

      final bool isEdit = isEditMode.value;
      final id =
          isEdit ? (survey?.id ?? '') : 'SUR${now.millisecondsSinceEpoch}';
      final newIndex = isEdit && isPendingMode.value == false
          ? (survey?.index ?? 0) // keep old index if editing
          : await authRepo.getNextSurveyIndex(
              workerId: user?.id ?? '',
              cityName: user?.gamName ?? ''); // fetch next index

      final surveyData = SurveyModel(
        id: id,
        userId: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userId ?? userData.value?.id ?? ''
            : user?.id ?? userData.value?.id ?? '',
        userRole: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userRole ?? userData.value?.role ?? ''
            : user?.role ?? userData.value?.role ?? '',
        userName: (user?.role == 'Admin' && isEditMode.value == true)
            ? survey?.userName ?? userData.value?.username ?? ''
            : '${user?.firstName ?? userData.value?.firstName ?? ''} ${user?.lastName ?? userData.value?.lastName ?? ''}',
        surveyNumber: surveyNumber.text.trim(),
        ownerName: ownerName.text.trim(),
        oldHomeNumber: junagharNumber.text.trim(),
        index: isEdit && isPendingMode.value == false
            ? (survey?.index ?? '')
            : newIndex.toString(),
        mobileNumber: mobileNumber.text.trim(),
        address: address.text.trim(),
        createdAt: isEdit ? survey?.createdAt : now,
        remarks: remarks.text.trim(),
        updatedAt: now,
        isFormEdit: isEdit,
        gamName: user?.gamName ?? '',
        locationMap: {
          'loc': locationMap['loc'] ??
              LocationMap(
                lag: location?.latitude?.toString() ?? '0',
                lug: location?.longitude?.toString() ?? '0',
              )
        },
        newHomeNumber: '',
        rentPersonName: '',
        propertyStayType: '',
        propertyType: {},
        propertyDescription: {},
        waterPipeline: '',
        banthkamYear: '',
        totalFloors: '',
        area: {},
        isOffProperty: true,
        isDabaan: 'ના',
        signature: null,
        srNo: srNo.text.trim(),
      );

      final result = await authRepo.saveSurveyInsideWorkerCityWise(
        surveyData: surveyData,
        isEditData: isEdit,
        isPendingData: isPendingMode.value,
        workerId: user?.id ?? surveyData.userId,
        cityName: '${user?.gamName ?? surveyData.gamName}',
      );

      if (result != null) {
        AppSnackbar.showSnackbar(title: 'Success', message: 'Form Submitted');
        await Future.delayed(const Duration(seconds: 1));
        Get.offNamedUntil(AppRoutes.dashScreen, (route) => false);
      } else {
        AppSnackbar.showErrorSnackbar(message: 'Failed to submit form');
      }
    } catch (e, s) {
      log('closePropertySubmit Error: $e', stackTrace: s);
    } finally {
      isFormSubmit.value = false;
    }
  }

  @override
  void onClose() {
    mapEventSub?.cancel();
    signatureController.dispose();
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
