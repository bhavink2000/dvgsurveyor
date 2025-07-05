import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void showSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: AppFonts.text14(context).copyWith(
          color: AppColors.offWhite,
        ),
      ),
      backgroundColor: AppColors.tealDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        top: 24,
        left: 12,
        right: 12,
        bottom: 24,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showErrorSnackbar(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2)}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        top: 24,
        left: 12,
        right: 12,
        bottom: 12,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
