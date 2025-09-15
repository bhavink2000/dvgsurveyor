import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/helper/firebase_const.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';

class PendingSurveyController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  Rx<UserCollectionModel?> userData = Rx<UserCollectionModel?>(null);

  var pendingSurveys = <SurveyModel>[].obs;
  RxList<SurveyModel> filteredSurveys = <SurveyModel>[].obs;

  var isLoading = false.obs;
  var deletingIndex = (-1).obs;

  RxString searchQuery = ''.obs;
  final searchTextController = TextEditingController();

  // ✅ NEW: Selection mode
  var isSelectionMode = false.obs;
  var selectedSurveys = <String>[].obs; // store survey IDs

  @override
  void onInit() {
    super.onInit();
    getUserData();
    fetchPendingSurveys();
  }

  Future<void> getUserData() async {
    userData.value =
        await AuthRepo.instance.getUser(userId: SessionManager.getUser()?.id);
  }

  Future<void> fetchPendingSurveys() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConst.pendingCollection)
          .get();

      pendingSurveys.value = snapshot.docs
          .map((doc) => SurveyModel.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
      filteredSurveys.value = pendingSurveys;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Toggle selection
  void toggleSelection(String surveyId) {
    if (selectedSurveys.contains(surveyId)) {
      selectedSurveys.remove(surveyId);
    } else {
      selectedSurveys.add(surveyId);
    }
  }

  /// ✅ Delete selected surveys
  Future<void> deleteSelectedSurveys() async {
    if (selectedSurveys.isEmpty) return;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Selected Surveys"),
        content: Text("Are you sure you want to delete "
            "${selectedSurveys.length} selected surveys?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        isLoading.value = true;
        for (var id in selectedSurveys) {
          await FirebaseFirestore.instance
              .collection(FirebaseConst.pendingCollection)
              .doc(id)
              .delete();
        }
        pendingSurveys.removeWhere((s) => selectedSurveys.contains(s.id));
        filteredSurveys.removeWhere((s) => selectedSurveys.contains(s.id));
        selectedSurveys.clear();
        AppSnackbar.showSnackbar(
            title: 'Deleted', message: "Selected surveys deleted successfully");
      } finally {
        isLoading.value = false;
      }
    }
  }

  /// ✅ Delete all
  Future<void> deleteAllSurveys() async {
    if (pendingSurveys.isEmpty) return;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete All Surveys"),
        content: const Text(
            "⚠️ This will permanently delete all pending surveys. Continue?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child:
                const Text("Delete All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        isLoading.value = true;
        final batch = FirebaseFirestore.instance.batch();

        for (var survey in pendingSurveys) {
          final docRef = FirebaseFirestore.instance
              .collection(FirebaseConst.pendingCollection)
              .doc(survey.id);
          batch.delete(docRef);
        }

        await batch.commit();
        pendingSurveys.clear();
        filteredSurveys.clear();
        selectedSurveys.clear();
        AppSnackbar.showSnackbar(
            title: 'Deleted', message: "All surveys deleted successfully");
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> deleteSurvey(String surveyId, int index) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Delete Survey"),
        content: const Text("Are you sure you want to delete this survey?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        deletingIndex.value = index; // show loader only for this item
        await FirebaseFirestore.instance
            .collection(FirebaseConst.pendingCollection)
            .doc(surveyId)
            .delete();

        //pendingSurveys.removeAt(index);
        filteredSurveys.removeAt(index);
        AppSnackbar.showSnackbar(
            message: "Survey deleted successfully", title: 'Deleted');
      } finally {
        deletingIndex.value = -1;
      }
    }
  }

  void applySearch([String? inputQuery]) {
    if (inputQuery != null) searchQuery.value = inputQuery;

    final query = searchQuery.value.toLowerCase();

    filteredSurveys.value = pendingSurveys.where((survey) {
      final matchesText = [
        survey.surveyNumber,
        survey.ownerName,
        survey.mobileNumber,
        survey.address,
        survey.oldHomeNumber,
      ].any((field) => field?.toLowerCase().contains(query) ?? false);

      return matchesText;
    }).toList();
  }
}
