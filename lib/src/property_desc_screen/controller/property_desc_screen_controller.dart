import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyDescScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  final formKey = GlobalKey<FormState>();
  final engProperty = TextEditingController();
  final gujProperty = TextEditingController();

  final isPropertyDesLoad = false.obs;
  final isSubmitting = false.obs;
  final isEditMode = false.obs;
  final isActive = true.obs;

  final propertyDesData = <PropertyDescriptionModel>[].obs;
  final propertyTypeData = <PropertyTypeModel>[].obs;

  final Map<String, List<PropertyDescriptionModel>> groupedDescriptions = {};

  PropertyDescriptionModel? editingPropertyDesc;
  String propertyTypeId = '';

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([
      getPropertyTypes(),
      getPropertyDescription(),
    ]);
  }

  Future<void> getPropertyTypes() async {
    try {
      final data = await authRepo.getPropertyType();
      propertyTypeData.value = data;
    } catch (e) {
      log('Error loading property types: $e');
    }
  }

  Future<void> getPropertyDescription() async {
    isPropertyDesLoad.value = true;
    groupedDescriptions.clear();

    try {
      final data = await authRepo.getPropertyDescription(propertyId: '');
      propertyDesData.value = data.toSet().toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      for (var desc in propertyDesData) {
        groupedDescriptions
            .putIfAbsent(desc.propertyTypeId, () => [])
            .add(desc);
      }
    } catch (e) {
      log('Error loading property descriptions: $e');
    } finally {
      isPropertyDesLoad.value = false;
    }
  }

  String getTypeNameById(String id) {
    final type = propertyTypeData.firstWhere(
      (e) => e.id == id,
      orElse: () => PropertyTypeModel(id: '', name: 'Unknown', isActive: true),
    );
    return type.name;
  }

  String? validateField(String? val) {
    return (val == null || val.trim().isEmpty) ? 'Required' : null;
  }

  void prepareForAdd({String proTypeId = ''}) {
    isEditMode.value = false;
    editingPropertyDesc = null;
    engProperty.clear();
    gujProperty.clear();
    isActive.value = true;
    propertyTypeId = proTypeId;
  }

  void prepareForEdit({PropertyDescriptionModel? propDesc}) {
    if (propDesc == null) return;
    isEditMode.value = true;
    editingPropertyDesc = propDesc;
    engProperty.text = propDesc.id;
    gujProperty.text = propDesc.name;
    isActive.value = propDesc.isActive;
    propertyTypeId = propDesc.propertyTypeId;
  }

  void onSubmit({
    bool? isEdit = false,
    PropertyDescriptionModel? existingPropertyDesc,
    bool? isDelete = false,
  }) async {
    if (!isDelete! && !formKey.currentState!.validate()) return;

    isSubmitting.value = true;

    try {
      final result = await handlePropertyOperation(
        isEdit: isEdit ?? false,
        isDelete: isDelete,
        existing: existingPropertyDesc,
      );

      if (result != null) {
        await getPropertyDescription();
        if (!isDelete) Get.back();
      }
    } catch (e) {
      log("Error in submit: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<PropertyDescriptionModel?> handlePropertyOperation({
    required bool isEdit,
    required bool isDelete,
    PropertyDescriptionModel? existing,
  }) async {
    if (isDelete && existing != null) {
      await authRepo.addUpdatePropertyDesc(
        isEdit: false,
        isDelete: true,
        proDescData: existing,
      );
      await getPropertyDescription();
      return null;
    }

    if (isEdit && existing != null) {
      final updated = existing.copyWith(
        name: gujProperty.text.trim(),
        isActive: isActive.value,
        updatedAt: DateTime.now(),
        propertyTypeId: propertyTypeId,
      );

      return await authRepo.addUpdatePropertyDesc(
        isEdit: true,
        proDescData: updated,
      );
    }

    final newProperty = PropertyDescriptionModel(
      id: engProperty.text.trim(),
      name: gujProperty.text.trim(),
      isActive: isActive.value,
      propertyTypeId: propertyTypeId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await authRepo.addUpdatePropertyDesc(
      isEdit: false,
      proDescData: newProperty,
    );
  }

  Future<void> deletePropertyDesc(
      {PropertyDescriptionModel? proDescData}) async {
    if (proDescData == null) return;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.delete_rounded,
                  size: 48, color: AppColors.tealPrimary),
              const SizedBox(height: 16),
              Text(AppConst.deleteProDesc,
                  style: AppFonts.text20(Get.context!)),
              const SizedBox(height: 8),
              Text(
                AppConst.areYouSureToDeleteProDesc,
                textAlign: TextAlign.center,
                style: AppFonts.text14(Get.context!)
                    .copyWith(color: AppColors.darkGrey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.tealPrimary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        AppConst.cancel,
                        style: AppFonts.text14(Get.context!)
                            .copyWith(color: AppColors.tealPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        Get.back();
                        onSubmit(
                          isEdit: false,
                          isDelete: true,
                          existingPropertyDesc: proDescData,
                        );
                      },
                      child: Text(
                        AppConst.delete,
                        style: AppFonts.text14(Get.context!)
                            .copyWith(color: AppColors.offWhite),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
