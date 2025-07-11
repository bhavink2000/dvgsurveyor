import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/model/surveyor_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyCardWidget extends StatelessWidget {
  final SurveyModel data;

  const SurveyCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final area = data.area;
    final propertyTypeName =
        data.propertyType.values.map((e) => e.propertyName ?? '-').join(', ');
    final propertyDescriptionName = data.propertyDescription.values
        .map((e) => e.propertyDes ?? '-')
        .join(', ');

    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.tealPrimary),
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 0, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.ownerName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tealDark,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerLabel(context, 'N:', data.newHomeNumber),
                      _headerLabel(context, 'O:', data.oldHomeNumber),
                    ],
                  ),
                ),
              ],
            ),

            /// Address and Rent
            _labelValueRow(context, 'Address', data.address),
            _labelValueRow(context, 'Rent', data.rentPersonName),

            const Divider(),

            /// Info Columns
            Row(
              //spacing: 10,
              //runSpacing: 12,
              children: [
                _infoColumn(context, 'Mobile', data.mobileNumber.toString()),
                _infoColumn(context, 'Year', data.banthkamYear.toString()),
                _infoColumn(context, 'Ownership', data.propertyStayType),
                _infoColumn(
                    context, 'Water Con', data.waterPipeline.toString()),
              ],
            ),

            const SizedBox(height: 12),

            /// Property Type, Desc, Total Floors
            Row(
              //spacing: 20,
              //runSpacing: 12,
              children: [
                _infoColumn(context, 'Type', propertyTypeName),
                _infoColumn(context, 'Desc', propertyDescriptionName),
                _infoColumn(context, 'Floors', data.totalFloors.toString()),
              ],
            ),

            const Divider(),

            /// Floor-wise area
            Text(
              'Total Area:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: area.entries.map((entry) {
                  final floorName = entry.key;
                  final total = entry.value.totalArea;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.tealDark),
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.tealExtraLight,
                    ),
                    child: Text(
                      '$floorName: ${total.toString()} sq.ft',
                      style: AppFonts.text14(context).copyWith(
                        color: AppColors.tealDark,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(),

            /// Created At
            _labelValueRow(
                context, 'Created', formatFullDateTime(data.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(BuildContext context, String label, String value) {
    return SizedBox(
      width: 75.w,
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
            overflow: TextOverflow.ellipsis,
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

  Widget _headerLabel(BuildContext context, String prefix, String value) {
    return Text(
      '$prefix $value',
      style: AppFonts.text14(context).copyWith(
        color: AppColors.offWhite,
        fontSize: 10,
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
