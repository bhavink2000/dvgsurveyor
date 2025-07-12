import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<Offset> logoAnimation;
  late Animation<double> opacityAnimation;

  @override
  void onInit() {
    super.onInit();
    initAnimation(); // initialize animations
  }

  @override
  void onReady() {
    super.onReady();
    initApp(); // only safe to call navigation after context is ready
  }

  void initAnimation() {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this, // uses GetSingleTickerProviderStateMixin
    );

    logoAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.3),
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.5, 1, curve: Curves.easeIn),
      ),
    );

    logoController.forward();
  }

  Future<void> initApp() async {
    await logoController.forward();
    await Future.delayed(const Duration(seconds: 1));

    final isUserLoggedIn = await SessionManager.isLoggedIn();
    if (isUserLoggedIn) {
      Get.offNamed(AppRoutes.dashScreen);
    } else {
      Get.offNamed(AppRoutes.welcomeScreen);
    }
  }

  @override
  void onClose() {
    logoController.dispose();
    super.onClose();
  }
}
