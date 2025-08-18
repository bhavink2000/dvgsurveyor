import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
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

  final registerFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // ──────── Validation Methods ──────── //

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your last name';
    }
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

  // ──────── Register Method ──────── //

  Future<void> registerUser() async {
    if (isLoading.value) return; // Prevent multiple taps

    try {
      isLoading.value = true;

      final now = DateTime.now();
      final generatedId = '${AppConst.dvg}${now.microsecondsSinceEpoch}';

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
        mobileNumber: userDetails.mobileNumber,
      );

      if (existingUser != null) {
        AppSnackbar.showSnackbar(
          title: 'Oops!',
          message: 'User already exists with this mobile number',
        );
        return;
      }

      final response = await authRepo.saveUser(user: userDetails);

      if (response != null) {
        AppSnackbar.showSnackbar(
          title: 'Success',
          message: 'Your account registered successfully, wait for approval',
        );

        // Unfocus the keyboard
        FocusManager.instance.primaryFocus?.unfocus();

        // Navigate and then clear controllers AFTER screen is disposed
        await Future.delayed(const Duration(seconds: 1));

        Get.offNamed(AppRoutes.loginScreen)?.then((_) {
          _clearControllers(); // Now safe to clear
        });
      } else {
        AppSnackbar.showErrorSnackbar(message: 'Registration failed');
      }
    } catch (e) {
      //AppSnackbar.showErrorSnackbar(message: 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ──────── Helpers ──────── //

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
