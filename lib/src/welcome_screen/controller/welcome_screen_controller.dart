import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final welcomeController = Provider((ref) => WelcomeScreenController());

class WelcomeScreenController {
  // Add your controller logic here
  // For example, you can define methods to handle user interactions
  // or manage the state of the welcome screen.

  void onGetStarted(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }
}
