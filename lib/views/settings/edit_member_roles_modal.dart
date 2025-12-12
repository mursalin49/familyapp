import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../widgets/custom_dropdown.dart';

class EditMemberRolesModal extends StatefulWidget {
  const EditMemberRolesModal({super.key});

  @override
  State<EditMemberRolesModal> createState() => _EditMemberRolesModalState();
}

class _EditMemberRolesModalState extends State<EditMemberRolesModal> {
  // Sample family members data
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'name': 'Emily Walton',
      'currentRole': 'Mom',
      'avatarLetter': 'E',
      'avatarColor': const Color(0xFFEC4899),
      'isTeen': false,
    },
    {
      'name': 'TJ Walton',
      'currentRole': 'Dad',
      'avatarLetter': 'T',
      'avatarColor': const Color(0xFF3B82F6),
      'isTeen': false,
    },
    {
      'name': 'Adri Walton',
      'currentRole': 'Teen',
      'avatarLetter': 'A',
      'avatarColor': const Color(0xFF10B981),
      'isTeen': true,
    },
    {
      'name': 'Evie Walton',
      'currentRole': 'Child',
      'avatarLetter': 'E',
      'avatarColor': const Color(0xFFF59E0B),
      'isTeen': false,
    },
  ];

  final List<String> _roles = [
    'Mom',
    'Dad',
    'Child',
    'Teen',
    'Grandparent',
    'Caregiver',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.people_outline,
                      color: AppColors.primary,
                      size: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Edit Member Roles",
                          style: TextStyle(
                            fontFamily: 'Prompt_Bold',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Manage roles for each family member",
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
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            // Family Members List
            ..._familyMembers.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> member = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildMemberRoleCard(
                  name: member['name'],
                  currentRole: member['currentRole'],
                  avatarLetter: member['avatarLetter'],
                  avatarColor: member['avatarColor'],
                  isTeen: member['isTeen'],
                  onRoleChanged: (newRole) {
                    setState(() {
                      _familyMembers[index]['currentRole'] = newRole;
                    });
                  },
                ),
              );
            }).toList(),
                  ],
                ),
              ),
            ),
            // Action Buttons
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textColor,
                          side: BorderSide(
                            color: const Color(0xFF757575).withOpacity(0.2),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Save Changes Button
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement save changes
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
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

  Widget _buildMemberRoleCard({
    required String name,
    required String currentRole,
    required String avatarLetter,
    required Color avatarColor,
    required bool isTeen,
    required Function(String) onRoleChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF757575).withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.03),
            offset: const Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                avatarLetter,
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
          // Name and Current Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Current: $currentRole",
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
          // Role Dropdown
          CustomDropdown<String>(
            width: 120.w,
            value: currentRole,
            items: _roles.toDropdownItems((role) => role),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onRoleChanged(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
