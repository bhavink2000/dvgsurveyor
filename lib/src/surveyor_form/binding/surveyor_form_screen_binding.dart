import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/src/surveyor_form/controller/surveyor_form_screen_controller.dart';
import 'package:get/get.dart';

class SurveyorFormScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepo());
    Get.lazyPut(() => SurveyorFormScreenController());
  }
}
