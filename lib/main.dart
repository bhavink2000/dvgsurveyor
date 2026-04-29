import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';
import 'package:dvgsurveyor/init_binding/init_binding.dart';
import 'package:dvgsurveyor/localization/gujarati_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Checking Auto PR
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await LocationHelper().requestAllPermissions(); //  Ensure this line is added
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => GetMaterialApp(
        fallbackLocale: const Locale('en', 'US'),
        translations: GujaratiTranslations(),
        locale: const Locale('gu', 'IN'), // Gujarati only
        title: AppConst.appName,
        debugShowCheckedModeBanner: false,
        getPages: AppRoutes.pages,
        initialRoute: AppRoutes.splashScreen,
        initialBinding: InitBinding(),
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.tealPrimary,
            primaryContainer: AppColors.tealDark,
            secondary: AppColors.coralAccent,
            secondaryContainer: AppColors.sandNeutral,
            surface: Colors.white,
            onPrimary: Colors.white, // Text/icon color on primary
            onSecondary: Colors.white, // Text/icon color on secondary
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
