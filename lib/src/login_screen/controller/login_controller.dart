import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepo authRepo;

  LoginController({required this.authRepo});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive variables
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    isLoading.value = true;

    try {
      final user = await authRepo.getUser(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user != null) {
        if (user.isApproved == false) {
          AppSnackbar.showSnackbar(
            title: 'Oops!',
            message: 'Your account is not approved yet.\nPlease wait for admin approval.',
          );
          return;
        }

        await SessionManager.saveUser(
          user: user,
        );

        AppSnackbar.showSnackbar(title: 'Hello',message: 'Welcome ${user.username}');
        _clearControllers();

        Get.offAllNamed(AppRoutes.dashScreen);
      } else {
        AppSnackbar.showErrorSnackbar(message: 'User not exists');
      }
    } catch (e) {
      _clearControllers();
      AppSnackbar.showErrorSnackbar(message: 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
