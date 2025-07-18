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

      // Optionally preselect first item
      if (gamList.isNotEmpty && selectedGam.value == null) {
        selectedGam.value = gamList.first;
      }
    } catch (e) {
      log('Log: Error in fetch gam name $e');
    } finally {
      isGamLoad.value = false;
    }
  }

  Future<void> getUserDataFromStorage() async {
    userData = SessionManager.getUser();
  }

  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // disables future dates
    );
    if (picked != null) startDate.value = picked;
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // disables future dates
    );
    if (picked != null) endDate.value = picked;
  }

  void applyDateFilter() {
    if (startDate.value != null && endDate.value != null) {
      if (startDate.value!.isAfter(endDate.value!)) {
        Get.snackbar('Invalid Date Range', 'Start date can’t be after end date',
            backgroundColor: Colors.red.shade100, colorText: Colors.red);
        return;
      }
      // TODO: perform your filter action
      print("Filter applied: ${startDate.value} - ${endDate.value}");
    } else {
      Get.snackbar('Missing Dates', 'Please select both start and end dates',
          backgroundColor: Colors.orange.shade100, colorText: Colors.orange);
    }
  }
}
