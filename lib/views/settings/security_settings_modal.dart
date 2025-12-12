import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class SecuritySettingsModal extends StatefulWidget {
  const SecuritySettingsModal({super.key});

  @override
  State<SecuritySettingsModal> createState() => _SecuritySettingsModalState();
}

class _SecuritySettingsModalState extends State<SecuritySettingsModal> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  
  bool _twoFactorAuth = false;
  bool _loginNotifications = true;
  bool _autoLockApp = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                        Icons.lock_outline,
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
                            "Security Settings",
                            style: TextStyle(
                              fontFamily: 'Prompt_Bold',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Manage your account security and authentication preferences.",
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
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Password Management Section
                      Text(
                        "Password Management",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Current Password Field
                      _buildPasswordField(
                        label: "Current Password",
                        controller: _currentPasswordController,
                        hintText: "Enter current password",
                      ),
                      SizedBox(height: 16.h),
                      // New Password Field
                      _buildPasswordField(
                        label: "New Password",
                        controller: _newPasswordController,
                        hintText: "Enter new password",
                      ),
                      SizedBox(height: 16.h),
                      // Confirm Password Field
                      _buildPasswordField(
                        label: "Confirm New Password",
                        controller: _confirmPasswordController,
                        hintText: "Confirm new password",
                      ),
                      SizedBox(height: 24.h),
                      // Authentication and Notifications Section
                      Text(
                        "Authentication and Notifications",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Two-Factor Authentication
                      _buildSecurityItem(
                        title: "Two-Factor Authentication",
                        description: "Add an extra layer of security to your account",
                        value: _twoFactorAuth,
                        onChanged: (value) {
                          setState(() {
                            _twoFactorAuth = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Login Notifications
                      _buildSecurityItem(
                        title: "Login Notifications",
                        description: "Get notified when someone logs into your account",
                        value: _loginNotifications,
                        onChanged: (value) {
                          setState(() {
                            _loginNotifications = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Auto-Lock App
                      _buildSecurityItem(
                        title: "Auto-Lock App",
                        description: "Automatically lock app after 15 minutes of inactivity",
                        value: _autoLockApp,
                        onChanged: (value) {
                          setState(() {
                            _autoLockApp = value;
                          });
                        },
                      ),
                      SizedBox(height: 24.h),
                      // Active Sessions Section
                      Text(
                        "Active Sessions",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // This Device
                      _buildSessionItem(
                        device: "This Device",
                        lastActive: "Last active: Now",
                        buttonText: "Current",
                        isCurrent: true,
                      ),
                      SizedBox(height: 12.h),
                      // iPhone
                      _buildSessionItem(
                        device: "iPhone",
                        lastActive: "Last active: 2 hours ago",
                        buttonText: "Revoke",
                        isCurrent: false,
                      ),
                      SizedBox(height: 24.h),
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
                    // Save Security Settings Button
                    Expanded(
                      child: SizedBox(
                        height: 38.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement save security settings
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
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 13.sp,
            color: AppColors.textColor,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 13.sp,
              color: AppColors.subHeadingColor,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: const Color(0xFF757575).withOpacity(0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: const Color(0xFF757575).withOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityItem({
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
          activeColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withOpacity(0.3),
          inactiveThumbColor: const Color(0xFF9CA3AF),
          inactiveTrackColor: const Color(0xFFE5E7EB),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _buildSessionItem({
    required String device,
    required String lastActive,
    required String buttonText,
    required bool isCurrent,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                lastActive,
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
        SizedBox(
          height: 28.h,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Handle session action
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textColor,
              side: BorderSide(
                color: const Color(0xFF757575).withOpacity(0.2),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Prompt_regular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
