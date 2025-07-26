import 'package:dvgsurveyor/app_routes/app_routes.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:dvgsurveyor/src/survey_screen/controller/survey_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SurveyCardWidget extends StatelessWidget {
  final SurveyModel data;
  final bool? isEditSurvey;
  final bool? isDeleteSUrvey;
  final SurveyScreenController? surveyCon;

  const SurveyCardWidget({
    super.key,
    required this.data,
    this.isEditSurvey = false,
    this.isDeleteSUrvey = false,
    this.surveyCon,
  });

  @override
  Widget build(BuildContext context) {
    final area = data.area;
    final propertyTypeName =
        data.propertyType.values.map((e) => e.propertyName ?? '-').join(', ');
    final propertyDescriptionName = data.propertyDescription.values
        .map((e) => e.propertyDes ?? '-')
        .join(', ');

    final totalArea =
        area.values.fold<double>(0, (sum, detail) => sum + detail.totalArea);
    final constructedArea = area.values.fold<double>(0, (sum, detail) {
      return sum +
          detail.slab.totalCount +
          detail.papda.totalCount +
          detail.patara.totalCount +
          detail.nadiya.totalCount;
    });
    final openArea = area.values
        .fold<double>(0, (sum, detail) => sum + detail.open.totalCount);

    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.tealPrimary),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Owner + Address + Rent
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.ownerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tealDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _labelValueRow(context, 'Address', data.address),
                      _labelValueRow(context, 'Rent', data.rentPersonName),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Right Side: House number + Survey number
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.tealPrimary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tealPrimary.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New: ${data.newHomeNumber}',
                        style: AppFonts.text14(context).copyWith(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Old: ${data.oldHomeNumber}',
                        style: AppFonts.text14(context).copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Survey: ${data.surveyNumber}',
                        style: AppFonts.text14(context).copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                _infoColumn(context, 'Mobile', data.mobileNumber.toString()),
                _infoColumn(context, 'Year', data.banthkamYear.toString()),
                _infoColumn(context, 'Ownership', data.propertyStayType),
                _infoColumn(
                    context, 'Water Con', data.waterPipeline.toString()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _infoColumn(context, 'Type', propertyTypeName),
                _infoColumn(context, 'Desc', propertyDescriptionName),
                _infoColumn(context, 'Floors', data.totalFloors.toString()),
                _infoColumn(context, 'Survey By', data.userName),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn(
                  context,
                  'Total Area',
                  totalArea.toString(),
                  isArea: true,
                ),
                _infoColumn(
                  context,
                  'Construcated Area',
                  constructedArea.toString(),
                  isArea: true,
                ),
                _infoColumn(
                  context,
                  'Open Area',
                  openArea.toString(),
                  isArea: true,
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                _infoColumn(
                  context,
                  'Created',
                  formatFullDateTime(data.createdAt),
                ),
                Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    if (isEditSurvey == false) {
                      AppSnackbar.showSnackbar(
                        title: 'Opps!',
                        message:
                            'You have no permission for edit survey. \n Please contact to admin',
                      );
                      return;
                    }
                    Get.toNamed(
                      AppRoutes.surveyorFormScreen,
                      arguments: {
                        'isEdit': true,
                        'surveyData': data,
                      },
                    )?.then((_) {
                      // Refresh the survey list after coming back
                      surveyCon
                          ?.fetchSurveyData(); // or whatever method reloads the list
                    });
                    ;
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: AppColors.tealDark,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (isDeleteSUrvey == false) {
                      AppSnackbar.showSnackbar(
                        title: 'Opps!',
                        message:
                            'You have no permission for delete survey. \n Please contact to admin',
                      );
                      return;
                    }
                    surveyCon?.deleteSurvey(sId: data.id);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20,
                    color: AppColors.tealDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(BuildContext context, String label, String value,
      {bool isArea = false}) {
    return isArea == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: AppFonts.text14(context).copyWith(
                  color: AppColors.almostBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${value} sq.mt',
                style: AppFonts.text14(context).copyWith(
                  color: AppColors.darkGrey,
                  fontSize: 10,
                ),
                //overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : SizedBox(
            width: label == 'Created' ? 150.w : 75.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: AppFonts.text14(context).copyWith(
                    color: AppColors.almostBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppFonts.text14(context).copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 10,
                  ),
                  //overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
  }

  Widget _labelValueRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: AppFonts.text14(context).copyWith(
              color: AppColors.almostBlack,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.text14(context).copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String formatFullDateTime(DateTime? dt) {
    if (dt == null) return '-';

    final day = dt.day.toString().padLeft(2, '0');
    final monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final month = monthNames[dt.month];
    final year = dt.year;

    int hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    final isPM = hour >= 12;
    final period = isPM ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$day $month $year at $hour:$minute:$second $period';
  }
}
