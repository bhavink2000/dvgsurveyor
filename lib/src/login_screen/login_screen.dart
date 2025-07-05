import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginController);
    final controller = ref.read(loginController.notifier);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          margin:
              EdgeInsets.only(top: 30.h, left: 24.w, right: 28.w, bottom: 12.h),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${AppConst.welcomeTo} \n${AppConst.appName}!',
                    textAlign: TextAlign.start,
                    style: AppFonts.text20(context).copyWith(
                        color: AppColors.tealPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    AppConst.enterYourDetails,
                    textAlign: TextAlign.start,
                    style: AppFonts.text14(context).copyWith(
                      color: AppColors.almostBlack,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: controller.usernameController,
                  keyboardType: TextInputType.name,
                  hintText: AppConst.username,
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.tealDark,
                  ),
                  textCapitalization: TextCapitalization.none,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.next,
                  validator: controller.validateUsername,
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: controller.passwordController,
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
                  validator: controller.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.tealDark,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),

                // Error Message
                if (state.error != null) ...[
                  SizedBox(height: 16.h),
                  Text(
                    state.error!,
                    style: AppFonts.text14(context).copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],

                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 36.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    if (!state.isLoading &&
                        controller.formKey.currentState!.validate()) {
                      controller.login(context);
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
                                color: AppColors.offWhite,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              AppConst.login,
                              style: AppFonts.text14(context).copyWith(
                                color: AppColors.offWhite,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConst.dontHaveAnAccount,
                      style: AppFonts.text14(context).copyWith(
                        color: AppColors.almostBlack,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.registerScreen,
                        ); // Replace with your route name
                        // Navigate to Sign Up Screen
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

                Spacer(),
                Text(
                  "Surveyor v1.0",
                  style: GoogleFonts.inter(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
