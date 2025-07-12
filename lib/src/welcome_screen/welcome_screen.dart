import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:dvgsurveyor/src/welcome_screen/controller/welcome_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends GetWidget<WelcomeScreenController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tealPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),

              /// Animation
              Lottie.asset(
                AppImages.dvgWelcomeGif,
                width: 280.w,
                height: 180.h,
                fit: BoxFit.contain,
              ),

              SizedBox(height: 24.h),

              /// Main Heading
              Text(
                AppConst.welcomeToDVG,
                textAlign: TextAlign.center,
                style: AppFonts.text20(context).copyWith(
                  color: AppColors.offWhite,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 16.h),

              /// Subheading Message
              Text(
                AppConst.welcomeMessage,
                textAlign: TextAlign.center,
                style: AppFonts.text14(context).copyWith(
                  color: AppColors.offWhite.withValues(alpha: 0.9),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 40.h),

              /// Get Started Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.offWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 32.w),
                  elevation: 2,
                ),
                onPressed: () {
                  controller.onGetStarted(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppConst.getStarted,
                      style: AppFonts.text16(context).copyWith(
                        color: AppColors.tealPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.tealPrimary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// Optional Footer (like version info)
              Text(
                "${AppConst.appName} ${AppConst.appVersion}",
                style: AppFonts.text14(context).copyWith(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
