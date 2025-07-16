import 'dart:developer';

import 'package:dvgsurveyor/api_repo/app_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreenController extends GetxController {
  final AppRepo appRepo = AppRepo();

  final formKey = GlobalKey<FormState>();
  final cityName = TextEditingController();
  RxBool isActive = true.obs;

  RxBool isCityLoad = false.obs;
  RxList<GamModel> cityData = <GamModel>[].obs;

  RxBool isEditMode = false.obs;
  GamModel? editingCity;
  RxBool isSubmitting = false.obs;

  void prepareForEdit(GamModel cityData) {
    isEditMode.value = true;
    editingCity = cityData;
    cityName.text = cityData.id;
    isActive.value = cityData.isActive;
  }

  void prepareForAdd() {
    isEditMode.value = false;
    editingCity = null;
    cityName.clear();
    isActive.value = true;
  }

  @override
  void onInit() {
    getCityData();
    super.onInit();
  }

  void clearForm() {
    cityName.clear();

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
    GamModel? existingCity,
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
        existing: existingCity,
      );

      if (result != null) {
        await getCityData(); //  Unified call
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

  Future<GamModel?> handlePropertyOperation({
    required bool isEdit,
    required bool isDelete,
    GamModel? existing,
  }) async {
    if (isDelete && existing != null) {
      return await appRepo
          .addUpdateCity(
        isEdit: false,
        isDelete: true,
        cityData: existing,
      )
          .then((_) async {
        await getCityData();
        return null;
      });
    }

    if (isEdit && existing != null) {
      final updated = existing.copyWith(
        name: cityName.text.trim(),
        isActive: isActive.value,
        updatedAt: DateTime.now(),
      );

      return await appRepo.addUpdateCity(
        isEdit: true,
        cityData: updated,
      );
    }

    final newCity = GamModel(
      id: cityName.text.trim(),
      name: cityName.text.trim(),
      isActive: isActive.value,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await appRepo.addUpdateCity(
      isEdit: false,
      cityData: newCity,
    );
  }

  Future<void> getCityData() async {
    isCityLoad.value = true;
    cityData.clear();
    try {
      cityData.value = (await appRepo.getGam()).toSet().toList();
    } catch (e) {
      log('Error: $e');
    } finally {
      isCityLoad.value = false;
    }
  }

  Future<void> deleteCity({GamModel? cityData}) async {
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
                AppConst.cityName,
                style: AppFonts.text20(Get.context!),
              ),
              SizedBox(height: 8),
              Text(
                AppConst.areYouSureToDeleteCity,
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
                          existingCity: cityData,
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
