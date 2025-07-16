import 'package:dvgsurveyor/common_widgets/add_city_bottom_sheet.dart';
import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/src/city_screen/controller/city_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CityScreen extends GetWidget<CityScreenController> {
  const CityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          AppConst.cityManagement,
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
                    return controller.isCityLoad.value
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
                            itemCount: controller.cityData.length,
                            itemBuilder: (context, index) {
                              final cityD = controller.cityData[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    _RowCell(value: cityD.id, flex: 4),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        cityD.name,
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
                                          value: cityD.isActive,
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
                                          controller.prepareForEdit(cityD);
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
                                                const AddCityBottomSheet(
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
                                          controller.deleteCity(
                                            cityData: cityD,
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
                        builder: (_) => const AddCityBottomSheet(isEdit: false),
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
                          AppConst.addNewCity,
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
