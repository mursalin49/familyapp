import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class MergeFamilyModal extends StatefulWidget {
  const MergeFamilyModal({super.key});

  @override
  State<MergeFamilyModal> createState() => _MergeFamilyModalState();
}

class _MergeFamilyModalState extends State<MergeFamilyModal> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.favorite_outline,
                      color: const Color(0xFFEC4899),
                      size: 14.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "Merge with Partner's Family",
                      style: TextStyle(
                        fontFamily: 'Prompt_Bold',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    "Send a merge request to your partner. They will receive a notification and can approve or reject the request. This will combine all family members, tasks, and events into one unified family.",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.subHeadingColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Email Field
                  _buildFormField(
                    label: "Partner's Email Address",
                    controller: _emailController,
                    hintText: "partner@example.com",
                  ),
                  SizedBox(height: 16.h),
                  // How it works info box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "How it works:",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E40AF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Your partner will receive a notification and can approve or reject the merge request. If approved, their family data will be combined with yours.",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1E40AF),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
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
                  // Send Merge Request Button
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement send merge request
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
                          "Send",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
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
                color: const Color(0xFFEC4899),
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
