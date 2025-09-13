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
  var deletingIndex = (-1).obs; // 🔹 store index of item being deleted

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

  /// Fetch surveys
  Future<void> fetchPendingSurveys() async {
    try {
      isLoading.value = true;
      final snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConst.pendingCollection)
          .get();

      pendingSurveys.value = snapshot.docs
          .map((doc) => SurveyModel.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a survey
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

        pendingSurveys.removeAt(index);
        AppSnackbar.showSnackbar(
            message: "Survey deleted successfully", title: 'Deleted');
      } finally {
        deletingIndex.value = -1;
      }
    }
  }
}
