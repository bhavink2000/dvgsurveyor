import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends GetWidget<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              children: [
                SizedBox(height: 32.h),

                /// Logo or Title Block
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppConst.welcomeTo} \n${AppConst.appName}!',
                        style: AppFonts.text20(context).copyWith(
                          color: AppColors.tealPrimary,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        AppConst.enterYourDetails,
                        style: AppFonts.text14(context).copyWith(
                          color: AppColors.almostBlack,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                /// Username
                CustomTextField(
                  controller: controller.usernameController,
                  keyboardType: TextInputType.name,
                  hintText: AppConst.username,
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppColors.tealDark),
                  textCapitalization: TextCapitalization.none,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  validator: controller.validateUsername,
                ),

                SizedBox(height: 16.h),

                /// Password with toggle
                Obx(() => CustomTextField(
                      controller: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: AppConst.password,
                      prefixIcon:
                          Icon(Icons.lock_outline, color: AppColors.tealDark),
                      obscureText: !controller.isPasswordVisible.value,
                      textInputAction: TextInputAction.done,
                      validator: controller.validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColors.tealDark,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),

                SizedBox(height: 28.h),

                /// Login Button
                Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (!controller.isLoading.value &&
                            controller.loginFormKey.currentState!.validate()) {
                          controller.login();
                        }
                      },
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: AppColors.offWhite,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppConst.login,
                              style: AppFonts.text14(context).copyWith(
                                color: AppColors.offWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    )),

                SizedBox(height: 24.h),

                /// Sign up prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConst.dontHaveAnAccount,
                      style: AppFonts.text14(context).copyWith(
                        color: AppColors.almostBlack,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.registerScreen);
                      },
                      child: Text(
                        AppConst.signUp,
                        style: AppFonts.text14(context).copyWith(
                          color: AppColors.tealPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// Version Label
                Text(
                  "${AppConst.surveyor} ${AppConst.appVersion}",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
