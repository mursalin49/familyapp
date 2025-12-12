import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../widgets/custom_dropdown.dart';

class ProfileSettingsModal extends StatefulWidget {
  const ProfileSettingsModal({super.key});

  @override
  State<ProfileSettingsModal> createState() => _ProfileSettingsModalState();
}

class _ProfileSettingsModalState extends State<ProfileSettingsModal> {
  late TextEditingController _displayNameController;
  String _selectedTheme = 'Light';
  String _selectedTimeFormat = '12-hour (AM/PM)';
  String _selectedLanguage = 'English';

  final List<String> _themes = [
    'Light',
    'Dark',
    'System',
  ];

  final List<String> _timeFormats = [
    '12-hour (AM/PM)',
    '24-hour',
  ];

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
  ];

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(text: 'Mom');
  }

  @override
  void dispose() {
    _displayNameController.dispose();
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
                      Icons.person_outline,
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
                          "Profile Settings",
                          style: TextStyle(
                            fontFamily: 'Prompt_Bold',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Manage your personal information and app preferences.",
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
            // Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Display Name Field
                  _buildFormField(
                    label: "Display Name",
                    controller: _displayNameController,
                    hintText: "Enter your display name",
                  ),
                  SizedBox(height: 16.h),
                  // App Theme Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "App Theme",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomDropdown<String>(
                        value: _selectedTheme,
                        items: _themes.toDropdownItems((item) => item),
                        onChanged: (value) {
                          setState(() {
                            _selectedTheme = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Time Format Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time Format",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomDropdown<String>(
                        value: _selectedTimeFormat,
                        items: _timeFormats.toDropdownItems((item) => item),
                        onChanged: (value) {
                          setState(() {
                            _selectedTimeFormat = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Language Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Language",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomDropdown<String>(
                        value: _selectedLanguage,
                        items: _languages.toDropdownItems((item) => item),
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                          });
                        },
                      ),
                    ],
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

  Widget _buildFormField({
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

}
