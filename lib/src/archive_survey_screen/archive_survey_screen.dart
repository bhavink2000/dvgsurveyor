import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/gam_model.dart';
import 'package:dvgsurveyor/src/archive_survey_screen/controller/archive_survey_controller.dart';
import 'package:dvgsurveyor/utils/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchiveSurveyScreen extends GetWidget<ArchiveSurveyController> {
  const ArchiveSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F7), // Light grey background
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          AppConst.archiveSurvey,
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// City Selection Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() {
                return Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<GamModel?>(
                        value: controller.selectedCity.value.isEmpty
                            ? null
                            : controller.cityData.firstWhereOrNull((city) =>
                                city.name == controller.selectedCity.value),
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.85),
                          hintText: "Select a city",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: AppColors.tealPrimary),
                          ),
                        ),
                        icon: controller.isCityLoad.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.arrow_drop_down),
                        items: [
                          DropdownMenuItem<GamModel>(
                            value: null,
                            child: Text(
                              'Select City',
                              style: AppFonts.text14(context).copyWith(
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ),
                          ...controller.cityData.map((city) {
                            return DropdownMenuItem<GamModel>(
                              value: city,
                              child: Text(
                                city.name.capitalizeFirst ?? '',
                                style: AppFonts.text14(context),
                              ),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectedCity.value = val.name;
                            controller.fetchSurveyDataByCity();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 24),

            /// Survey Summary Card
            Obx(() {
              final selected = controller.selectedCity.value;
              final surveyData = controller.surveyData;
              if (selected.isEmpty) return const SizedBox();

              // Worker Summary Mapping
              final Map<String, int> workerCountMap = {};
              for (var survey in surveyData) {
                final worker = survey.userName;
                workerCountMap[worker] = (workerCountMap[worker] ?? 0) + 1;
              }

              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      children: [
                        Icon(Icons.dashboard_customize,
                            color: Colors.teal.shade700),
                        const SizedBox(width: 10),
                        Text(
                          "Survey Overview",
                          style: AppFonts.text20(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.tealDark,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                        height: 30, thickness: 1.2, color: Color(0xFFDDDDDD)),

                    /// City + Total Count
                    Row(
                      children: [
                        Icon(Icons.location_city_outlined,
                            color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text("City: ", style: AppFonts.text16(context)),
                        Text(selected.capitalizeFirst ?? '',
                            style: AppFonts.text14(context)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.assignment_turned_in_rounded,
                            color: Colors.orange.shade700),
                        const SizedBox(width: 8),
                        Text("Total Surveys: ",
                            style: AppFonts.text16(context)),
                        Text("${surveyData.length}",
                            style: AppFonts.text14(context)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Worker Survey Breakdown
                    Text(
                      "Worker Breakdown",
                      style: AppFonts.text16(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...workerCountMap.entries.map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.teal.shade200,
                                radius: 10,
                                child: Text(
                                  e.key.substring(0, 1).toUpperCase(),
                                  style: AppFonts.text14(context).copyWith(
                                    color: AppColors.offWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: AppFonts.text14(context).copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                "${e.value} surveys",
                                style: AppFonts.text14(context)
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(height: 24),

                    /// Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.showDialogArchiveSurvey();
                            },
                            icon: Icon(
                              Icons.archive_rounded,
                              color: AppColors.offWhite,
                            ),
                            label: Text(
                              "Archive",
                              style: AppFonts.text16(context).copyWith(
                                color: AppColors.offWhite,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.deepSea,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (controller.selectedCity.value.isNotEmpty) {
                                if (controller.surveyData.isNotEmpty) {
                                  final service = ExcelService();
                                  final List<Map<String, dynamic>> dataList =
                                      controller.surveyData
                                          .map((e) => e.toJson())
                                          .toList();

                                  await service.generateAndSaveExcel(dataList);
                                } else {
                                  AppSnackbar.showSnackbar(
                                    title: 'No Data',
                                    message:
                                        'No surveys available for ${selected.capitalizeFirst}',
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              Icons.file_download,
                              color: AppColors.offWhite,
                            ),
                            label: Text(
                              "Excel",
                              style: AppFonts.text16(context).copyWith(
                                color: AppColors.offWhite,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
