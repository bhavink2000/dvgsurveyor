import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final controller = ref.read(splashScreenController);
    controller.initAnimation(this);
    controller.initApp(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(splashScreenController);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: controller.logoAnimation,
              child: Image.asset(
                AppImages.dvgLogo,
                width: 200,
                height: 200,
              ),
            ),
            FadeTransition(
              opacity: controller.opacityAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlideTransition(
                    position: controller.textLeftAnimation,
                    child: Text(
                      AppConst.dvg,
                      style: AppFonts.text20(context).copyWith(
                        fontSize: 24,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                  ),
                  //const SizedBox(width: 8),
                  SlideTransition(
                    position: controller.textRightAnimation,
                    child: Text(
                      AppConst.surveyor,
                      style: AppFonts.text20(context).copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
