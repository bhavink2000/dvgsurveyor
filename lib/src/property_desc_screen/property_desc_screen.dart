import 'package:dvgsurveyor/common_widgets/add_property_desc_bottom_sheet.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/property_desc_screen/controller/property_desc_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyDescScreen extends GetWidget<PropertyDescScreenController> {
  const PropertyDescScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          AppConst.propertyDesc,
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              controller.prepareForAdd();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                builder: (_) => const AddPropertyDescBottomSheet(
                  isEdit: false,
                  isNew: true,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.tealDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  AppConst.addNewProDesc,
                  style: AppFonts.text14(context).copyWith(
                    color: AppColors.offWhite,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return controller.isPropertyDesLoad.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: controller.groupedDescriptions.keys.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, index) {
                        final typeId = controller.groupedDescriptions.keys
                            .elementAt(index);
                        final descriptions =
                            controller.groupedDescriptions[typeId]!;

                        final typeName = controller
                            .getTypeNameById(typeId); // "Public", etc.

                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Group Header
                              Container(
                                width: double.infinity,
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
                                  children: [
                                    Text(
                                      typeName,
                                      style: AppFonts.text16(context).copyWith(
                                        color: AppColors.offWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '($typeId)',
                                      style: AppFonts.text14(context).copyWith(
                                        color: AppColors.offWhite,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
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

                              // Description List
                              ListView.builder(
                                itemCount: descriptions.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemBuilder: (context, i) {
                                  final desc = descriptions[i];

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: [
                                        _RowCell(value: desc.id, flex: 4),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            desc.name,
                                            style: AppFonts.text14(context)
                                                .copyWith(
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
                                              value: desc.isActive,
                                              onChanged: (val) {},
                                              activeColor: AppColors.tealDark,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
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
                                              controller.prepareForEdit(
                                                  propDesc: desc);
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                                ),
                                                builder: (_) =>
                                                    const AddPropertyDescBottomSheet(
                                                        isEdit: true),
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
                                              controller.deletePropertyDesc(
                                                  proDescData: desc);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Add Button
                              InkWell(
                                onTap: () {
                                  controller.prepareForAdd(proTypeId: typeId);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder: (_) =>
                                        const AddPropertyDescBottomSheet(
                                            isEdit: false),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.tealDark,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppConst.addNewProDesc,
                                      style: AppFonts.text14(context).copyWith(
                                        color: AppColors.offWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            }),
          ),
        ],
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
          color: AppColors.almostBlack,
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
