import 'dart:developer';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:get/get.dart';

class UserMangementScreenController extends GetxController {
  final AuthRepo? authRepo = AuthRepo();

  RxList<UserCollectionModel> userList = List<UserCollectionModel>.empty().obs;
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    getAllUser();
    super.onReady();
  }

  Future<void> getAllUser() async {
    isLoading.value = true;
    final response = await authRepo?.getAllUser();
    if (response != null) {
      userList.value = response;
    } else {
      userList.value = [];
    }

    isLoading.value = false;
  }

  Future<void> updateUser({UserCollectionModel? userData}) async {
    log(userData.toString());
    final respose = await authRepo?.updateUser(userData: userData);
    if (respose != null) {
      getAllUser();
    }
  }
}
