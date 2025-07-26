import 'dart:developer';

import 'package:dvgsurveyor/helper/app_colors.dart';
import 'package:dvgsurveyor/helper/app_const.dart';
import 'package:dvgsurveyor/helper/app_enums.dart';
import 'package:dvgsurveyor/helper/app_fonts_helper.dart';
import 'package:dvgsurveyor/helper/app_snackbar.dart';
import 'package:dvgsurveyor/model/user_collection_model.dart';
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
              userData: userData,
              initialRole:
                  RoleEnumExtension.fromString(userData.role ?? 'Worker'),
              initialExcel: userData.isExcelDownload ?? false,
              initialEdit: userData.isEditable ?? false,
              initialDelete: userData.isDelete ?? false,
              isApproved: userData.isApproved ?? false,
              isSaving: controller.isSavingMap[userData.id] ?? false,
              isActive: userData.isActive ?? false,
              onSave: ({
                required RoleEnum selectedRole,
                required bool isExcel,
                required bool isEdit,
                required bool isDelete,
                required bool isActive,
              }) {
                final userDetails = userData.copyWith(
                  role: selectedRole.displayName,
                  isExcelDownload: isExcel,
                  isEditable: isEdit,
                  isDelete: isDelete,
                  isApproved: true,
                  isActive: isActive,
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

class UserApprovalCard extends GetWidget<UserMangementScreenController> {
  UserCollectionModel userData;
  final RoleEnum? initialRole;
  final bool initialExcel;
  final bool initialEdit;
  final bool initialDelete;
  final bool isApproved;
  final bool isSaving;
  final bool isActive;
  final void Function({
    required RoleEnum selectedRole,
    required bool isExcel,
    required bool isEdit,
    required bool isDelete,
    required bool isActive,
  }) onSave;

  UserApprovalCard({
    super.key,
    required this.userData,
    required this.initialRole,
    required this.initialExcel,
    required this.initialEdit,
    required this.initialDelete,
    required this.onSave,
    required this.isApproved,
    required this.isSaving,
    required this.isActive,
  }) {
    final cardController =
        Get.put(UserMangementScreenController(), tag: userData.id);
    cardController.initialize(
      initialRole: initialRole,
      initialExcel: initialExcel,
      initialEdit: initialEdit,
      initialDelete: initialDelete,
      initialActive: isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserMangementScreenController>(tag: userData.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Header Row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.tealPrimary,
                    radius: 22,
                    child: Text(
                      '${userData.firstName} ${userData.lastName}'
                          .characters
                          .first
                          .toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${userData.firstName} ${userData.lastName}',
                            style: AppFonts.text16(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.tealDark)),
                        Text(userData.mobileNumber,
                            style: AppFonts.text14(context).copyWith(
                                color: AppColors.darkGrey, fontSize: 12)),
                      ],
                    ),
                  ),
                  _statusChip(context),
                ],
              ),
              Divider(
                color: AppColors.tealLight,
                thickness: 0.7,
                height: 24,
              ),
              _roleAndCredentials(context, c, userData: userData),
              const SizedBox(height: 10),
              _switchesRow(context, c),
              const SizedBox(height: 12),
              _actionButtons(
                context,
                c,
                userData: userData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade400 : Colors.red.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isApproved ? "Approved" : "Pending",
        style: AppFonts.text14(context)
            .copyWith(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _roleAndCredentials(
      BuildContext context, UserMangementScreenController c,
      {UserCollectionModel? userData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Role Dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Role", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Obx(() => SizedBox(
                  width: 100,
                  height: 36,
                  child: DropdownButtonFormField<RoleEnum>(
                    value: c.selectedRole.value,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.tealExtraLight.withOpacity(0.15),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: RoleEnum.values
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.displayName,
                                  style: const TextStyle(fontSize: 12)),
                            ))
                        .toList(),
                    onChanged: (val) => c.selectedRole.value = val,
                  ),
                )),
          ],
        ),

        _infoColumn("Username", "${userData?.username}", context),
        _infoColumn("Password", "${userData?.password}", context),
      ],
    );
  }

  Widget _switchesRow(BuildContext context, UserMangementScreenController c) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMiniSwitch(
                "Active", c.isActive.value, (v) => c.isActive.value = v),
            _buildMiniSwitch(
                "Excel", c.isExcel.value, (v) => c.isExcel.value = v),
            _buildMiniSwitch("Edit", c.isEdit.value, (v) => c.isEdit.value = v),
            _buildMiniSwitch(
                "Delete", c.isDelete.value, (v) => c.isDelete.value = v),
          ],
        ));
  }

  Widget _actionButtons(
    BuildContext context,
    UserMangementScreenController c, {
    UserCollectionModel? userData,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          label: "Edit",
          icon: Icons.edit_rounded,
          onPressed: () {
            c.openEditSheet(
              context: context,
              user: userData,
            );
          },
          isLoading: isSaving,
        ),
        _buildActionButton(
          label: isApproved ? "Save" : "Approve",
          icon: Icons.done_rounded,
          onPressed: isSaving
              ? null
              : () {
                  if (c.selectedRole.value == null) {
                    AppSnackbar.showSnackbar(message: 'Please select a role');
                    return;
                  }
                  onSave(
                    selectedRole: c.selectedRole.value!,
                    isExcel: c.isExcel.value,
                    isEdit: c.isEdit.value,
                    isDelete: c.isDelete.value,
                    isActive: c.isActive.value,
                  );
                },
          isLoading: isSaving,
        ),
        _buildActionButton(
          label: "Delete",
          icon: Icons.delete_rounded,
          onPressed: isSaving
              ? null
              : () {
                  c.deleteUser(userId: userData!.id);
                },
          isLoading: isSaving,
        ),
      ],
    );
  }

  Widget _buildMiniSwitch(String label, bool value, Function(bool) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.tealPrimary,
          ),
        ),
      ],
    );
  }

  Widget _infoColumn(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppFonts.text14(context).copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.tealDark,
            )),
        Text(value,
            style: AppFonts.text14(context).copyWith(
              fontSize: 10,
              color: Colors.grey,
            )),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: 75.w,
      height: 35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tealPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}
