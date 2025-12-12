import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';

class EditPasswordDialog extends StatefulWidget {
  const EditPasswordDialog({super.key});

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Password Sharing ",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Choose which family members can access",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password Details",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF757575),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "Title:",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Disney Plus",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "Category:",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "Streaming",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          "Website:",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF757575),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "disneyplus.com",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                "Select Family Members",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6.h),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFF757575).withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                         SvgPicture.asset("assets/icons/circleIcon.svg"),
                        SizedBox(width: 5.w),
                        Text(
                          "Emily Walton (Parent)",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/circleIcon.svg"),
                        SizedBox(width: 5.w),
                        Text(
                          "TJ Walton (Parent)",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/circleIcon.svg"),
                        SizedBox(width: 5.w),
                        Text(
                          "Adri Walton (teen)",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/circleIcon.svg"),
                        SizedBox(width: 5.w),
                        Text(
                          "Evie Walton (child)",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Selected members will be a ble to view this password in their password valult.",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575),
                ),
              ),
              SizedBox(height: 24.h),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Handle share action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      label: const Text(
                        "Save Changes",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
