import 'dart:developer';

import 'package:dvgsurveyor/api_repo/app_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchiveSurveyController extends GetxController {
  final AppRepo appRepo = AppRepo();

  RxBool isCityLoad = false.obs;
  RxList<GamModel> cityData = <GamModel>[].obs;
  RxString selectedCity = ''.obs;

  RxList<SurveyModel> surveyData = <SurveyModel>[].obs;
  RxBool isSurveyLoad = false.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getCityData();
    super.onInit();
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

  Future<void> fetchSurveyDataByCity({String? userId}) async {
    isSurveyLoad.value = true;
    try {
      final response = await appRepo.getSurveyByCityWiseData(
        cityName: selectedCity.value,
      );
      surveyData.value = response;
    } catch (e) {
      log('Log: get error in fetch survey data $e');
    } finally {
      isSurveyLoad.value = false;
    }
  }

  Future<void> showDialogArchiveSurvey() async {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.archive_rounded,
                  size: 48, color: AppColors.tealPrimary),
              SizedBox(height: 16),
              Text(
                AppConst.archiveSurvey,
                style: AppFonts.text20(Get.context!),
              ),
              SizedBox(height: 8),
              Text(
                AppConst.areYouSureToArchiveSurvey,
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
                    child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await archiveSelectedCitySurveys();
                          },
                          child: isLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  AppConst.archive,
                                  style: AppFonts.text14(Get.context!).copyWith(
                                    color: AppColors.offWhite,
                                  ),
                                ),
                        )),
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

  Future<void> archiveSelectedCitySurveys() async {
    final city = selectedCity.value.trim();
    if (city.isEmpty) {
      AppSnackbar.showErrorSnackbar(message: 'Please select a city');
      return;
    }

    try {
      isLoading.value = true;

      final citySurveys = surveyData
          .where((s) => s.gamName?.toLowerCase() == city.toLowerCase())
          .toList();

      if (citySurveys.isEmpty) {
        AppSnackbar.showErrorSnackbar(message: 'No surveys found for $city');
        return;
      }

      await appRepo.archiveSurveysByCity(
        cityName: city,
        surveys: citySurveys,
        archivedBy:
            '${SessionManager.getUser()?.firstName} ${SessionManager.getUser()?.lastName}',
      );

      //surveyData.removeWhere((s) => s.gamName?.toLowerCase() == city.toLowerCase());
      Get.back();
      AppSnackbar.showSnackbar(
          message: 'Archived ${citySurveys.length} surveys from "$city".');
    } catch (e) {
      log('Archive error: $e');
      //AppSnackbar.showErrorSnackbar(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
