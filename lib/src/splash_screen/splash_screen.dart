import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends GetWidget<SplashScreenController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: controller.opacityAnimation,
          child: SlideTransition(
            position: controller.logoAnimation,
            child: Image.asset(
              AppImages.dvgWel,
              width: 220.w,
              height: 220.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
