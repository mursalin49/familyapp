import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class ManagePermissionsModal extends StatefulWidget {
  const ManagePermissionsModal({super.key});

  @override
  State<ManagePermissionsModal> createState() => _ManagePermissionsModalState();
}

class _ManagePermissionsModalState extends State<ManagePermissionsModal> {
  bool _canCreateTasks = true;
  bool _canEditEvents = true;
  bool _canManageGroceryLists = true;
  bool _canViewPasswords = false;
  bool _receivesNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: const Color(0xFFEC4899),
                      size: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Permissions",
                          style: TextStyle(
                            fontFamily: 'Prompt_Bold',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Control what each family member can access and modify.",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.textColor,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Family Member Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        "E",
                        style: TextStyle(
                          fontFamily: 'Prompt_Bold',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emily Walton",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Parent",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Permissions List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _buildPermissionItem(
                    title: "Can create tasks",
                    value: _canCreateTasks,
                    onChanged: (value) {
                      setState(() {
                        _canCreateTasks = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildPermissionItem(
                    title: "Can edit events",
                    value: _canEditEvents,
                    onChanged: (value) {
                      setState(() {
                        _canEditEvents = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildPermissionItem(
                    title: "Can manage grocery lists",
                    value: _canManageGroceryLists,
                    onChanged: (value) {
                      setState(() {
                        _canManageGroceryLists = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildPermissionItem(
                    title: "Can view passwords",
                    value: _canViewPasswords,
                    onChanged: (value) {
                      setState(() {
                        _canViewPasswords = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildPermissionItem(
                    title: "Receives notifications",
                    value: _receivesNotifications,
                    onChanged: (value) {
                      setState(() {
                        _receivesNotifications = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFEC4899),
          activeTrackColor: const Color(0xFFEC4899).withOpacity(0.3),
          inactiveThumbColor: const Color(0xFF9CA3AF),
          inactiveTrackColor: const Color(0xFFE5E7EB),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
