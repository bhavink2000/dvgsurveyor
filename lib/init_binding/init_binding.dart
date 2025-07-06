import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthRepo());
  }
}