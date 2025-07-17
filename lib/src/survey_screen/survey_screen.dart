import 'package:dvgsurveyor/common_widgets/survey_card_widget.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/survey_screen/controller/survey_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyScreen extends GetWidget<SurveyScreenController> {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Obx(
        () {
          return controller.isSurveyLoad.value == true
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.surveyData.length,
                  itemBuilder: (context, index) {
                    var survey = controller.surveyData[index];
                    return SurveyCardWidget(
                      data: survey,
                      isEditSurvey: controller.userData?.isEditable,
                      isDeleteSUrvey: controller.userData?.isDelete,
                      surveyCon: controller,
                    );
                  },
                  padding: EdgeInsets.only(bottom: 12),
                );
        },
      ),
    );
  }
}
