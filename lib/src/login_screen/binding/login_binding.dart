import 'package:dvgsurveyor/src/login_screen/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Bind the LoginController to the LoginBinding
    Get.lazyPut(
        () => LoginController(authRepo: Get.find(), appRepo: Get.find()));
  }
}
