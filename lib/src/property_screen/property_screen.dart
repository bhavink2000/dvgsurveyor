import 'package:dvgsurveyor/common_widgets/add_property_bottom_sheet.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/property_screen/controller/property_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyScreen extends GetWidget<PropertyScreenController> {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          AppConst.propertType,
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              elevation: 1,
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.tealDark,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: const [
                        _HeaderCell(title: 'ID', flex: 4),
                        _HeaderCell(title: 'Name', flex: 3),
                        _HeaderCell(title: 'Active', flex: 3),
                        _HeaderCell(title: 'Edit', flex: 2),
                        _HeaderCell(title: 'Del', flex: 1),
                      ],
                    ),
                  ),

                  // List
                  Obx(() {
                    return controller.isPropertyTypeLoad.value
                        ? const SizedBox(
                            height: 150,
                            child: Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 1.5),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.propertyData.length,
                            itemBuilder: (context, index) {
                              final pro = controller.propertyData[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    _RowCell(value: pro.id, flex: 4),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        pro.name,
                                        style:
                                            AppFonts.text14(context).copyWith(
                                          fontSize: 12,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Transform.scale(
                                        scale: 0.50,
                                        child: Switch(
                                          value: pro.isActive,
                                          onChanged: (val) {
                                            // Toggle logic
                                          },
                                          activeColor: AppColors.tealDark,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: AppColors.tealDark,
                                        ),
                                        onPressed: () {
                                          controller.prepareForEdit(pro);
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                            ),
                                            builder: (_) =>
                                                const AddPropertyBottomSheet(
                                              isEdit: true,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: AppColors.tealDark,
                                        ),
                                        onPressed: () {
                                          controller.deleteProperty(
                                            proData: pro,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                  }),

                  const SizedBox(height: 8),

                  // Add Button
                  InkWell(
                    onTap: () {
                      controller.prepareForAdd();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) =>
                            const AddPropertyBottomSheet(isEdit: false),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.tealDark,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppConst.addNewProperty,
                          style: AppFonts.text14(context).copyWith(
                            color: AppColors.offWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String title;
  final int flex;

  const _HeaderCell({required this.title, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: AppFonts.text14(context).copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.offWhite,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RowCell extends StatelessWidget {
  final String value;
  final int flex;

  const _RowCell({required this.value, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: AppFonts.text14(context).copyWith(fontSize: 11),
      ),
    );
  }
}
