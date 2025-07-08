import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/localization/gujarati_translations.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/src/surveyor_form/controller/surveyor_form_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SurveyorFormScreen extends GetWidget<SurveyorFormScreenController> {
  const SurveyorFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.tealPrimary,
        iconTheme: IconThemeData(color: AppColors.offWhite),
        title: Text(
          'Survey Form',
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            children: [
              buildInput(
                FormLabels.ownerName,
                controller.ownerName,
              ),
              buildInput(
                FormLabels.junagharNumber,
                controller.junagharNumber,
                keyboardType: TextInputType.number,
              ),
              buildInput(
                FormLabels.kabjedarName,
                controller.kabjedarName,
              ),
              buildInput(
                FormLabels.address,
                controller.address,
              ),
              Obx(() {
                return LabeledDropdownRow<UsageTypeModel>(
                  label: FormLabels.usageType.tr,
                  controller: controller.usageType,
                  selectedId: controller.selectedUsageId,
                  items: controller.usageData,
                  isLoading: controller.isUsageLoad.value,
                  onChanged: (val) => controller.selectedUsageId = val,
                );
              }),
              buildInput(
                FormLabels.mobileNumber,
                controller.mobileNumber,
                keyboardType: TextInputType.phone,
              ),
              // PROPERTY TYPE DROPDOWN
              Obx(() {
                return LabeledDropdownRow<PropertyTypeModel>(
                  label: FormLabels.propertyType.tr,
                  controller: controller.propertyType,
                  selectedId: controller.selectedPropertyType,
                  items: controller.propertyData, // Ensure unique items
                  isLoading: controller.isPropertyTypeLoad.value,
                  onChanged: (val) {
                    // Clear the second dropdown value when the first dropdown changes
                    controller.selectedPropertyDescription =
                        null; // Clear second dropdown value

                    // Update the first dropdown value
                    controller.selectedPropertyType = val;

                    // Fetch the new data for the second dropdown
                    controller.getPropertyDescription();
                  },
                );
              }),

              // PROPERTY DESCRIPTION DROPDOWN
              Obx(() {
                return LabeledDropdownRow<PropertyDescriptionModel>(
                  label: FormLabels.propertyDescription.tr,
                  controller: controller.propertyDescription,
                  selectedId: controller.selectedPropertyDescription,
                  items: controller.propertyDesData, // Ensure unique items
                  isLoading: controller.isPropertyDesLoad.value,
                  onChanged: (val) {
                    controller.selectedPropertyDescription = val;
                  },
                );
              }),

              buildInput(
                FormLabels.waterConnectionNumber,
                controller.waterConnectionNumber,
                keyboardType: TextInputType.number,
              ),
              buildInput(
                FormLabels.constructionYear,
                controller.constructionYear,
                keyboardType: TextInputType.number,
              ),
              buildInput(
                FormLabels.totalFloors,
                controller.totalFloors,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.submitForm,
                child: Text('મોકલવો'),
              ),
            ],
          ),
        ),
      ),
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
