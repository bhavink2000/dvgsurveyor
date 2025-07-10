import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:get/get.dart';

class SurveyScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  RxList<SurveyModel> surveyData = <SurveyModel>[].obs;
  RxBool isSurveyLoad = false.obs;

  @override
  void onInit() {
    fetchSurveyData();
    super.onInit();
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
