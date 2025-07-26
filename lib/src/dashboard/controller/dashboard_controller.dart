import 'dart:developer';
import 'package:dvgsurveyor/api_repo/app_repo.dart';
import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final AuthRepo authRepo;
  final AppRepo appRepo;

  DashboardController({required this.authRepo, required this.appRepo});

  UserCollectionModel? userData;

  RxBool isGamLoad = false.obs;
  RxList<GamModel> gamList = <GamModel>[].obs;

  // Change from `String?` to `Rxn<GamModel>` for dropdown binding
  Rxn<GamModel> selectedGam = Rxn<GamModel>();

  final RxInt cityTotalSurveyCount = 0.obs;
  final RxInt cityTotalAreaCount = 0.obs;

  final RxInt dateTotalSurveyCount = 0.obs;
  final RxInt dateTotalAreaCount = 0.obs;

  final Rxn<DateTime> selectedStartDate = Rxn<DateTime>();
  final Rxn<DateTime> selectedEndDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    getUserDataFromStorage();
    fetchGamName();
  }

  Future<void> fetchGamName() async {
    isGamLoad.value = true;
    try {
      final res = await appRepo.getGam();
      gamList.value = res;
    } catch (e) {
      log('Log: Error in fetch gam name $e');
    } finally {
      isGamLoad.value = false;
    }
  }

  Future<void> getUserDataFromStorage() async {
    userData = SessionManager.getUser();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // disables future dates
    );
    if (picked != null) selectedStartDate.value = picked;
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // disables future dates
    );
    if (picked != null) selectedEndDate.value = picked;
  }

  void applyDateFilter() {
    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      if (selectedStartDate.value!.isAfter(selectedEndDate.value!)) {
        Get.snackbar('Invalid Date Range', 'Start date can’t be after end date',
            backgroundColor: Colors.red.shade100, colorText: Colors.red);
        return;
      }
      fetchDateSurveySummary();

      print(
          "Filter applied: ${selectedStartDate.value} - ${selectedEndDate.value}");
    } else {
      Get.snackbar('Missing Dates', 'Please select both start and end dates',
          backgroundColor: Colors.orange.shade100, colorText: Colors.orange);
    }
  }

  Future<void> fetchCitySurveySummary({String? userId}) async {
    try {
      final surveys = await appRepo.getSurveyDataByCityDateWorker(
        userId: userId ?? userData!.id,
        cityName:
            selectedGam.value!.name.isNotEmpty ? selectedGam.value?.name : null,
        startDate: null,
        endDate: null,
      );

      cityTotalSurveyCount.value = surveys.length;

      int areaSum = 0;
      for (final survey in surveys) {
        for (final area in survey.area.values) {
          areaSum += (area.totalArea).toInt();
        }
      }

      cityTotalAreaCount.value = areaSum;
    } catch (e) {
      cityTotalSurveyCount.value = 0;
      cityTotalAreaCount.value = 0;
      log('Error in fetchCitySurveySummary: $e');
    }
  }

  Future<void> fetchDateSurveySummary({String? userId}) async {
    try {
      final surveys = await appRepo.getSurveyDataByCityDateWorker(
        userId: userId ?? userData!.id,
        cityName: null,
        startDate: selectedStartDate.value,
        endDate: selectedEndDate.value,
      );

      dateTotalSurveyCount.value = surveys.length;

      int areaSum = 0;
      for (final survey in surveys) {
        for (final area in survey.area.values) {
          areaSum += (area.totalArea).toInt();
        }
      }

      dateTotalAreaCount.value = areaSum;
    } catch (e) {
      dateTotalSurveyCount.value = 0;
      dateTotalAreaCount.value = 0;
      log('Error in fetchDateSurveySummary: $e');
    }
  }
}
