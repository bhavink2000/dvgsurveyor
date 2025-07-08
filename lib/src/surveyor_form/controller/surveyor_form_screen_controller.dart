import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyorFormScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

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

  String? selectedUsageId;
  RxBool isUsageLoad = false.obs;
  RxList<UsageTypeModel> usageData = <UsageTypeModel>[].obs;

  String? selectedPropertyType;
  RxBool isPropertyTypeLoad = false.obs;
  RxList<PropertyTypeModel> propertyData = <PropertyTypeModel>[].obs;

  String? selectedPropertyDescription;
  RxBool isPropertyDesLoad = false.obs;
  RxList<PropertyDescriptionModel> propertyDesData =
      <PropertyDescriptionModel>[].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    await getUsageType();
    await getPropertyType();
  }

  Future<void> getUsageType() async {
    isUsageLoad.value = true;
    final response = await authRepo.getUsageType();
    usageData.value = response;
    isUsageLoad.value = false;
  }

  Future<void> getPropertyType() async {
    isPropertyTypeLoad.value = true;

    selectedPropertyType = null;
    propertyType.clear();
    propertyData.clear();

    final response = await authRepo.getPropertyType();
    propertyData.value = response.toSet().toList();

    isPropertyTypeLoad.value = false;
  }

  Future<void> getPropertyDescription() async {
    if (selectedPropertyType == null || selectedPropertyType!.isEmpty) return;
    propertyDesData.clear();
    isPropertyDesLoad.value = true;
    selectedPropertyDescription = null;
    propertyDescription.clear();

    try {
      final response = await authRepo.getPropertyDescription(
        propertyId: selectedPropertyType!,
      );
      propertyDesData.value = response.toSet().toList(); // avoid duplicates
    } catch (e) {
      log('Error fetching property descriptions: $e');
    } finally {
      isPropertyDesLoad.value = false;
    }
  }

  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      // Submit logic here
      Get.snackbar("Success", "Form submitted successfully");
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
    super.onClose();
  }
}
