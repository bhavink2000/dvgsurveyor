import 'package:dvgsurveyor/src/splash_screen/controller/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SplashScreenController());
  }
}