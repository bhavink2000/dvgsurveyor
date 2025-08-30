import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/localization/gujarati_translations.dart';
import 'package:dvgsurveyor/src/surveyor_form/controller/surveyor_form_screen_controller.dart';
import 'package:dvgsurveyor/src/surveyor_form/widgets/location_pick_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OffPropertyWidget extends GetWidget<SurveyorFormScreenController> {
  const OffPropertyWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInput(
          FormLabels.junagharNumber,
          controller.junagharNumber,
          keyboardType: TextInputType.number,
          validator: (value) {
            return null;
          },
        ),
        buildInput(
          FormLabels.ownerName,
          controller.ownerName,
          validator: (value) {
            return null;
          },
        ),
        buildInput(
          FormLabels.mobileNumber,
          controller.mobileNumber,
          keyboardType: TextInputType.number,
          validator: (value) {
            return null;
          },
        ),
        buildInput(
          FormLabels.address,
          controller.address,
          validator: (value) {
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 175.w,
              child: buildInput(
                FormLabels.remarks,
                controller.remarks,
                validator: (value) {
                  return null;
                },
              ),
            ),
            ElevatedButton(
              child: Text(
                "Pick Location",
                style: AppFonts.text14(context)
                    .copyWith(fontSize: 12, color: AppColors.offWhite),
              ),
              onPressed: () {
                Get.to(() => LocationPickerScreen());
              },
            ),
          ],
        ),
        Obx(() => controller.isOffProperty.value
            ? SizedBox(
                height: 16.h,
              )
            : SizedBox.shrink()),
        SizedBox(height: 16.h),
        Obx(
          () => ElevatedButton(
            onPressed: controller.closePropertySubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealDark,
            ),
            child: controller.isFormSubmit.value
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.offWhite,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    controller.isEditMode.value == true ? 'Update' : 'Submit',
                    style: AppFonts.text16(context).copyWith(
                      color: AppColors.offWhite,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildInput(String labelKey, TextEditingController ctrl,
      {TextInputType? keyboardType,
      String? Function(String?)? validator,
      bool? isReadOny = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CustomTextField(
        contentPadding: EdgeInsets.only(left: 12),
        controller: ctrl,
        readOnly: isReadOny ?? false,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        labelText: labelKey.tr,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return '${labelKey.tr} જરૂરી છે';
              }
              return null;
            },
      ),
    );
  }
}
