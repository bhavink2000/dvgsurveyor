import 'package:dvgsurveyor/src/property_desc_screen/controller/property_desc_screen_controller.dart';
import 'package:get/get.dart';

class PropertyDescScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>PropertyDescScreenController());
  }
}