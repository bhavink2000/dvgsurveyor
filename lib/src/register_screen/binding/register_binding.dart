import 'package:dvgsurveyor/src/register_screen/controller/register_screen_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController(authRepo: Get.find()));
  }
}
