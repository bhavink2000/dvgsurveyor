import 'package:dvgsurveyor/common_widgets/common_textfield_widget.dart';
import 'package:dvgsurveyor/common_widgets/custom_labeldropdown_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/localization/gujarati_translations.dart';
import 'package:dvgsurveyor/model/property_description_model.dart';
import 'package:dvgsurveyor/model/property_type_model.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/model/usage_model.dart';
import 'package:dvgsurveyor/src/surveyor_form/controller/surveyor_form_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                keyboardType: TextInputType.number,
              ),
              Obx(() {
                return LabeledDropdownRow<PropertyTypeModel>(
                  label: FormLabels.propertyType.tr,
                  controller: controller.propertyType,
                  selectedId: controller.selectedPropertyType.value,
                  items: controller.propertyData,
                  isLoading: controller.isPropertyTypeLoad.value,
                  onChanged: (val) {
                    controller.selectedPropertyType.value = val;
                    controller.selectedPropertyDescription.value = null;
                    controller.propertyDescription.clear();
                    controller.propertyDesData.clear();

                    controller.getPropertyDescription();
                  },
                );
              }),
              Obx(() {
                return LabeledDropdownRow<PropertyDescriptionModel>(
                  label: FormLabels.propertyDescription.tr,
                  controller: controller.propertyDescription,
                  selectedId: controller.selectedPropertyDescription.value,
                  items: controller.propertyDesData,
                  isLoading: controller.isPropertyDesLoad.value,
                  onChanged: (val) {
                    controller.selectedPropertyDescription.value = val;
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
              Obx(() => Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.tealDark,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              'Add Area',
                              style: AppFonts.text16(context).copyWith(
                                color: AppColors.offWhite,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 145.w,
                              height: 30.h,
                              child: DropdownButtonFormField<String>(
                                value: controller.baseFloors.contains(
                                        controller.selectedBaseFloor.value)
                                    ? controller.selectedBaseFloor.value
                                    : null,
                                hint: Text(
                                  "Select Floor",
                                  style: AppFonts.text14(context),
                                ),
                                items: controller.baseFloors
                                    .toSet()
                                    .map((floor) => DropdownMenuItem(
                                          value: floor.capitalizeFirst,
                                          child: Text(
                                            floor.capitalizeFirst!,
                                            style: AppFonts.text14(context)
                                                .copyWith(
                                              color: AppColors.almostBlack,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  controller.selectedBaseFloor.value = value!;
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 8),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.offWhite,
                              ),
                              height: 35,
                              width: 35,
                              child: IconButton(
                                  onPressed: () {
                                    if (controller
                                        .selectedBaseFloor.value.isNotEmpty) {
                                      controller.addNewFloorBasedOn(
                                          controller.selectedBaseFloor.value);
                                    } else {
                                      AppSnackbar.showErrorSnackbar(
                                        message: "Please select a floor to add",
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.tealDark,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: controller.areaData.entries.map((entry) {
                          final floor = entry.key;
                          final floorArea = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.tealDark,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  title: RichText(
                                    text: TextSpan(
                                      style: AppFonts.text16(context).copyWith(
                                        color: AppColors.almostBlack,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(text: floor.toUpperCase()),
                                        TextSpan(
                                          text:
                                              '  (${floorArea.totalArea.toStringAsFixed(2)} sq.mt)',
                                          style:
                                              AppFonts.text14(context).copyWith(
                                            fontSize: 11,
                                            color: AppColors.darkGrey,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons
                                          .expand_more), // This replaces default arrow
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () =>
                                            controller.removeFloor(floor),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: AppColors.coralAccent,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: controller.categories.map((cat) {
                                    final category =
                                        controller.getCategory(floorArea, cat);
                                    final items = category?.items ?? [];

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${cat.capitalizeFirst ?? ''} ',
                                                      style: AppFonts.text16(
                                                              context)
                                                          .copyWith(
                                                        color:
                                                            AppColors.tealDark,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '(${(floorArea.categoriesMap[cat]?.totalCount ?? 0).toStringAsFixed(2)})',
                                                      style: AppFonts.text14(
                                                              context)
                                                          .copyWith(
                                                        color:
                                                            AppColors.darkGrey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton.icon(
                                                  onPressed: () => controller
                                                      .addItem(floor, cat),
                                                  icon: const Icon(Icons.add,
                                                      size: 18),
                                                  label: Text(
                                                    'Add',
                                                    style:
                                                        AppFonts.text14(context)
                                                            .copyWith(
                                                      color:
                                                          AppColors.tealPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          ...List.generate(items.length, (i) {
                                            final item = items[i];
                                            final total =
                                                item.length * item.width;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Row(
                                                children: [
                                                  _numField(
                                                    context: context,
                                                    label: 'Length',
                                                    initialValue:
                                                        item.length.toString(),
                                                    onChanged: (val) =>
                                                        controller.updateItem(
                                                      floor,
                                                      cat,
                                                      i,
                                                      AreaItem(
                                                        length: double.tryParse(
                                                                val) ??
                                                            0,
                                                        width: item.width,
                                                        //count: item.count,
                                                      ),
                                                    ),
                                                  ),
                                                  _numField(
                                                    context: context,
                                                    label: 'Width',
                                                    initialValue:
                                                        item.width.toString(),
                                                    onChanged: (val) =>
                                                        controller.updateItem(
                                                      floor,
                                                      cat,
                                                      i,
                                                      AreaItem(
                                                        length: item.length,
                                                        width: double.tryParse(
                                                                val) ??
                                                            0,
                                                        //count: item.count,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4),
                                                      child: Text(
                                                        'Count: ${total.toStringAsFixed(2)}',
                                                        style: AppFonts.text14(
                                                                context)
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete_rounded,
                                                      color:
                                                          AppColors.coralAccent,
                                                    ),
                                                    onPressed: () =>
                                                        controller.removeItem(
                                                            floor, cat, i),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )),
              Obx(() => ElevatedButton(
                    onPressed: controller.submitForm,
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
                            'Submit',
                            style: AppFonts.text16(context).copyWith(
                              color: AppColors.offWhite,
                            ),
                          ),
                  )),
              SizedBox(height: 16.h),
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

  Widget _numField({
    required BuildContext context,
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: 85.w,
      height: 30.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextFormField(
          initialValue: initialValue == '0.0' ? '' : initialValue,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(
                  r'^\d{0,5}(\.\d{0,3})?$'), // up to 5 digits before and 4 after decimal
            ),
          ],
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppFonts.text14(context).copyWith(fontSize: 12),
            isDense: true,
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
