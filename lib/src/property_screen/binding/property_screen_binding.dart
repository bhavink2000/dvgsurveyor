import 'package:dvgsurveyor/src/property_screen/controller/property_screen_controller.dart';
import 'package:get/get.dart';

class PropertyScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PropertyScreenController());
  }
}
