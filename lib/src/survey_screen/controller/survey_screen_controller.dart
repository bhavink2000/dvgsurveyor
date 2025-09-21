import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  RxList<SurveyModel> surveyData = <SurveyModel>[].obs;
  RxBool isSurveyLoad = false.obs;

  Rx<UserCollectionModel?> userData = Rx<UserCollectionModel?>(null);

  RxList<SurveyModel> filteredSurveys = <SurveyModel>[].obs;

  RxString selectedGam = ''.obs;
  RxString selectedPropertyType = ''.obs;
  RxString selectedWorker = ''.obs;
  RxString searchQuery = ''.obs;
  final searchTextController = TextEditingController();

  RxList<String> gamList = <String>[].obs;
  RxList<String> propertyTypes = <String>[].obs;
  RxList<String> workerList = <String>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await getUserData(); // ensure user data is loaded first
    await fetchSurveyData(); // only then fetch survey data
  }

  Future<void> getUserData() async {
    userData.value =
        await AuthRepo.instance.getUser(userId: SessionManager.getUser()?.id);
  }

  Future<void> fetchSurveyData() async {
    isSurveyLoad.value = true;
    try {
      final List<SurveyModel> surveys;
      if (userData.value?.role == 'Admin') {
        surveys = await authRepo.getAllSurveysForAdmin(
          cityName: userData.value?.gamName ?? '',
        );
      } else {
        surveys = await authRepo.getSurveyInsideWorkerCityWise(
          workerId: userData.value?.id ?? '',
          cityName: userData.value?.gamName ?? '',
        );
      }

      // Save all surveys
      surveyData.value = surveys;
      filteredSurveys.value = surveys;

      // 🔹 List of unique gamNames (cities)
      gamList.value = surveys
          .map((e) => e.gamName ?? '')
          .toSet()
          .toList()
          .cast<String>(); // ✅ cast to List<String>

      propertyTypes.value = surveys
          .map<String>((e) => (e.propertyType.isNotEmpty)
              ? e.propertyType.values.first.propertyName ?? ''
              : '')
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      workerList.value = surveys
          .map((e) => e.userName)
          .toSet()
          .toList()
          .cast<String>(); // ✅ cast to List<String>

      isSurveyLoad.value = false;
    } catch (e, s) {
      log('Log: get error in fetch survey data $e s-> $s');
      isSurveyLoad.value = false;
    }
  }

  void applySearch([String? inputQuery]) {
    if (inputQuery != null) searchQuery.value = inputQuery;

    final query = searchQuery.value.toLowerCase();

    filteredSurveys.value = surveyData.where((survey) {
      final propertyTypeName = survey.propertyType.isNotEmpty
          ? survey.propertyType.values.first.propertyName ?? ''
          : '';

      final matchesText = [
        survey.surveyNumber,
        survey.ownerName,
        survey.mobileNumber,
        survey.userName,
        survey.gamName,
        propertyTypeName,
        survey.address,
      ].any((field) => field?.toLowerCase().contains(query) ?? false);

      final matchesGam =
          selectedGam.value.isEmpty || survey.gamName == selectedGam.value;

      final matchesPropType = selectedPropertyType.value.isEmpty ||
          propertyTypeName == selectedPropertyType.value;

      final matchesWorker = selectedWorker.value.isEmpty ||
          survey.userName == selectedWorker.value;

      return matchesText && matchesGam && matchesPropType && matchesWorker;
    }).toList();
  }

  int get gamSurveyCount {
    if (selectedGam.isEmpty) return 0;
    return filteredSurveys.where((s) => s.gamName == selectedGam.value).length;
  }

  int get propertySurveyCount {
    if (selectedPropertyType.isEmpty) return 0;
    return filteredSurveys
        .where((s) =>
            s.propertyType.values.first.propertyName ==
            selectedPropertyType.value)
        .length;
  }

  int get workerSurveyCount {
    if (selectedWorker.isEmpty) return 0;
    return filteredSurveys
        .where((s) => s.userName == selectedWorker.value)
        .length;
  }

  void clearSearchFilters() {
    searchQuery.value = '';
    selectedGam.value = '';
    selectedPropertyType.value = '';
    selectedWorker.value = '';
    searchTextController.clear();
    applySearch();
  }

  Future<void> deleteSurvey({String? sId}) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.format_list_numbered_sharp,
                  size: 48, color: AppColors.tealPrimary),
              SizedBox(height: 16),
              Text(
                AppConst.survey,
                style: AppFonts.text20(Get.context!),
              ),
              SizedBox(height: 8),
              Text(
                AppConst.areYouSureToDeleteSurvey,
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
                        await authRepo.deleteSurveyInsideWorkerCityWise(
                            surveyId: sId ?? '',
                            workerId: userData.value?.id ?? '',
                            cityName: userData.value?.gamName ?? '');
                        Get.back();
                        await fetchSurveyData();
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
