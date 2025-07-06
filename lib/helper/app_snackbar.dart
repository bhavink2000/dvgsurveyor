import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void showSnackbar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    Get.snackbar(
      'Opps!', // Title (optional, leave empty)
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.tealDark,
      colorText: AppColors.offWhite,
      borderRadius: 8,
      duration: duration,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showErrorSnackbar(String message,
      {Duration duration = const Duration(seconds: 2)}) {
    Get.snackbar(
      'Error!',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 8,
      duration: duration,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
