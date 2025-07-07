import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:dvgsurveyor/src/drawer_screen/controller/drawer_screen_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.put(DrawerScreenController());
  }
}