import 'dart:developer';

import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_enums.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/src/user_mangement/controller/user_mangement_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserMangementScreen extends GetWidget<UserMangementScreenController> {
  const UserMangementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.offWhite),
        backgroundColor: AppColors.tealPrimary,
        title: Text(
          AppConst.userManagement,
          style: AppFonts.text20(context).copyWith(
            color: AppColors.offWhite,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.group_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No users found for approval.',
                  style: AppFonts.text16(context).copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.userList.length,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemBuilder: (context, index) {
            var userData = controller.userList[index];
            return UserApprovalCard(
              name: "${userData.firstName} ${userData.lastName}",
              mobile: userData.mobileNumber,
              initialRole:
                  RoleEnumExtension.fromString(userData.role ?? 'Worker'),
              initialExcel: userData.isExcelDownload ?? false,
              initialEdit: userData.isEditable ?? false,
              initialDelete: userData.isDelete ?? false,
              isApproved: userData.isApproved ?? false,
              isSaving: controller.isSavingMap[userData.id] ?? false,
              onSave: ({
                required RoleEnum selectedRole,
                required bool isExcel,
                required bool isEdit,
                required bool isDelete,
              }) {
                final userDetails = userData.copyWith(
                  role: selectedRole.displayName,
                  isExcelDownload: isExcel,
                  isEditable: isEdit,
                  isDelete: isDelete,
                  isApproved: true,
                );
                controller.updateUser(userData: userDetails);
                log('Saving User ${userData.id}');
                log('Role: ${selectedRole.displayName}, \nExcel: $isExcel, \nEdit: $isEdit, \nDelete: $isDelete');
              },
            );
          },
        );
      }),
    );
  }
}

class UserApprovalCard extends StatefulWidget {
  final String name;
  final String mobile;
  final RoleEnum? initialRole;
  final bool initialExcel;
  final bool initialEdit;
  final bool initialDelete;
  final bool isApproved;
  final bool isSaving;
  final void Function({
    required RoleEnum selectedRole,
    required bool isExcel,
    required bool isEdit,
    required bool isDelete,
  }) onSave;

  const UserApprovalCard({
    super.key,
    required this.name,
    required this.mobile,
    required this.initialRole,
    required this.initialExcel,
    required this.initialEdit,
    required this.initialDelete,
    required this.onSave,
    required this.isApproved,
    required this.isSaving,
  });

  @override
  State<UserApprovalCard> createState() => _UserApprovalCardState();
}

class _UserApprovalCardState extends State<UserApprovalCard> {
  late RoleEnum? selectedRole;
  late bool isExcel;
  late bool isEdit;
  late bool isDelete;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.initialRole;
    isExcel = widget.initialExcel;
    isEdit = widget.initialEdit;
    isDelete = widget.initialDelete;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        border: Border.all(color: AppColors.tealDark, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.zero,
        shadowColor: AppColors.tealExtraLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.tealPrimary,
                    radius: 20,
                    child: Text(
                      widget.name.characters.first.toUpperCase(),
                      style: AppFonts.text16(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: AppFonts.text16(context)),
                      Text(widget.mobile,
                          style: AppFonts.text14(context).copyWith(
                            color: AppColors.darkGrey,
                            fontSize: 12,
                          )),
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.isApproved == false
                          ? AppColors.coralAccent.withValues(alpha: 0.5)
                          : AppColors.tealPrimary.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      widget.isApproved == false ? 'Pending' : 'Approved',
                      style: AppFonts.text14(context).copyWith(
                        fontSize: 12,
                        color: AppColors.offWhite,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Role", style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 90,
                        height: 34,
                        child: DropdownButtonFormField<RoleEnum>(
                          value: selectedRole,
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                          ),
                          items: RoleEnum.values
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role.displayName,
                                        style: const TextStyle(fontSize: 12)),
                                  ))
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedRole = val),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  _buildMiniSwitch(
                      "Excel", isExcel, (v) => setState(() => isExcel = v)),
                  const SizedBox(width: 8),
                  _buildMiniSwitch(
                      "Edit", isEdit, (v) => setState(() => isEdit = v)),
                  const SizedBox(width: 8),
                  _buildMiniSwitch(
                      "Delete", isDelete, (v) => setState(() => isDelete = v)),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.isSaving
                      ? null
                      : () {
                          if (selectedRole == null) {
                            AppSnackbar.showSnackbar(
                                message: 'Please select a role');
                            return;
                          }
                          widget.onSave(
                            selectedRole: selectedRole!,
                            isExcel: isExcel,
                            isEdit: isEdit,
                            isDelete: isDelete,
                          );
                        },
                  icon: widget.isSaving
                      ? const SizedBox.shrink()
                      : const Icon(Icons.save),
                  label: widget.isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.isApproved == false ? "Approved" : "Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tealPrimary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable mini switch
  Widget _buildMiniSwitch(String label, bool value, Function(bool) onChanged) {
    return Column(
      children: [
        Text(label, style: AppFonts.text14(context).copyWith(fontSize: 12.sp)),
        Transform.scale(
          scale: 0.65,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.tealDark,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}
