import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/src/pending_surveys_screen/controller/pending_survey_controller.dart';
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
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredSurveys.length,
                itemBuilder: (context, index) {
                  final survey = controller.filteredSurveys[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 1.5,
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 18,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                size: 18, color: Colors.blue),
                            onPressed: () async {
                              if (controller.userData.value?.role == 'Govt') {
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
                                // Refresh the survey list after coming back
                                controller
                                    .fetchPendingSurveys(); // or whatever method reloads the list
                              });
                            },
                          ),
                          Visibility(
                            visible: controller.userData.value?.role == 'Admin',
                            child: Obx(() {
                              final isDeleting =
                                  controller.deletingIndex.value == index;
                              return isDeleting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.red),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.delete,
                                          size: 18, color: Colors.red),
                                      onPressed: () => controller.deleteSurvey(
                                          survey.id, index),
                                    );
                            }),
                          )
                        ],
                      ),
                      onTap: () {
                        // Navigate to detail or edit
                        //Get.snackbar("Survey Selected", survey.id);
                      },
                    ),
                  );
                },
              ),
            ),
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
