import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
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
        onPressed: () => Get.toNamed(AppRoutes.surveyorFormScreen),
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
                    'Welcome, ${controller.userData?.firstName ?? ''}',
                    style: AppFonts.text20(context).copyWith(
                      color: AppColors.offWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Here is your dashboard',
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
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ───── Horizontal Filter Chips ─────
                    Obx(() => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.filterLabels
                                .map((label) => Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: ChoiceChip(
                                        label: Text(label),
                                        selected:
                                            controller.selectedFilter.value ==
                                                label,
                                        selectedColor: AppColors.tealPrimary,
                                        backgroundColor: Colors.grey.shade200,
                                        labelStyle:
                                            AppFonts.text14(context).copyWith(
                                          color:
                                              controller.selectedFilter.value ==
                                                      label
                                                  ? AppColors.offWhite
                                                  : AppColors.tealPrimary,
                                          fontSize: 12,
                                        ),
                                        onSelected: (_) {
                                          controller.selectedFilter.value =
                                              label;
                                          // Optional: Call controller.loadDataForFilter(label);
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                        )),
                    SizedBox(height: 16.h),

                    // ───── Data Placeholder ─────
                    Expanded(
                      child: Center(
                        child: Text(
                          'No surveys to show yet.',
                          style: AppFonts.text14(context).copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
