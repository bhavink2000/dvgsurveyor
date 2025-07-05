// ignore_for_file: use_build_context_synchronously

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepo = Provider((ref) {
  final authRef = ref.read(authRepoProvider);
  return RegisterScreenController(
    authRepo: authRef,
  );
});

final registerController =
    StateNotifierProvider<RegisterScreenController, RegisterState>(
  (ref) {
    final authRepo = ref.read(authRepoProvider);
    return RegisterScreenController(authRepo: authRepo);
  },
);

class RegisterState {
  final bool isLoading;
  final bool isPasswordVisible;
  final String? error;

  RegisterState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.error,
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? error,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      error: error ?? this.error,
    );
  }
}

class RegisterScreenController extends StateNotifier<RegisterState> {
  final AuthRepo authRepo;
  RegisterScreenController({required this.authRepo}) : super(RegisterState());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    state = state.copyWith(
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
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

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length < 10) {
      return 'Password must be at least 10 digits';
    }
    return null;
  }

  Future<void> registerUser({required BuildContext context}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final now = DateTime.now();
      final generatedId = 'DVG${now.millisecondsSinceEpoch}';
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

      // Save to Firestore
      final response = await authRepo.saveUser(userDetails: userDetails);

      if (response != null) {
        // Show success at TOP
        AppSnackbar.showSnackbar(
            context, 'Your Account Register Succefully, wait for approval');

        // Navigate (optional)
        _clearControllers();
        Future.delayed(Duration(seconds: 1), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Or pushReplacementNamed if needed
          }
        });
      } else {
        _clearControllers();
        AppSnackbar.showSnackbar(context, 'Register failed ');
      }
    } catch (e) {
      _clearControllers();
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      AppSnackbar.showSnackbar(context, 'An error occurred: $e');
      return;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    usernameController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
  }
}
