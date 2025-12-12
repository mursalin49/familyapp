import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/family_view_model.dart';
import '../widgets/custom_dropdown.dart';

class CreateFamilyProfileModal extends StatefulWidget {
  const CreateFamilyProfileModal({super.key});

  @override
  State<CreateFamilyProfileModal> createState() => _CreateFamilyProfileModalState();
}

class _CreateFamilyProfileModalState extends State<CreateFamilyProfileModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _colorController;
  
  String _selectedRole = '';
  String _selectedNotificationPreference = '';
  String _selectedColor = '';
  
  late final FamilyViewModel _familyViewModel;
  bool _isSubmitting = false;

  final List<String> _roles = [
    'Mom',
    'Dad',
    'Child',
    'Teen',
    'Grandparent',
    'Caregiver',
    'Other',
  ];

  final List<String> _notificationPreferences = [
    'SMS',
    'Email',
    'Push Notification',
    'None',
  ];

  final List<Color> _predefinedColors = [
    const Color(0xFFEC4899), // Pink
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF10B981), // Green
    const Color(0xFFF59E0B), // Orange
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFEF4444), // Red
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF84CC16), // Lime
    const Color(0xFFF97316), // Orange Red
    const Color(0xFF6366F1), // Indigo
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _colorController = TextEditingController(text: '#3B82F6');
    
    _selectedRole = '';
    _selectedNotificationPreference = ''; // No default selection
    _selectedColor = '#3B82F6';
    
    // Get or create FamilyViewModel instance
    _familyViewModel = Get.find<FamilyViewModel>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _colorController.dispose();
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
                        Icons.add,
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
                            "Create Family Profile",
                            style: TextStyle(
                              fontFamily: 'Prompt_Bold',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Create a coordination profile for a family member. Perfect for children, teens, or family members who don't need their own login account. For parents who need account access, use the invite options instead.",
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
              // Scrollable Form Fields
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // Name Field
                      _buildFormField(
                        label: "Name",
                        controller: _nameController,
                        hintText: "Enter family member's name",
                      ),
                      SizedBox(height: 16.h),
                      // Role Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Role",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          CustomDropdown<String>(
                            value: _selectedRole.isEmpty ? null : _selectedRole,
                            hintText: "Select a role",
                            items: _roles.toDropdownItems((item) => item),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value ?? '';
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Phone Number Field
                      _buildFormField(
                        label: "Phone Number (Optional - For Notifications)",
                        controller: _phoneController,
                        hintText: "Enter phone number for SMS notifications",
                      ),
                      SizedBox(height: 16.h),
                      // Email Field
                      _buildFormField(
                        label: "Email (Optional - For Notifications)",
                        controller: _emailController,
                        hintText: "Enter email address for notifications",
                      ),
                      SizedBox(height: 16.h),
                      // Notification Preference Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Notification Preference (Optional)",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Only needed if phone or email is provided",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.subHeadingColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          CustomDropdown<String>(
                            value: _selectedNotificationPreference.isEmpty ? null : _selectedNotificationPreference,
                            hintText: "Select preference",
                            items: _notificationPreferences.toDropdownItems((item) => item),
                            onChanged: (value) {
                              setState(() {
                                _selectedNotificationPreference = value ?? '';
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Color Field
                      _buildColorField(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Action Buttons
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                child: Column(
                  children: [
                    // Add Member Button
                    SizedBox(
                      width: double.infinity,
                      height: 38.h,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleAddMember,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                "Add Member",
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
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
                            fontWeight: FontWeight.w600,
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

  /// Handle add member button press
  Future<void> _handleAddMember() async {
    // Validation
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedRole.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a role",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate that only Child or Teen roles are allowed for this endpoint
    final roleLower = _selectedRole.toLowerCase();
    if (roleLower != 'child' && roleLower != 'teen') {
      Get.snackbar(
        "Error",
        "This form is for adding Child or Teen profiles only. Please use the invite options for parents.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Map role to API format (API expects "child" for both child and teen)
    String apiRole = 'child';

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _familyViewModel.addFamilyMember(
        name: _nameController.text.trim(),
        role: apiRole,
        phoneNumber: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        notificationPreference: _selectedNotificationPreference.isEmpty 
            ? null 
            : _selectedNotificationPreference,
        colorCode: _selectedColor.isEmpty 
            ? null 
            : _selectedColor,
      );

      // Close modal on success
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Error is already handled in the ViewModel
      // Just reset submitting state
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
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


  Widget _buildColorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color (Optional)",
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xFF757575).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1.0,
            ),
            itemCount: _predefinedColors.length,
            itemBuilder: (context, index) {
              Color color = _predefinedColors[index];
              String colorHex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
              bool isSelected = _selectedColor == colorHex;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = colorHex;
                    _colorController.text = colorHex;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected ? AppColors.textColor : Colors.transparent,
                      width: isSelected ? 2 : 0,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ] : null,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
