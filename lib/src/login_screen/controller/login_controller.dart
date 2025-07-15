import 'dart:developer';

import 'package:dvgsurveyor/api_repo/app_repo.dart';
import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final AuthRepo authRepo;
  final AppRepo appRepo;

  LoginController({required this.authRepo, required this.appRepo});

  // Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Form Key (should be declared in the widget ideally to avoid duplicate key issues)
  final loginFormKey = GlobalKey<FormState>();

  // Reactive State
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  RxBool isGamLoad = false.obs;
  RxList<GamModel> gamList = <GamModel>[].obs;
  String? selectedGam = '';

  @override
  void onInit() {
    fetchGamName();
    super.onInit();
  }

  Future<void> fetchGamName() async {
    isGamLoad.value = true;
    try {
      final res = await appRepo.getGam();

      gamList.value = res;
    } catch (e) {
      log('Log: Error in fetch gam name $e');
    } finally {
      isGamLoad.value = false;
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ──────── Validators ──────── //
  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // ──────── Login Logic ──────── //
  Future<void> login() async {
    if (isLoading.value) return;

    final isFormValid = loginFormKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    try {
      isLoading.value = true;

      final user = await authRepo.getUser(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
        gamName: selectedGam,
      );

      if (user == null) {
        AppSnackbar.showErrorSnackbar(message: 'User not found');
        return;
      }

      if (user.isApproved == false) {
        AppSnackbar.showSnackbar(
          title: 'Pending Approval',
          message:
              'Your account is not approved yet.\nPlease wait for admin approval.',
        );
        return;
      }

      // Hide keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      // Save session
      await SessionManager.saveUser(user: user);

      AppSnackbar.showSnackbar(
        title: 'Welcome!',
        message: 'Hello, ${user.username}',
      );

      // Navigate to dashboard, clear fields after navigation
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.dashScreen)?.then((_) {
        _clearControllers();
      });
    } catch (e) {
      AppSnackbar.showErrorSnackbar(message: 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ──────── Helpers ──────── //
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
