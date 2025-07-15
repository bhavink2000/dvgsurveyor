import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/property_desc_screen/controller/property_desc_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPropertyDescBottomSheet
    extends GetWidget<PropertyDescScreenController> {
  final bool isEdit;
  final bool? isNew;

  const AddPropertyDescBottomSheet(
      {super.key, required this.isEdit, this.isNew = false});

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
              if (isNew == true)
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: controller.propertyTypeData
                          .any((e) => e.id == controller.propertyTypeId)
                      ? controller.propertyTypeId
                      : null,
                  items: controller.propertyTypeData.map((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.text14(context),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selected = controller.propertyTypeData.firstWhere(
                      (item) => item.id == value,
                      orElse: () => controller.propertyTypeData.first,
                    );
                    controller.propertyTypeId = selected.id;
                  },
                  decoration: InputDecoration(
                    labelText: AppConst.propertType,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.teal),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'પસંદગી જરૂરી છે'
                      : null,
                ),
              if (isNew == true) const SizedBox(height: 12),
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
                      existingPropertyDesc: controller.editingPropertyDesc,
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
