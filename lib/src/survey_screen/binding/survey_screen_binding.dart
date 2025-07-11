import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/src/survey_screen/controller/survey_screen_controller.dart';
import 'package:get/get.dart';

class SurveyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepo());
    Get.lazyPut(() => SurveyScreenController());
  }
}
