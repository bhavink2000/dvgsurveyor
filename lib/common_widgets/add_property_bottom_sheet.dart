import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/property_screen/controller/property_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPropertyBottomSheet extends GetWidget<PropertyScreenController> {
  final bool isEdit;

  const AddPropertyBottomSheet({super.key, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: controller.engProperty,
                labelText: 'English Name',
                readOnly: isEdit,
                validator: controller.validateField,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: controller.gujProperty,
                labelText: 'Gujarati Name',
                validator: controller.validateField,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Is Active',
                    style: AppFonts.text14(context).copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Obx(
                    () => Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: controller.isActive.value,
                        onChanged: (val) => controller.isActive.value = val,
                        activeColor: AppColors.tealDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => controller.onSubmit(
                      isEdit: isEdit,
                      existingProperty: controller.editingProperty,
                      isDelete: false,
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            isEdit ? 'Update' : 'Add',
                            style: AppFonts.text14(context)
                                .copyWith(color: AppColors.offWhite),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
