import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/pending_surveys_screen/controller/pending_survey_controller.dart';
import 'package:flutter/material.dart';
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

        return ListView.builder(
          itemCount: controller.pendingSurveys.length,
          itemBuilder: (context, index) {
            final survey = controller.pendingSurveys[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () {
                        //Get.snackbar("Edit", "Editing ${survey.ownerName}");
                        // Get.to(() => SurveyFormScreen(survey: survey));
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
                                onPressed: () =>
                                    controller.deleteSurvey(survey.id, index),
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
        );
      }),
    );
  }
}
