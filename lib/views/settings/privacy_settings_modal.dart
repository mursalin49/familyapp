import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class PrivacySettingsModal extends StatefulWidget {
  const PrivacySettingsModal({super.key});

  @override
  State<PrivacySettingsModal> createState() => _PrivacySettingsModalState();
}

class _PrivacySettingsModalState extends State<PrivacySettingsModal> {
  bool _shareActivityStatus = true;
  bool _locationSharing = false;
  bool _usageAnalytics = true;
  bool _marketingCommunications = false;
  bool _dataBackupToCloud = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(),
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
                          "Privacy Settings",
                          style: TextStyle(
                            fontFamily: 'Prompt_Bold',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Control your privacy and data sharing preferences.",
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
            // Privacy Settings List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _buildPrivacyItem(
                    title: "Share Activity Status",
                    description: "Let family members see when you're active",
                    value: _shareActivityStatus,
                    onChanged: (value) {
                      setState(() {
                        _shareActivityStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildPrivacyItem(
                    title: "Location Sharing",
                    description: "Share your location for family coordination",
                    value: _locationSharing,
                    onChanged: (value) {
                      setState(() {
                        _locationSharing = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildPrivacyItem(
                    title: "Usage Analytics",
                    description: "Help improve the app by sharing usage data",
                    value: _usageAnalytics,
                    onChanged: (value) {
                      setState(() {
                        _usageAnalytics = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildPrivacyItem(
                    title: "Marketing Communications",
                    description: "Receive updates about new features",
                    value: _marketingCommunications,
                    onChanged: (value) {
                      setState(() {
                        _marketingCommunications = value;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildPrivacyItem(
                    title: "Data Backup to Cloud",
                    description: "Automatically backup your family data",
                    value: _dataBackupToCloud,
                    onChanged: (value) {
                      setState(() {
                        _dataBackupToCloud = value;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
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
                  // Save Preferences Button
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement save preferences
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC4899),
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

  Widget _buildPrivacyItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subHeadingColor,
                  height: 1.3,
                ),
              ),
            ],
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
