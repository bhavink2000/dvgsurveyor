import 'package:dvgsurveyor/src/drawer_screen/controller/drawer_screen_controller.dart';
import 'package:get/get.dart';

class DrawerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DrawerScreenController());
  }
}