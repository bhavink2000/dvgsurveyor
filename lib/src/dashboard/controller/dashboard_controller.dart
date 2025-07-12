import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  UserCollectionModel? userData;

  @override
  void onInit() {
    getUserDataFromStorage();
    super.onInit();
  }

  final filterLabels =
      ['Today', 'Yesterday', 'This Week', 'This Month', 'All'].obs;
  final selectedFilter = 'Today'.obs;

  Future<void> getUserDataFromStorage() async {
    userData = SessionManager.getUser();
  }
}
