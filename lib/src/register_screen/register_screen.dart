import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/register_screen/controller/register_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final registerCon = ref.read(registerController.notifier);
    final state = ref.watch(registerController);

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
              key: registerCon.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${AppConst.createAccount} \n${AppConst.appName}!',
                      textAlign: TextAlign.start,
                      style: AppFonts.text20(context).copyWith(
                          color: AppColors.tealPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
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
                  SizedBox(
                    height: 16.h,
                  ),
                  CustomTextField(
                    controller: registerCon.firstNameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.firstName,
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.tealDark,
                    ),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: registerCon.validateFirstName,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: registerCon.lastNameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.lastName,
                    prefixIcon: Icon(
                      Icons.person_2,
                      color: AppColors.tealDark,
                    ),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: registerCon.validateLastName,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: registerCon.phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: AppConst.phoneNumber,
                    prefixIcon: Icon(
                      Icons.person_2,
                      color: AppColors.tealDark,
                    ),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: registerCon.validatePhoneNumber,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: registerCon.usernameController,
                    keyboardType: TextInputType.name,
                    hintText: AppConst.username,
                    prefixIcon: Icon(
                      Icons.person_3,
                      color: AppColors.tealDark,
                    ),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    validator: registerCon.validateUsername,
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: registerCon.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: AppConst.password,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: AppColors.tealDark,
                    ),
                    textCapitalization: TextCapitalization.none,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.next,
                    obscureText: !state.isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.tealDark,
                      ),
                      onPressed: registerCon.togglePasswordVisibility,
                    ),
                    validator: registerCon.validatePassword,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealPrimary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 36.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      if (!state.isLoading &&
                          registerCon.formKey.currentState!.validate()) {
                        registerCon.registerUser(context: context);
                      }
                    },
                    child: SizedBox(
                      height: 20.h,
                      child: Center(
                        child: state.isLoading
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
                  ),
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
