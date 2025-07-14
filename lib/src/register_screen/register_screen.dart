import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/register_screen/controller/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetWidget<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.tealPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Title
                Text(
                  '${AppConst.createAccount} \n${AppConst.appName}!',
                  style: AppFonts.text20(context).copyWith(
                    color: AppColors.tealPrimary,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),

                /// Subtitle
                Text(
                  AppConst.fillInYourDetails,
                  style: AppFonts.text14(context).copyWith(
                    color: AppColors.almostBlack,
                  ),
                ),

                SizedBox(height: 28.h),

                /// First Name
                CustomTextField(
                  controller: controller.firstNameController,
                  keyboardType: TextInputType.name,
                  hintText: AppConst.firstName,
                  prefixIcon: Icon(Icons.person, color: AppColors.tealDark),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: controller.validateFirstName,
                ),
                SizedBox(height: 16.h),

                /// Last Name
                CustomTextField(
                  controller: controller.lastNameController,
                  keyboardType: TextInputType.name,
                  hintText: AppConst.lastName,
                  prefixIcon: Icon(Icons.person_2, color: AppColors.tealDark),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: controller.validateLastName,
                ),
                SizedBox(height: 16.h),

                /// Phone
                CustomTextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: AppConst.phoneNumber,
                  prefixIcon: Icon(Icons.phone, color: AppColors.tealDark),
                  textInputAction: TextInputAction.next,
                  validator: controller.validatePhoneNumber,
                ),
                SizedBox(height: 16.h),

                /// Username
                CustomTextField(
                  controller: controller.usernameController,
                  keyboardType: TextInputType.name,
                  hintText: AppConst.username,
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppColors.tealDark),
                  textInputAction: TextInputAction.next,
                  validator: controller.validateUsername,
                ),
                SizedBox(height: 16.h),

                /// Password
                Obx(() => CustomTextField(
                      controller: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: AppConst.password,
                      prefixIcon: Icon(Icons.lock, color: AppColors.tealDark),
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

                /// Submit Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          if (!controller.isLoading.value &&
                              controller.registerFormKey.currentState!.validate()) {
                            controller.registerUser();
                          }
                        },
                        child: controller.isLoading.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.offWhite),
                                ),
                              )
                            : Text(
                                AppConst.createAccount,
                                style: AppFonts.text14(context).copyWith(
                                  color: AppColors.offWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
