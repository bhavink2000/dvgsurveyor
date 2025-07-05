
import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashScreenController = Provider((ref)=> SplashScreenController());


class SplashScreenController {
  Future<void> initApp(BuildContext context)async{
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the next screen after the splash screen  
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }
}