import 'package:dvgsurveyor/src/dashboard/binding/dashboard_binding.dart';
import 'package:dvgsurveyor/src/dashboard/dashboard.dart';
import 'package:dvgsurveyor/src/drawer_screen/binding/drawer_binding.dart';
import 'package:dvgsurveyor/src/drawer_screen/drawer_screen.dart';
import 'package:dvgsurveyor/src/login_screen/binding/login_binding.dart';
import 'package:dvgsurveyor/src/login_screen/login_screen.dart';
import 'package:dvgsurveyor/src/property_desc_screen/binding/property_desc_screen_binding.dart';
import 'package:dvgsurveyor/src/property_desc_screen/property_desc_screen.dart';
import 'package:dvgsurveyor/src/property_screen/binding/property_screen_binding.dart';
import 'package:dvgsurveyor/src/property_screen/property_screen.dart';
import 'package:dvgsurveyor/src/register_screen/binding/register_binding.dart';
import 'package:dvgsurveyor/src/register_screen/register_screen.dart';
import 'package:dvgsurveyor/src/splash_screen/binding/splash_screen_binding.dart';
import 'package:dvgsurveyor/src/splash_screen/splash_screen.dart';
import 'package:dvgsurveyor/src/survey_screen/binding/survey_screen_binding.dart';
import 'package:dvgsurveyor/src/survey_screen/survey_screen.dart';
import 'package:dvgsurveyor/src/surveyor_form/binding/surveyor_form_screen_binding.dart';
import 'package:dvgsurveyor/src/surveyor_form/surveyor_form_screen.dart';
import 'package:dvgsurveyor/src/user_mangement/binding/user_mangement_screen_binding.dart';
import 'package:dvgsurveyor/src/user_mangement/user_mangement_screen.dart';
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
  static const String drawerScreen = '/drawer_screen';
  static const String userMangementScreen = '/user_mangement_screen';
  static const String surveyorFormScreen = '/surveyor_form_screen';
  static const String surveyScreen = '/survey_screen';
  static const String propertyTypeScreen = '/property_screen';
  static const String propertyDescScreen = '/property_desc_screen';

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
    GetPage(
      name: drawerScreen,
      page: () => const DrawerScreen(),
      bindings: [
        DrawerBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: userMangementScreen,
      page: () => const UserMangementScreen(),
      bindings: [
        UserMangementScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: surveyorFormScreen,
      page: () => const SurveyorFormScreen(),
      bindings: [
        SurveyorFormScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: surveyScreen,
      page: () => const SurveyScreen(),
      bindings: [
        SurveyScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: propertyTypeScreen,
      page: () => const PropertyScreen(),
      bindings: [
        PropertyScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
    GetPage(
      name: propertyDescScreen,
      page: () => const PropertyDescScreen(),
      bindings: [
        PropertyDescScreenBinding(),
      ],
      transition: Transition.fadeIn,
      transitionDuration: 500.milliseconds,
      curve: Curves.easeIn,
    ),
  ];
}
