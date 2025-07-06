import 'package:dvgsurveyor/src/welcome_screen/controller/welcome_screen_controller.dart';
import 'package:get/get.dart';

class WelcomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => WelcomeScreenController());
  }
}