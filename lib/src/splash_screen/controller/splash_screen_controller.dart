import 'dart:async';

import 'package:dvgsurveyor/api_repo/auth_repo.dart';
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthRepo authRepo;
  SplashScreenController({required this.authRepo});

  late AnimationController _controller;
  late Animation<Offset> logoAnimation;
  late Animation<double> opacityAnimation;

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
  }

  @override
  void onReady() {
    super.onReady();
    _startAppFlow();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    logoAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    ));

    _controller.forward();
  }

  Future<void> _startAppFlow() async {
    await Future.delayed(const Duration(seconds: 3));
    final isUserLoggedIn = SessionManager.isLoggedIn();

    if (isUserLoggedIn) {
      final userId = SessionManager.getUser();
      if (userId != null) {
        _startUserListener(userId.id);
      }

      Get.offNamed(AppRoutes.dashScreen);
    } else {
      Get.offNamed(AppRoutes.welcomeScreen);
    }
  }

  StreamSubscription? userListener;

  void _startUserListener(String userId) {
    // Cancel old listener if exists
    userListener?.cancel();

    userListener = authRepo.listenUser(userId).listen((user) {
      if (user == null) return;

      if (user.isActive == false) {
        forceLogout("Your account was deactivated by Admin.");
      }
    });
  }

  Future<void> forceLogout(String message) async {
    userListener?.cancel();
    await SessionManager.clearSession();

    Get.offAllNamed(AppRoutes.welcomeScreen);

    if (message.isNotEmpty) {
      AppSnackbar.showSnackbar(message: message, title: 'Access Denied');
    }
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}
