import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:get/get.dart';

class DrawerScreenController extends GetxController {
  UserCollectionModel? userData;

  @override
  void onInit() {
    getUserDataFromStorage();
    Future.delayed(Duration(seconds: 1), () {
      getUserDataFromFirebase();
    });

    super.onInit();
  }

  Future<void> getUserDataFromStorage() async {
    userData = SessionManager.getUser();
  }

  Future<void> getUserDataFromFirebase() async {
    userData = await AuthRepo.instance.getUser(userId: userData?.id);
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    Get.offAllNamed(
        AppRoutes.welcomeScreen); // Redirect to login page after logout
  }
}
