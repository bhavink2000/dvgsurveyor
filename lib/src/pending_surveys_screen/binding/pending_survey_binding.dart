import 'package:dvgsurveyor/src/pending_surveys_screen/controller/pending_survey_controller.dart';
import 'package:get/get.dart';

class PendingSurveyBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PendingSurveyController>(() => PendingSurveyController());
  }
}