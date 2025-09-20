// ignore_for_file: deprecated_member_use

import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:dvgsurveyor/utils/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityWiseCard extends GetWidget<DashboardController> {
  const CityWiseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Card(
        elevation: 12,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: Colors.teal.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.9), Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(2, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Dropdown
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Text(
                      'City',
                      style: AppFonts.text20(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.tealDark,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 110,
                      height: 34,
                      child: DropdownButtonFormField<GamModel?>(
                        value: controller.selectedGam.value,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                        icon: controller.isGamLoad.value ||
                                controller.cityCount.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.arrow_drop_down),
                        items: [
                          const DropdownMenuItem<GamModel>(
                            value: null,
                            child: Text(
                              'Select City',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                          ...controller.gamList.map((gam) {
                            return DropdownMenuItem<GamModel>(
                              value: gam,
                              child: Text(
                                gam.name.capitalizeFirst ?? '',
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectedGam.value = val;
                            controller.fetchCitySurveySummary();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(
                thickness: 1,
                height: 0,
                color: Colors.teal,
              ),

              // Stats Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatLabel(context, 'Total Survey'),
                        Text('${controller.cityTotalSurveyCount}',
                            style: AppFonts.text20(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.teal.shade100,
                                )
                              ],
                            )),
                        const SizedBox(height: 12),
                        _buildStatLabel(context, 'Total Area'),
                        Text('${controller.cityTotalAreaCount} sq.mt',
                            style: AppFonts.text20(context).copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.teal.shade100,
                                )
                              ],
                            )),
                      ],
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppImages.cityWise,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // Download Footer
              // Obx(
              //   () =>
              Container(
                decoration: BoxDecoration(
                  color: AppColors.tealPrimary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    if (controller.userData.value?.isExcelDownload == false) {
                      AppSnackbar.showSnackbar(
                        title: 'Download Disabled',
                        message: 'Excel download is disabled for your account',
                      );
                      return;
                    }
                    if (controller.selectedGam.value != null) {
                      if (controller.userData.value?.isExcelDownload == true) {
                        final service = ExcelService();
                        final List<Map<String, dynamic>> dataList = controller
                            .filteredSurveys
                            .map((e) => e.toJson())
                            .toList();

                        await service.generateAndSaveExcel(dataList);
                      }
                    } else {
                      AppSnackbar.showSnackbar(
                        title: 'City Not Selected',
                        message: 'Please select a city to download data',
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.excelDownload,
                          width: 34,
                          height: 34,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Download Excel',
                          style: AppFonts.text16(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatLabel(BuildContext context, String label) {
    return Text(
      label,
      style: AppFonts.text14(context).copyWith(
        color: AppColors.darkGrey,
        fontSize: 12,
      ),
    );
  }
}
