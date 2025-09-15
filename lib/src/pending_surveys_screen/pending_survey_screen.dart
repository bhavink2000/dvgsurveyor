import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/src/pending_surveys_screen/controller/pending_survey_controller.dart';
import 'package:dvgsurveyor/utils/excel_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PendingSurveyScreen extends GetWidget<PendingSurveyController> {
  const PendingSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          'Pending Surveys',
          style: AppFonts.text20(context).copyWith(color: AppColors.offWhite),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingSurveys.isEmpty) {
          return const Center(child: Text("📭 No Pending Surveys"));
        }

        return Column(
          children: [
            _buildSearchUI(context),

            // ✅ Selection mode toggle
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        controller.isSelectionMode.toggle();
                        controller.selectedSurveys.clear();
                      },
                      icon: Icon(
                        controller.isSelectionMode.value
                            ? Icons.close
                            : Icons.check_box,
                        color: Colors.teal,
                      ),
                      label: Text(
                        controller.isSelectionMode.value
                            ? "Cancel Selection"
                            : "Select Surveys",
                        style: AppFonts.text14(context).copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: VerticalDivider(color: Colors.grey.shade400),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final service = ExcelService();
                        final List<Map<String, dynamic>> dataList = controller
                            .filteredSurveys
                            .map((e) => e.toJson())
                            .toList();

                        await service.generateAndSaveExcel(dataList);
                      },
                      label: Text(
                        'Excel Download',
                        style: AppFonts.text14(context).copyWith(
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: Icon(Icons.file_download_outlined),
                    )
                  ],
                )),
            SizedBox(height: 12),

            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.filteredSurveys.length,
                    itemBuilder: (context, index) {
                      final survey = controller.filteredSurveys[index];
                      //final isSelected =controller.selectedSurveys.contains(survey.id);

                      return Card(
                        key: ValueKey(survey.id),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 1.5,
                        child: ListTile(
                          dense: true,
                          leading: Obx(() {
                            if (controller.isSelectionMode.value) {
                              final isSelected = controller.selectedSurveys
                                  .contains(survey.id);
                              return Checkbox(
                                value: isSelected,
                                onChanged: (_) =>
                                    controller.toggleSelection(survey.id),
                              );
                            } else {
                              return CircleAvatar(
                                backgroundColor: Colors.teal,
                                radius: 18,
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              );
                            }
                          }),
                          title: Text(
                            survey.ownerName.isNotEmpty
                                ? survey.ownerName
                                : "— માલિકનું નામ",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            survey.rentPersonName.isNotEmpty
                                ? "કબજેદાર: ${survey.rentPersonName}"
                                : "કબજેદાર: —",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                          trailing: controller.isSelectionMode.value
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          size: 18, color: Colors.blue),
                                      onPressed: () {
                                        if (controller.userData.value?.role ==
                                            'Govt') {
                                          AppSnackbar.showSnackbar(
                                            title: 'Access Denied',
                                            message:
                                                'You do not have permission to access this feature.',
                                          );
                                          return;
                                        }
                                        Get.toNamed(
                                          AppRoutes.surveyorFormScreen,
                                          arguments: {
                                            'isEdit': true,
                                            'surveyData': survey,
                                            'isPending': true,
                                          },
                                        )?.then((_) {
                                          controller.fetchPendingSurveys();
                                        });
                                      },
                                    ),
                                    Visibility(
                                      visible:
                                          controller.userData.value?.role ==
                                              'Admin',
                                      child: Obx(() {
                                        final isDeleting =
                                            controller.deletingIndex.value ==
                                                index;
                                        return isDeleting
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.red),
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.delete,
                                                    size: 18,
                                                    color: Colors.red),
                                                onPressed: () =>
                                                    controller.deleteSurvey(
                                                        survey.id, index),
                                              );
                                      }),
                                    )
                                  ],
                                ),
                        ),
                      );
                    },
                  )),
            ),

            // ✅ Bottom actions (only show in selection mode)
            Obx(() => controller.isSelectionMode.value
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, -2))
                      ],
                    ),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.deleteSelectedSurveys,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                          icon: Icon(Icons.delete),
                          label: Text("Delete Selected"),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: controller.deleteAllSurveys,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white),
                          icon: Icon(Icons.delete_forever),
                          label: Text("Delete All"),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink()),
          ],
        );
      }),
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
                  Expanded(
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => controller.applySearch(value),
                      ),
                    ),
                  ),
                  // if (controller.userData.value?.role == 'Admin')
                  //   SizedBox(width: 8),
                  // if (controller.userData.value?.role == 'Admin')
                  //   TextButton(
                  //     onPressed: controller.clearSearchFilters,
                  //     child: Text(
                  //       'Clear',
                  //       style: AppFonts.text14(context).copyWith(
                  //         color: Colors.teal.shade700,
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
