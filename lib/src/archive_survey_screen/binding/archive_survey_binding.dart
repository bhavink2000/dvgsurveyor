import 'package:dvgsurveyor/src/archive_survey_screen/controller/archive_survey_controller.dart';
import 'package:get/get.dart';

class ArchiveSurveyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArchiveSurveyController());
  }
}
