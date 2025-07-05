import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashScreenController = Provider((ref) => SplashScreenController());

class SplashScreenController {
  late AnimationController logoController;
  late Animation<Offset> logoAnimation;
  late Animation<Offset> textLeftAnimation;
  late Animation<Offset> textRightAnimation;
  late Animation<double> opacityAnimation;

  void initAnimation(TickerProvider vsync) {
    logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    // Logo moves up
    logoAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.3),
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // "DVG" moves left
    textLeftAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-0.05, 0),
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );

    // "Surveyor" moves right
    textRightAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.05, 0),
    ).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Fade in animation
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

  Future<void> initApp(BuildContext context) async {
    await logoController.forward();
    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      final isUserLoggedIn = await SessionManager.isLoggedIn();
      if (isUserLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcomeScreen);
      }
    }
  }

  void dispose() {
    logoController.dispose();
  }
}
