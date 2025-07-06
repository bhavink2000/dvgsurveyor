import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthRepo authRepo;

  RegisterController({required this.authRepo});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your username';
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your first name';
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your last name';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length < 10) return 'Mobile number must be at least 10 digits';
    return null;
  }

  Future<void> registerUser() async {
    try {
      isLoading.value = true;

      final now = DateTime.now();
      final generatedId =
          '${AppConst.dvg}${now.day}${now.month}${now.year}${now.hour}${now.minute}${now.second}';

      final userDetails = UserCollectionModel(
        id: generatedId,
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        mobileNumber: phoneController.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      final existingUser = await authRepo.getUser(
        mobileNumber: phoneController.text.trim(),
      );

      if (existingUser != null) {
        AppSnackbar.showSnackbar('User already exists with this mobile number');
        return;
      }

      final response = await authRepo.saveUser(user: userDetails);

      if (response != null) {
        AppSnackbar.showSnackbar(
            'Your account registered successfully, wait for approval');

        Future.delayed(const Duration(seconds: 1), () {
          Get.back(); // Go back to login screen
          _clearControllers();
        });
      } else {
        _clearControllers();
        AppSnackbar.showErrorSnackbar('Register failed');
      }
    } catch (e) {
      _clearControllers();
      AppSnackbar.showErrorSnackbar('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearControllers() {
    usernameController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
