import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:get/get.dart';

class SurveyScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  RxList<SurveyModel> surveyData = <SurveyModel>[].obs;
  RxBool isSurveyLoad = false.obs;

  UserCollectionModel? userData;

  @override
  void onInit() {
    fetchSurveyData();
    getUserDataFromStorage();
    Future.delayed(Duration(seconds: 1), () {
      getUserDataFromFirebase();
    });
    super.onInit();
  }

  Future<void> getUserDataFromStorage() async {
    userData = SessionManager.getUser();
  }

  Future<void> getUserDataFromFirebase() async {
    userData = await AuthRepo.instance.getUser(userId: userData?.id);
  }

  Future<void> fetchSurveyData() async {
    isSurveyLoad.value = true;
    try {
      final response = await authRepo.getSurveyData(
          userId: SessionManager.getUser()?.id ?? '');
      surveyData.value = response;
      isSurveyLoad.value = false;
    } catch (e) {
      log('Log: get error in fetch survey data $e');
      isSurveyLoad.value = false;
    }
  }
}
