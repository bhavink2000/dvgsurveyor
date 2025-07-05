import 'package:dvgsurveyor/src/login_screen/login_screen.dart';
import 'package:dvgsurveyor/src/register_screen/register_screen.dart';
import 'package:dvgsurveyor/src/splash_screen/splash_screen.dart';
import 'package:dvgsurveyor/src/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {

  static const String splashScreen = '/splash-screen';
  static const String welcomeScreen = '/welcome-screen';
  static const String homeScreen = '/home-screen';
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case welcomeScreen:
       return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      // case homeScreen:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
 
}