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
      backgroundColor: const Color(0xFFF2F4F6), // Light grey background
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          'Excel Data',
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
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
          return const Center(child: Text("No Excel loaded. Tap 📂 to pick."));
        }

        final currentIndex =
            controller.currentTab.value.clamp(0, fileNames.length - 1);
        final selectedFile = fileNames[currentIndex];

        return Column(
          children: [
            // 🔹 Tabs as chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor:
                          isSelected ? Colors.teal : Colors.grey[200],
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onPressed: () => controller.currentTab.value = index,
                      onDeleted: () => controller.deleteExcel(fileName),
                    ),
                  );
                }).toList(),
              ),
            ),

            // 🔹 Show Excel Rows
            Expanded(
              child: ListView.builder(
                itemCount: controller.allExcelData[selectedFile]?.length ?? 0,
                itemBuilder: (context, index) {
                  final row = controller.allExcelData[selectedFile]![index];
                  final malikName = controller.getField(row, "ownerName");
                  final kabjedarName = controller.getField(row, "occupantName");

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text("${index + 1}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                      ),
                      title: Text(malikName.isNotEmpty ? malikName : "—"),
                      subtitle:
                          Text(kabjedarName.isNotEmpty ? kabjedarName : "—"),
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
}
