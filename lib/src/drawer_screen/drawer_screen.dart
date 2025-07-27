import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
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
      width: 220.w,
      backgroundColor: AppColors.offWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // ───── Drawer Header ─────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: AppColors.tealPrimary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.r),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.offWhite,
                    child: Icon(Icons.person,
                        size: 32.sp, color: AppColors.tealPrimary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    controller.userData?.username.toUpperCase() ??
                        AppConst.userNm,
                    style: AppFonts.text16(context).copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    controller.userData?.role ?? AppConst.user,
                    style: AppFonts.text14(context).copyWith(
                      color: AppColors.offWhite.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ───── Menu Items ─────
          SizedBox(height: controller.userData?.role == 'Admin' ? 16.h : 0.h),
          controller.userData?.role == 'Admin'
              ? _buildDrawerItem(
                  icon: Icons.supervisor_account,
                  title: AppConst.userManagement,
                  onTap: () => Get.toNamed(AppRoutes.userMangementScreen),
                  context: context,
                )
              : SizedBox(),

          controller.userData?.role == 'Admin'
              ? _buildDrawerItem(
                  icon: Icons.category_rounded,
                  title: AppConst.propertType,
                  onTap: () => Get.toNamed(AppRoutes.propertyTypeScreen),
                  context: context,
                )
              : SizedBox(),
          controller.userData?.role == 'Admin'
              ? _buildDrawerItem(
                  icon: Icons.description_rounded,
                  title: AppConst.propertyDesc,
                  onTap: () => Get.toNamed(AppRoutes.propertyDescScreen),
                  context: context,
                )
              : SizedBox(),
          controller.userData?.role == 'Admin'
              ? _buildDrawerItem(
                  icon: Icons.location_city_rounded,
                  title: AppConst.cityManagement,
                  onTap: () => Get.toNamed(AppRoutes.cityScreen),
                  context: context,
                )
              : SizedBox(),
          _buildDrawerItem(
            icon: Icons.assignment_outlined,
            title: AppConst.surveys,
            onTap: () => Get.toNamed(AppRoutes.surveyScreen),
            context: context,
          ),
          controller.userData?.role == 'Admin'
              ? _buildDrawerItem(
                  icon: Icons.archive_rounded,
                  title: AppConst.archiveSurvey,
                  onTap: () => Get.toNamed(AppRoutes.archiveSurveyScreen),
                  context: context,
                )
              : SizedBox(),
          const Spacer(),
          Divider(thickness: 1, indent: 16.w, endIndent: 16.w),
          _buildDrawerItem(
            icon: Icons.logout,
            title: AppConst.logout,
            onTap: controller.logout,
            context: context,
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      leading: Icon(icon, color: AppColors.tealDark, size: 22.sp),
      title: Text(
        title,
        style: AppFonts.text14(context).copyWith(
          color: AppColors.tealDark,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      hoverColor: AppColors.tealPrimary.withOpacity(0.1),
    );
  }
}
