import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_enums.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMangementScreenController extends GetxController {
  final AuthRepo authRepo = AuthRepo();

  final RxList<UserCollectionModel> userList = <UserCollectionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> isSavingMap = <String, bool>{}.obs;

  late Rx<RoleEnum?> selectedRole;
  late RxBool isExcel, isEdit, isDelete, isActive;

  void initialize({
    required RoleEnum? initialRole,
    required bool initialExcel,
    required bool initialEdit,
    required bool initialDelete,
    required bool initialActive,
  }) {
    selectedRole = Rx<RoleEnum?>(initialRole);
    isExcel = RxBool(initialExcel);
    isEdit = RxBool(initialEdit);
    isDelete = RxBool(initialDelete);
    isActive = RxBool(initialActive);
  }

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

  Future<void> deleteUser({required String userId}) async {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_rounded,
                  size: 48, color: AppColors.tealPrimary),
              SizedBox(height: 16),
              Text(
                AppConst.delete,
                style: AppFonts.text20(Get.context!),
              ),
              SizedBox(height: 8),
              Text(
                AppConst.areYouSureToDeleteUser,
                textAlign: TextAlign.center,
                style: AppFonts.text14(Get.context!).copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.tealPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        AppConst.cancel,
                        style: AppFonts.text14(Get.context!).copyWith(
                          color: AppColors.tealPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await authRepo.deleteUser(userId: userId);

                        userList.removeWhere(
                            (user) => user.id == userId); // <- remove from list

                        isSavingMap[userId] = false;
                        Get.back();
                      },
                      child: Text(
                        AppConst.delete,
                        style: AppFonts.text14(Get.context!).copyWith(
                          color: AppColors.offWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void save(UserCollectionModel user, Function(UserCollectionModel) onSave) {
    if (selectedRole.value == null) {
      AppSnackbar.showSnackbar(message: 'Please select a role');
      return;
    }
    final updated = user.copyWith(
      role: selectedRole.value!.displayName,
      isExcelDownload: isExcel.value,
      isEditable: isEdit.value,
      isDelete: isDelete.value,
      isApproved: true,
      isActive: isActive.value,
    );
    onSave(updated);
  }

  void openEditSheet({
    required BuildContext context,
    UserCollectionModel? user,
  }) {
    final firstNameController = TextEditingController(text: user?.firstName);
    final lastNameController = TextEditingController(text: user?.lastName);
    final usernameController = TextEditingController(text: user?.username);
    final passwordController = TextEditingController(text: user?.password);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Worker Info",
                style: AppFonts.text20(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _textInput("First Name", firstNameController),
              const SizedBox(height: 16),
              _textInput("Last Name", lastNameController),
              const SizedBox(height: 16),
              _textInput("Username", usernameController),
              const SizedBox(height: 16),
              _textInput("Password", passwordController, isPassword: true),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (user?.isApproved == true) {
                          final updateUserData = user?.copyWith(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );

                          updateUser(userData: updateUserData ?? user!)
                              .then((onValue) async {
                            await getAllUsers();
                            AppSnackbar.showSnackbar(
                                message: "User updated successfully");
                            Navigator.pop(context);
                          });
                        } else {
                          AppSnackbar.showSnackbar(
                              message:
                                  "User is not approved yet, Please approve the user first");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.tealAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.text14(Get.context!).copyWith(
          color: Colors.grey.shade600,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
