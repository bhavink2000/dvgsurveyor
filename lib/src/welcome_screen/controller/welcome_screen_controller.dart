import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreenController extends GetxController {
  void onGetStarted(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }
}
