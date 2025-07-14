import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  final formKey = GlobalKey<FormState>();
  final engProperty = TextEditingController();
  final gujProperty = TextEditingController();
  RxBool isActive = true.obs;

  RxBool isPropertyTypeLoad = false.obs;
  RxList<PropertyTypeModel> propertyData = <PropertyTypeModel>[].obs;

  RxBool isEditMode = false.obs;
  PropertyTypeModel? editingProperty;
  RxBool isSubmitting = false.obs;

  void prepareForEdit(PropertyTypeModel prop) {
    isEditMode.value = true;
    editingProperty = prop;
    engProperty.text = prop.id;
    gujProperty.text = prop.name;
    isActive.value = prop.isActive;
  }

  void prepareForAdd() {
    isEditMode.value = false;
    editingProperty = null;
    engProperty.clear();
    gujProperty.clear();
    isActive.value = true;
  }

  @override
  void onInit() {
    getPropertyType();
    super.onInit();
  }

  void clearForm() {
    engProperty.clear();
    gujProperty.clear();
    isActive.value = true;
  }

  String? validateField(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  void onSubmit({
    bool? isEdit = false,
    PropertyTypeModel? existingProperty,
    bool? isDelete = false,
  }) async {
    if (isDelete == false) {
      if (!formKey.currentState!.validate()) return;
    }

    isSubmitting.value = true;

    try {
      final result = await handlePropertyOperation(
        isEdit: isEdit ?? false,
        isDelete: isDelete ?? false,
        existing: existingProperty,
      );

      if (result != null) {
        await getPropertyType(); //  Unified call
        if (isDelete == false) {
          Get.back();
        }
      }
    } catch (e) {
      log("Error in submit: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<PropertyTypeModel?> handlePropertyOperation({
    required bool isEdit,
    required bool isDelete,
    PropertyTypeModel? existing,
  }) async {
    if (isDelete && existing != null) {
      return await authRepo
          .addUpdatePropertyType(
        isEdit: false,
        isDelete: true,
        proData: existing,
      )
          .then((_) async {
        await getPropertyType();
        return null;
      });
    }

    if (isEdit && existing != null) {
      final updated = existing.copyWith(
        name: gujProperty.text.trim(),
        isActive: isActive.value,
        updatedAt: DateTime.now(),
      );

      return await authRepo.addUpdatePropertyType(
        isEdit: true,
        proData: updated,
      );
    }

    final newProperty = PropertyTypeModel(
      id: engProperty.text.trim(),
      name: gujProperty.text.trim(),
      isActive: isActive.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await authRepo.addUpdatePropertyType(
      isEdit: false,
      proData: newProperty,
    );
  }

  Future<void> getPropertyType() async {
    isPropertyTypeLoad.value = true;
    propertyData.clear();
    try {
      propertyData.value = (await authRepo.getPropertyType()).toSet().toList();
    } catch (e) {
      log('Error: $e');
    } finally {
      isPropertyTypeLoad.value = false;
    }
  }

  Future<void> deleteProperty({PropertyTypeModel? proData}) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_rounded,
                size: 48,
                color: AppColors.tealPrimary,
              ),
              SizedBox(height: 16),
              Text(
                AppConst.deleteProperty,
                style: AppFonts.text20(Get.context!),
              ),
              SizedBox(height: 8),
              Text(
                AppConst.areYouSureToDelete,
                textAlign: TextAlign.center,
                style: AppFonts.text14(Get.context!).copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.tealPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        AppConst.cancel,
                        style: AppFonts.text14(Get.context!).copyWith(
                          color: AppColors.tealPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        Get.back(); // close dialog
                        onSubmit(
                          isEdit: false,
                          isDelete: true,
                          existingProperty: proData,
                        );
                      },
                      child: Text(
                        AppConst.delete,
                        style: AppFonts.text14(Get.context!).copyWith(
                          color: AppColors.offWhite,
                        ),
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
