// ignore_for_file: deprecated_member_use

import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateWiseCard extends GetWidget<DashboardController> {
  const DateWiseCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Start Date
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.pickStartDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Obx(() {
                          final start = controller.selectedStartDate.value;
                          return Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 16, color: Colors.teal.shade600),
                              const SizedBox(width: 6),
                              Text(
                                start != null
                                    ? DateFormat('dd MMM yyy').format(start)
                                    : 'Start',
                                style: AppFonts.text14(context).copyWith(
                                  color: start != null
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // End Date
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.pickEndDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Obx(() {
                          final end = controller.selectedEndDate.value;
                          return Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 16, color: Colors.teal.shade600),
                              const SizedBox(width: 6),
                              Text(
                                end != null
                                    ? DateFormat('dd MMM yyy').format(end)
                                    : 'End',
                                style: AppFonts.text14(context).copyWith(
                                  color:
                                      end != null ? Colors.black : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Filter Apply Button
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade300, Colors.teal.shade700],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.4),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.done_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: controller.applyDateFilter,
                      tooltip: "Apply Filter",
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, height: 0, color: Colors.teal),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      AppImages.dateWise,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Obx(()=>Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatLabel(
                        context,
                        'Total Survey',
                      ),
                      Text('${controller.dateTotalSurveyCount}',
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
                      Text('${controller.dateTotalAreaCount} sq.mt',
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
                  )),
                ],
              ),
            ),

            // Download Footer
            Container(
              decoration: BoxDecoration(
                color: AppColors.tealPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: InkWell(
                onTap: () {
                  // handle download
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Download Excel',
                        style: AppFonts.text16(context).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        AppImages.excelDownload,
                        width: 34,
                        height: 34,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
