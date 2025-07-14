import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:get/get.dart';

class UserMangementScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  final RxList<UserCollectionModel> userList = <UserCollectionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> isSavingMap = <String, bool>{}.obs;

  @override
  void onReady() {
    super.onReady();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    isLoading.value = true;
    final response = await authRepo.getAllUser();
    if (response.isNotEmpty) {
      userList.value = response;
    } else {
      userList.clear();
    }
    isLoading.value = false;
  }

  Future<void> updateUser({required UserCollectionModel userData}) async {
    final userId = userData.id;

    isSavingMap[userId] = true;

    final res = await authRepo.updateUser(userData: userData);
    if (res != null) {
      await getAllUsers();
    }

    isSavingMap[userId] = false;
  }
}
