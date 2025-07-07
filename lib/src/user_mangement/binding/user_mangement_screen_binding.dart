import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/src/user_mangement/controller/user_mangement_screen_controller.dart';
import 'package:get/get.dart';

class UserMangementScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>UserMangementScreenController());
    Get.put(AuthRepo());
  }
  
}