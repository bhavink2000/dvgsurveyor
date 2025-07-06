import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_padding.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:dvgsurveyor/src/drawer_screen/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the controller to fetch user data
    final controller = ref.read(dashboardController);
    controller.getUserDataFromSesstion();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(dashboardController);
    final controller = ref.watch(dashboardController);

    return Scaffold(
      backgroundColor: AppColors.tealPrimary,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu, color: AppColors.offWhite),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                Text(
                  AppConst.appName,
                  style: AppFonts.text20(context).copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${controller.userName}',
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
                          color: AppColors.offWhite,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ).paddingOnly(left: 16.w),
                ),
                Container(
                  width: 50.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.offWhite,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: AppColors.tealPrimary,
                      size: 20,
                    ),
                  ),
                ).paddingOnly(right: 16.w),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
