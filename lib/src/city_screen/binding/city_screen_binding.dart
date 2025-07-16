import 'package:dvgsurveyor/src/city_screen/controller/city_screen_controller.dart';
import 'package:get/get.dart';

class CityScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>CityScreenController());
  }
}