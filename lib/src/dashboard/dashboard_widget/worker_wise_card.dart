import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_images_helper.dart';
import 'package:dvgsurveyor/src/dashboard/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerWiseCard extends GetWidget<DashboardController> {
  const WorkerWiseCard({super.key});

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
              colors: [Colors.white, Colors.white],
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
                      'Worker',
                      style: AppFonts.text20(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.tealDark,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 110,
                      height: 34,
                      child: DropdownButtonFormField<String?>(
                        value: controller.selectedWorker.value,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
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
                        icon: Obx(() => controller.isWorkerLoad.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.arrow_drop_down)),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'Select Worker',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                          ...controller.workerList.map((worker) {
                            return DropdownMenuItem<String>(
                              value: worker,
                              child: Text(
                                worker.capitalizeFirst ?? '',
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (val) {
                          controller.selectedWorker.value = val;

                          if (val != null) {
                            // Get the selected user from the full list using username
                            final selectedUser =
                                controller.allWorkers.firstWhere(
                              (user) => user.username == val,
                              // fallback empty model
                            );

                            final userId = selectedUser.id;

                            controller.fetchWorkerSurveySummary(
                              workerId: userId,
                            ); // pass it
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
                        Text('${controller.workerTotalSurveyCount}',
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
                        Text('${controller.workerTotalAreaCount} sq.mt',
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
                        AppImages.workerWise,
                        //width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
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
