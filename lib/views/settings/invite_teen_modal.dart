import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../widgets/custom_dropdown.dart';

class InviteTeenModal extends StatefulWidget {
  const InviteTeenModal({super.key});

  @override
  State<InviteTeenModal> createState() => _InviteTeenModalState();
}

class _InviteTeenModalState extends State<InviteTeenModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String _selectedRole = 'Teen (Ages 13-17)';
  String _selectedInvitationMethod = 'Text Message';

  final List<String> _roles = [
    'Teen (Ages 13-17)',
    'Child (Ages 8-12)',
    'Young Adult (Ages 18-21)',
  ];

  final List<String> _invitationMethods = [
    'Text Message',
    'Email',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
                        Icons.people_outline,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        "Invite Teen to Family",
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
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Field
                      _buildFormField(
                        label: "Teen's Name",
                        controller: _nameController,
                        hintText: "Enter teen's name",
                      ),
                      SizedBox(height: 16.h),
                      // Role Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Role",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          CustomDropdown<String>(
                            value: _selectedRole,
                            items: _roles.toDropdownItems((item) => item),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Invitation Method
                      _buildInvitationMethodField(),
                      SizedBox(height: 16.h),
                      // Phone Number Field (shown when Text Message is selected)
                      if (_selectedInvitationMethod == 'Text Message')
                        _buildFormField(
                          label: "Phone Number",
                          controller: _phoneController,
                          hintText: "(555) 123-4567",
                        ),
                      SizedBox(height: 16.h),
                      // Teen Account Permissions
                      _buildPermissionsSection(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Action Button
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 38.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement create invitation
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
                      "Create Invitation",
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


  Widget _buildInvitationMethodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "How to send invitation",
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildInvitationMethodButton(
                title: "Text",
                icon: Icons.phone,
                isSelected: _selectedInvitationMethod == 'Text Message',
                onTap: () {
                  setState(() {
                    _selectedInvitationMethod = 'Text Message';
                  });
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildInvitationMethodButton(
                title: "Email",
                icon: Icons.email_outlined,
                isSelected: _selectedInvitationMethod == 'Email',
                onTap: () {
                  setState(() {
                    _selectedInvitationMethod = 'Email';
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInvitationMethodButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF757575).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.subHeadingColor,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Prompt_regular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Container(
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
            "Teen Account Permissions",
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E40AF),
            ),
          ),
          SizedBox(height: 8.h),
          _buildPermissionItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF10B981),
            text: "View assigned tasks and mark complete",
          ),
          SizedBox(height: 4.h),
          _buildPermissionItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF10B981),
            text: "See family calendar events",
          ),
          SizedBox(height: 4.h),
          _buildPermissionItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF10B981),
            text: "Receive push notifications for assignments",
          ),
          SizedBox(height: 4.h),
          _buildPermissionItem(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF10B981),
            text: "Basic profile management",
          ),
          SizedBox(height: 4.h),
          _buildPermissionItem(
            icon: Icons.cancel,
            iconColor: const Color(0xFFEF4444),
            text: "Cannot assign tasks to others",
          ),
          SizedBox(height: 4.h),
          _buildPermissionItem(
            icon: Icons.cancel,
            iconColor: const Color(0xFFEF4444),
            text: "Cannot access family passwords",
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 14.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1E40AF),
            ),
          ),
        ),
      ],
    );
  }
}
