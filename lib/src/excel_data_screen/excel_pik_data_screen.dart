import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/excel_data_screen/controller/excel_pik_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcelPikDataScreen extends GetWidget<ExcelPikDataController> {
  const ExcelPikDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          "Excel Data",
          style: AppFonts.text20(context).copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => controller.pickExcelFile(),
          ),
        ],
      ),
      body: Obx(() {
        final fileNames = controller.allExcelData.keys.toList();

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (fileNames.isEmpty) {
          return const Center(
            child: Text("📂 No Excel loaded. Tap the top-right icon."),
          );
        }

        final currentIndex =
            controller.currentTab.value.clamp(0, fileNames.length - 1);
        final selectedFile = fileNames[currentIndex];
        final rows = controller.allExcelData[selectedFile] ?? [];

        return Column(
          children: [
            // 🔹 Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: fileNames.asMap().entries.map((entry) {
                  final index = entry.key;
                  final fileName = entry.value;
                  final isSelected = index == currentIndex;

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InputChip(
                      label: Text(fileName),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor:
                          isSelected ? Colors.teal : Colors.grey[300],
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onPressed: () => controller.currentTab.value = index,
                      onDeleted: () => controller.deleteExcel(fileName),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 🔹 Minimal List
            Expanded(
              child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  final owner = controller.getField(row, "ownerName");
                  final occupant = controller.getField(row, "occupantName");

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(owner.isNotEmpty ? owner : "—"),
                      subtitle: Text(
                        "કબજેદાર: ${occupant.isNotEmpty ? occupant : "—"}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),

      // 🔹 Floating Button for Upload Pending
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            backgroundColor: AppColors.tealPrimary,
            icon: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.cloud_upload, color: Colors.white),
            label: const Text("Upload Pending",
                style: TextStyle(color: Colors.white)),
            onPressed: controller.isLoading.value
                ? null
                : () => controller.uploadAllFromCurrentTab(),
          )),
    );
  }
}
