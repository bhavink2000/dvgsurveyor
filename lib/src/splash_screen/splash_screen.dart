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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: controller.logoAnimation,
              child: Image.asset(
                AppImages.dvgWel,
                width: 300.w,
                height: 300.h,
              ),
            ),
            SizedBox(height: 150.h),
          ],
        ),
      ),
    );
  }
}
