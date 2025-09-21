import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/helper/location_helper.dart';
import 'package:dvgsurveyor/session_manager/session_manger.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:dvgsurveyor/src/dashboard/dashboard_widget/city_wise_card.dart';
// import 'package:dvgsurveyor/src/dashboard/dashboard_widget/date_wise_card.dart';
import 'package:dvgsurveyor/src/dashboard/dashboard_widget/worker_wise_card.dart';
import 'package:dvgsurveyor/src/drawer_screen/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardScreen extends GetWidget<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tealPrimary,
      drawer: const DrawerScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasPermission = await LocationHelper().checkPermission();
          if (!hasPermission) {
            AppSnackbar.showSnackbar(
              title: 'Location Required',
              message: 'Please enable location permission to continue.',
            );
            return;
          }
          if (controller.userData.value?.role == 'Govt') {
            AppSnackbar.showSnackbar(
              title: 'Access Denied',
              message: 'You do not have permission to access this feature.',
            );
            return;
          }

          Get.toNamed(AppRoutes.surveyorFormScreen);
        },
        backgroundColor: AppColors.tealDark,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Icon(Icons.add, color: AppColors.offWhite),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── App Bar Row ─────
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: AppColors.offWhite),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppConst.appName,
                  style: AppFonts.text20(context).copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),

            // ───── Welcome Section ─────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${SessionManager.getUser()?.firstName ?? ''}',
                    style: AppFonts.text20(context).copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Here is your dashboard (${SessionManager.getUser()?.gamName ?? ''})',
                    style: AppFonts.text14(context).copyWith(
                      color: AppColors.offWhite.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // ───── Main Content ─────
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.h),
                        CityWiseCard(),
                        // SizedBox(height: 12.h),
                        // DateWiseCard(),
                        SizedBox(height: 12.h),
                        Obx(() => controller.userData.value?.role == 'Admin'
                            ? WorkerWiseCard()
                            : Container()),
                        // if (controller.userData.value?.role == 'Admin')
                        //   WorkerWiseCard(),
                        SizedBox(height: 75.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
