import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
    final isUserLoggedIn = await SessionManager.isLoggedIn();

    if (isUserLoggedIn) {
      Get.offNamed(AppRoutes.dashScreen);
    } else {
      Get.offNamed(AppRoutes.welcomeScreen);
    }
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}

