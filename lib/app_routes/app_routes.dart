import 'package:dvgsurveyor/src/dashboard/binding/dashboard_binding.dart';
import 'package:dvgsurveyor/src/dashboard/dashboard.dart';
import 'package:dvgsurveyor/src/login_screen/binding/login_binding.dart';
import 'package:dvgsurveyor/src/login_screen/login_screen.dart';
import 'package:dvgsurveyor/src/register_screen/binding/register_binding.dart';
import 'package:dvgsurveyor/src/register_screen/register_screen.dart';
import 'package:dvgsurveyor/src/splash_screen/binding/splash_screen_binding.dart';
import 'package:dvgsurveyor/src/splash_screen/splash_screen.dart';
import 'package:dvgsurveyor/src/welcome_screen/binding/welcome_binding.dart';
import 'package:dvgsurveyor/src/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String dashScreen = '/dashboard_screen';
  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      bindings: [
        SplashScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: welcomeScreen,
      page: () => const WelcomeScreen(),
      bindings: [
        WelcomeBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: registerScreen,
      page: () => const RegisterScreen(),
      bindings: [
        RegisterBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: dashScreen,
      page: () => const DashboardScreen(),
      bindings: [
        DashboardBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
  ];
}
