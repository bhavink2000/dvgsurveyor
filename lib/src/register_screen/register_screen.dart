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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          margin:
              EdgeInsets.only(top: 0.h, left: 24.w, right: 28.w, bottom: 12.h),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${AppConst.createAccount} \n${AppConst.appName}!',
                      style: AppFonts.text20(context).copyWith(
                        color: AppColors.tealPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppConst.fillInYourDetails,
                      style: AppFonts.text14(context).copyWith(
                        color: AppColors.almostBlack,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.firstNameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.firstName,
                    prefixIcon: Icon(Icons.person, color: AppColors.tealDark),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateFirstName,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.lastNameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.lastName,
                    prefixIcon: Icon(Icons.person_2, color: AppColors.tealDark),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateLastName,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: AppConst.phoneNumber,
                    prefixIcon: Icon(Icons.phone, color: AppColors.tealDark),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: controller.validatePhoneNumber,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: controller.usernameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.username,
                    prefixIcon: Icon(Icons.person_3, color: AppColors.tealDark),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: controller.validateUsername,
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => CustomTextField(
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppConst.password,
                        prefixIcon: Icon(Icons.lock, color: AppColors.tealDark),
                        textCapitalization: TextCapitalization.none,
                        textAlign: TextAlign.start,
                        textInputAction: TextInputAction.done,
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.tealDark,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        validator: controller.validatePassword,
                      )),
                  SizedBox(height: 20.h),
                  Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealPrimary,
                          padding: EdgeInsets.symmetric(
                              horizontal: 36.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          if (controller.isLoading.value == false) {
                            if (controller.formKey.currentState!.validate()) {
                              controller.registerUser();
                            }
                          }
                        },
                        child: SizedBox(
                          height: 20.h,
                          child: Center(
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      backgroundColor: AppColors.tealPrimary,
                                      color: AppColors.offWhite,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppConst.createAccount,
                                    style: AppFonts.text14(context).copyWith(
                                      color: AppColors.offWhite,
                                    ),
                                  ),
                          ),
                        ),
                      )),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
