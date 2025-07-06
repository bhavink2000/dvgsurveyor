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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //We take the image from the assets
          Lottie.asset(
            AppImages.dvgWelcomeGif,
            width: 500.w,
            height: 200.h,
          ),
          SizedBox(
            height: 20,
          ),
          //Texts and Styling of them
          Text(
            AppConst.welcomeToDVG,
            textAlign: TextAlign.center,
            style: AppFonts.text20(context).copyWith(
                color: AppColors.offWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            AppConst.welcomeMessage,
            textAlign: TextAlign.center,
            style: AppFonts.text14(context).copyWith(
              color: AppColors.offWhite,
            ),
          ),
          SizedBox(
            height: 30,
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.offWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
            onPressed: () {
              controller.onGetStarted(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.tealPrimary,
                ),
              ],
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }
}
