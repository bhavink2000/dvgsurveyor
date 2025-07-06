import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_padding.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
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
    final controller = ref.read(dashboardController);

    return Scaffold(
      backgroundColor: AppColors.tealPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu, color: AppColors.offWhite),
                ),
                Text(
                  AppConst.appName,
                  style: AppFonts.text20(context).copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${controller.userName}',
                  style: AppFonts.text20(context).copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Here is your dashboard',
                  style: AppFonts.text16(context).copyWith(
                    color: AppColors.offWhite,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ).paddingOnly(left: 16.w),
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
