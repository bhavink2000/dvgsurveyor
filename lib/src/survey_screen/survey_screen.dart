import 'package:dvgsurveyor/common_widgets/survey_card_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/survey_screen/controller/survey_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SurveyScreen extends GetWidget<SurveyScreenController> {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6), // Light grey background
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          'Surveys',
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchUI(context),
          SizedBox(height: 12),
          Expanded(
            child: Obx(
              () {
                return controller.isSurveyLoad.value == true
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: controller.filteredSurveys.length,
                        itemBuilder: (context, index) {
                          var survey = controller.filteredSurveys[index];
                          return SurveyCardWidget(
                            data: survey,
                            isEditSurvey: controller.userData.value?.isEditable,
                            isDeleteSUrvey: controller.userData.value?.isDelete,
                            surveyCon: controller,
                          );
                        },
                        padding: EdgeInsets.only(bottom: 12),
                      );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Card(
        shadowColor: Colors.teal.withOpacity(0.15),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Search bar + Clear text button
              Row(
                children: [
                  controller.userData.value?.role == 'Govt'
                      ? SizedBox.shrink()
                      : Expanded(
                          child: SizedBox(
                            height: 35.h,
                            child: TextField(
                              controller: controller.searchTextController,
                              decoration: InputDecoration(
                                hintText:
                                    'Search by survey number, owner, mobile ...',
                                hintStyle: AppFonts.text14(context).copyWith(
                                  color: AppColors.almostBlack.withOpacity(0.5),
                                  fontSize: 12,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) =>
                                  controller.applySearch(value),
                            ),
                          ),
                        ),
                  if (controller.userData.value?.role == 'Admin')
                    SizedBox(width: 8),
                  //if (controller.userData.value?.role == 'Admin')
                  Obx(() {
                    return controller.userData.value?.role == 'Admin'
                        ? TextButton(
                            onPressed: controller.clearSearchFilters,
                            child: Text(
                              'Clear',
                              style: AppFonts.text14(context).copyWith(
                                color: Colors.teal.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
              SizedBox(height: 12),

              // Row 2: Filter dropdowns in a responsive Wrap
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildDropdown(
                      getFilterLabel('Gam', controller.selectedGam.value,
                          controller.gamSurveyCount),
                      controller.gamList,
                      controller.selectedGam,
                    ),
                    if (controller.userData.value?.role != 'Govt')
                      _buildDropdown(
                        getFilterLabel(
                            'Property',
                            controller.selectedPropertyType.value,
                            controller.propertySurveyCount),
                        controller.propertyTypes,
                        controller.selectedPropertyType,
                      ),
                    if (controller.userData.value?.role == 'Admin')
                      _buildDropdown(
                        getFilterLabel(
                            'Worker',
                            controller.selectedWorker.value,
                            controller.workerSurveyCount),
                        controller.workerList,
                        controller.selectedWorker,
                      ),
                    if (controller.userData.value?.role == 'Worker' ||
                        controller.userData.value?.role == 'Govt')
                      SizedBox(
                        height: 30.h,
                        child: TextButton(
                          onPressed: controller.clearSearchFilters,
                          child: Text(
                            'Clear Filters',
                            style: AppFonts.text14(context).copyWith(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFilterLabel(String baseLabel, String selectedValue, int count) {
    return selectedValue.isNotEmpty ? '$baseLabel : $count' : baseLabel;
  }

  Widget _buildDropdown(String label, List<String> items, RxString selected) {
    return SizedBox(
      width: 95.w,
      height: 30.h,
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: selected.value.isEmpty ? null : selected.value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8, bottom: 0),
            filled: true,
            labelText: label,
            labelStyle: AppFonts.text14(Get.context!).copyWith(
              color: AppColors.almostBlack,
              fontSize: 12,
            ),
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          icon: Icon(Icons.arrow_drop_down),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: AppFonts.text14(Get.context!).copyWith(
                      color: AppColors.almostBlack,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            selected.value = val ?? '';
            controller.applySearch();
          },
        ),
      ),
    );
  }
}
