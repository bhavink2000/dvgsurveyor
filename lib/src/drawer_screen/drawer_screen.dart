import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/drawer_screen/controller/drawer_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DrawerScreen extends GetWidget<DrawerScreenController> {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.offWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: 220.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.tealPrimary),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.offWhite,
                    child: Icon(
                      Icons.person_2_rounded,
                      size: 40,
                      color: AppColors.tealPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.userData?.username.toUpperCase() ?? '',
                    style: AppFonts.text20(context).copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  Text(
                    controller.userData?.role ?? '',
                    style: AppFonts.text14(context).copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_2_rounded,
              color: AppColors.tealDark,
            ),
            title: Text(
              'User Mangement',
              style: AppFonts.text14(context).copyWith(
                color: AppColors.tealDark,
              ),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.userMangementScreen);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person_2_rounded,
              color: AppColors.tealDark,
            ),
            title: Text(
              'Surveys',
              style: AppFonts.text14(context).copyWith(
                color: AppColors.tealDark,
              ),
            ),
            onTap: () {
              Get.toNamed(AppRoutes.surveyScreen);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: AppColors.tealDark,
            ),
            title: Text(
              'Logout',
              style: AppFonts.text14(context).copyWith(
                color: AppColors.tealDark,
              ),
            ),
            onTap: controller.logout,
          ),
        ],
      ),
    );
  }
}
