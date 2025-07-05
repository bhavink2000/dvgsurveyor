// ignore_for_file: use_build_context_synchronously

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginController =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  final authRepo = ref.read(authRepoProvider);
  return LoginController(authRepo: authRepo);
});

final authRepo = Provider((ref) {
  final authRepo = ref.read(authRepoProvider);
  return LoginController(
    authRepo: authRepo,
  );
});

class LoginState {
  final bool isLoading;
  final bool isPasswordVisible;
  final String? error;

  LoginState({
    this.isLoading = false,
    this.isPasswordVisible = false,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      error: error ?? this.error,
    );
  }
}

class LoginController extends StateNotifier<LoginState> {
  final AuthRepo authRepo;

  LoginController({required this.authRepo}) : super(LoginState());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final exitUser = await authRepo.getUserByUsername(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (exitUser != null) {
        // User already exists, show error
        AppSnackbar.showSnackbar(context, 'User already exists');

        // Store user in SharedPreferences
        await SessionManager.saveUserSession(
          userId: exitUser.id,
          username: exitUser.username,
        );

        // Show success at TOP
        AppSnackbar.showSnackbar(context, 'Welcome ${exitUser.username} ');

        // Navigate (optional)
        _clearControllers();
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);

        return;
      } else {
        _clearControllers();
        AppSnackbar.showSnackbar(context, 'User not exists');
        return;
      }
    } catch (e) {
      _clearControllers();
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      AppSnackbar.showSnackbar(context, 'Login failed: ${e.toString()}');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _clearControllers() {
    usernameController.clear();
    passwordController.clear();
  }
}
