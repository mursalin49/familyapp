import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/custom_time_picker.dart';
import '../../viewmodels/event_view_model.dart';
import '../../viewmodels/family_view_model.dart';
import '../../models/family_member_model.dart';

class CreateEventModal extends StatefulWidget {
  final DateTime selectedDate;
  
  const CreateEventModal({
    super.key,
    required this.selectedDate,
  });

  @override
  State<CreateEventModal> createState() => _CreateEventModalState();
}

class _CreateEventModalState extends State<CreateEventModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  late final EventViewModel _eventViewModel;
  late final FamilyViewModel _familyViewModel;
  
  bool _isAllDay = false;
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = const TimeOfDay(hour: 22, minute: 0);
  
  // Family member selection - using member IDs as keys
  final Map<String, bool> _familyMembers = {};
  
  // Assigned to all toggle
  bool _assignedToAll = false;
  
  // Privacy settings
  String _visibility = 'shared'; // API format: 'private' or 'shared'
  final List<String> _visibilityOptions = ['shared', 'private'];
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Get or create ViewModels
    try {
      _eventViewModel = Get.find<EventViewModel>();
    } catch (e) {
      _eventViewModel = Get.put(EventViewModel());
    }
    
    try {
      _familyViewModel = Get.find<FamilyViewModel>();
    } catch (e) {
      _familyViewModel = Get.put(FamilyViewModel());
    }
    
    _startDate = widget.selectedDate;
    _endDate = widget.selectedDate;
    
    // Initialize family members map
    _initializeFamilyMembers();
  }
  
  void _initializeFamilyMembers() {
    final members = _familyViewModel.familyMembers;
    for (var member in members) {
      _familyMembers[member.id] = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
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
                        Icons.calendar_today_outlined,
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
                            "Create Event",
                            style: TextStyle(
                              fontFamily: 'Prompt_Bold',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Create event for ${_formatDate(widget.selectedDate)}",
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
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: AppColors.subHeadingColor,
                        size: 20.sp,
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
                      // Event Details Section
                      //_buildSectionHeader("Event Details", Icons.event_outlined),
                      //SizedBox(height: 12.h),
                      
                      // Event Title
                      _buildTextField(
                        controller: _titleController,
                        label: "Event Title",
                        hint: "Enter event title",
                      ),
                      SizedBox(height: 12.h),
                      
                      // Description
                      _buildTextField(
                        controller: _descriptionController,
                        label: "Description",
                        hint: "Event description (optional)",
                        maxLines: 2,
                      ),
                      SizedBox(height: 12.h),
                      
                      // Location
                      _buildTextField(
                        controller: _locationController,
                        label: "Location",
                        hint: "Enter event location (optional)",
                        prefixIcon: Icons.location_on_outlined,
                      ),
                      SizedBox(height: 20.h),
                      
                      // Assign to Family Members Section
                      _buildSectionHeader("Assign to Family Members", Icons.people_outline),
                      SizedBox(height: 12.h),
                      
                      // Assigned to All toggle
                      Row(
                        children: [
                          Switch(
                            value: _assignedToAll,
                            onChanged: (value) {
                              setState(() {
                                _assignedToAll = value;
                                if (value) {
                                  // Clear all selections when assigned to all
                                  for (var key in _familyMembers.keys) {
                                    _familyMembers[key] = false;
                                  }
                                }
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              "Assign to all family members",
                              style: TextStyle(
                                fontFamily: 'Prompt_regular',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      // Only show member selection if not assigned to all
                      if (!_assignedToAll) ...[
                        // Action buttons
                        Row(
                          children: [
                            _buildActionButton("Select All", () => _selectAllMembers(true)),
                            SizedBox(width: 8.w),
                            _buildActionButton("Clear All", () => _selectAllMembers(false)),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                "${_familyMembers.values.where((selected) => selected).length} of ${_familyMembers.length} selected",
                                style: TextStyle(
                                  fontFamily: 'Prompt_regular',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.subHeadingColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        
                        // Family member checkboxes
                        Obx(() {
                          final members = _familyViewModel.familyMembers;
                          return Column(
                            children: members.map((member) => _buildMemberCheckbox(member)).toList(),
                          );
                        }),
                        SizedBox(height: 8.h),
                        
                        Text(
                          "Select which family members this event is assigned to. Everyone will see the event, but only assigned members get notifications.",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ] else ...[
                        Text(
                          "This event will be assigned to all family members.",
                          style: TextStyle(
                            fontFamily: 'Prompt_regular',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subHeadingColor,
                          ),
                        ),
                      ],
                      SizedBox(height: 20.h),
                      
                      // Event Timing Section
                      _buildSectionHeader("Event Timing", Icons.access_time_outlined),
                      SizedBox(height: 12.h),
                      
                      // All day toggle
                      Row(
                        children: [
                          Switch(
                            value: _isAllDay,
                            onChanged: (value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "All day event",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      // Date and time fields
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              label: "Start Date",
                              value: _formatDate(_startDate),
                              onTap: () => _selectDate(context, true),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          if (!_isAllDay)
                            Expanded(
                              child: _buildTimeField(
                                label: "Start Time",
                                value: _formatTime(_startTime),
                                onTap: () => _selectTime(context, true),
                                icon: Icons.access_time_outlined,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      // End date and time - only show if not all day event
                      if (!_isAllDay)
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                label: "End Date",
                                value: _formatDate(_endDate),
                                onTap: () => _selectDate(context, false),
                                icon: Icons.calendar_today_outlined,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildTimeField(
                                label: "End Time",
                                value: _formatTime(_endTime),
                                onTap: () => _selectTime(context, false),
                                icon: Icons.access_time_outlined,
                              ),
                            ),
                          ],
                        ),
                      if (!_isAllDay) SizedBox(height: 12.h),
                      SizedBox(height: 20.h),
                      
                      // Privacy & Sharing Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader("Privacy & Sharing", Icons.visibility_outlined),
                            SizedBox(height: 12.h),
                            
                            // Visibility dropdown
                            CustomDropdown<String>(
                              items: [
                                'shared',
                                'private',
                              ].toDropdownItems((item) => item == 'shared' ? 'Shared' : 'Private'),
                              value: _visibility,
                              onChanged: (String? value) {
                                setState(() {
                                  _visibility = value ?? 'shared';
                                });
                              },
                              hintText: "Select visibility",
                            ),
                            SizedBox(height: 8.h),
                            
                            Text(
                              _visibility == 'shared' 
                                  ? "All family members can see event details"
                                  : "Only you can see this event",
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
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
              
              // Create Event Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _createEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
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
                            "Create Event",
                            style: TextStyle(
                              fontFamily: 'Prompt_regular',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 18.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    int maxLines = 1,
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
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16.sp, color: AppColors.subHeadingColor) : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            hintStyle: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 13.sp,
              color: AppColors.subHeadingColor,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 13.sp,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberCheckbox(FamilyMemberModel member) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Checkbox(
            value: _familyMembers[member.id] ?? false,
            onChanged: (value) {
              setState(() {
                _familyMembers[member.id] = value ?? false;
              });
            },
            activeColor: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "${member.displayName} (${member.role == 'child' ? (member.isTeen ? 'Teen' : 'Child') : 'Parent'})",
              style: TextStyle(
                fontFamily: 'Prompt_regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
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
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: AppColors.subHeadingColor,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
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
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  color: AppColors.subHeadingColor,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  void _selectAllMembers(bool select) {
    setState(() {
      for (String memberId in _familyMembers.keys) {
        _familyMembers[memberId] = select;
      }
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    showDialog(
      context: context,
      builder: (context) => CustomDatePicker(
        selectedDate: isStartDate ? _startDate : _endDate,
        onDateSelected: (date) {
          setState(() {
            if (isStartDate) {
              _startDate = date;
            } else {
              _endDate = date;
            }
          });
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    showDialog(
      context: context,
      builder: (context) => CustomTimePicker(
        selectedTime: isStartTime ? _startTime : _endTime,
        onTimeSelected: (time) {
          setState(() {
            if (isStartTime) {
              _startTime = time;
            } else {
              _endTime = time;
            }
          });
        },
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _createEvent() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an event title",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_assignedToAll && _familyMembers.values.every((selected) => !selected)) {
      Get.snackbar(
        "Error",
        "Please select at least one family member or assign to all",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Format startTime from TimeOfDay to "HH:mm"
      String? startTimeStr;
      if (!_isAllDay) {
        startTimeStr = "${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}";
      }

      // Format endTime from TimeOfDay to "HH:mm"
      String? endTimeStr;
      DateTime? endDate;
      if (!_isAllDay) {
        endTimeStr = "${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}";
        endDate = _endDate;
      }

      // Get selected member IDs
      List<String>? assignedTo;
      if (!_assignedToAll) {
        assignedTo = _familyMembers.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();
      }

      await _eventViewModel.createEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        allDayEvent: _isAllDay,
        startDate: _startDate,
        startTime: startTimeStr,
        endDate: endDate,
        endTime: endTimeStr,
        visibility: _visibility,
        assignedTo: assignedTo,
        assignedToAll: _assignedToAll,
      );

      // Close modal on success
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Error is already handled in the ViewModel
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    
    if (hour == 0) return '12:$minute AM';
    if (hour < 12) return '$hour:$minute AM';
    if (hour == 12) return '12:$minute PM';
    return '${hour - 12}:$minute PM';
  }
}
