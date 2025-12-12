import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/custom_dropdown.dart';

class AddNewPasswordDialog extends StatefulWidget {
  const AddNewPasswordDialog({super.key});

  @override
  State<AddNewPasswordDialog> createState() => _AddNewPasswordDialogState();
}

class _AddNewPasswordDialogState extends State<AddNewPasswordDialog> {
  String? selectedCategory;
  String? selectedDelivery;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final List<String> familyMembers = [
    'Others',
    'Streaming',
    'Banking',
    'School',
    'Shopping',
    'Utilities',
    'Social Media',
    'Work',
  ];
  bool _isClean = true;
  static const Color primaryPink = Color(0xFFED3C8C);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Password",
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
              SizedBox(height: 16.h),

              Text(
                "Title",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "e.g., Netflix, School Portal",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),


              SizedBox(height: 24.h),

              Text(
                "Category",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              CustomDropdown<String>(
                items: familyMembers.toDropdownItems((item) => item),
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                hintText: "Choose a Category",
              ),
              SizedBox(height: 16.h),


              Text(
                "Website",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: websiteController,
                decoration: InputDecoration(
                  hintText: "e.g., netflix.com",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16.h),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextField(
                          controller: userController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.h),

              Text(
                "Password",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: passController,
                decoration: InputDecoration(
                  hintText:
                  "Enter a password",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Text(
                "Notes (optional)",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              TextField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                  "Type your message here...",
                  hintStyle: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Delivery Method Dropdown
              Text(
                "Share With Family Members",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6.h),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
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
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mark as Favorite",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "Show this password in your favorites list",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _isClean,
                      onChanged: (bool newValue) {
                        setState(() {
                          _isClean = newValue;
                        });
                      },
                      activeColor: AppColors.white,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                      activeTrackColor:primaryPink,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),


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
                        "Save Password",
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
