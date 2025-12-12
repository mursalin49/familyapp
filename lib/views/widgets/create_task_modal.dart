import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'custom_date_picker.dart';
import 'custom_time_picker.dart';
import 'custom_dropdown.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/task_view_model.dart';
import '../../viewmodels/family_view_model.dart';
import '../../models/task_model.dart';
import '../../models/family_member_model.dart';

class CreateTaskModal extends StatefulWidget {
  final TaskModel? task; // If provided, modal is in edit mode
  
  const CreateTaskModal({super.key, this.task});

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();

  late final TaskViewModel _taskViewModel;
  late final FamilyViewModel _familyViewModel;
  
  @override
  void initState() {
    super.initState();
    // Get or create ViewModels (use find if exists, otherwise put)
    try {
      _taskViewModel = Get.find<TaskViewModel>();
    } catch (e) {
      _taskViewModel = Get.put(TaskViewModel());
    }
    
    try {
      _familyViewModel = Get.find<FamilyViewModel>();
    } catch (e) {
      _familyViewModel = Get.put(FamilyViewModel());
    }
    
    // If editing, populate fields with task data
    if (widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      selectedPriority = task.priority;
      
      // Set assigned member
      if (task.assignedTo.isNotEmpty) {
        selectedAssignToMemberId = task.assignedTo.first.memberId;
      }
      
      // Set points
      if (task.points > 0) {
        selectedPointsReward = "${task.points} Points";
      } else {
        selectedPointsReward = "None (No Points)";
      }
      
      isPrivateTask = task.isPrivate;
      selectedDate = task.dueDate;
      
      // Parse dueTime from "HH:mm" string to TimeOfDay
      if (task.dueTime != null && task.dueTime!.isNotEmpty) {
        try {
          final parts = task.dueTime!.split(':');
          if (parts.length == 2) {
            selectedTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
        } catch (e) {
          // Ignore parsing errors
        }
      }
      
      // Set date and time controllers
      if (selectedDate != null) {
        _dueDateController.text = _formatDateForDisplay(selectedDate!);
      }
      if (selectedTime != null) {
        _dueTimeController.text = _formatTimeForDisplay(selectedTime!);
      }
    }
  }

  String selectedPriority = "";
  String? selectedAssignToMemberId; // Store member ID instead of display name
  String selectedPointsReward = "None (No Points)";
  bool isPrivateTask = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool _isSubmitting = false;
  
  String _formatDateForDisplay(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
  
  String _formatTimeForDisplay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _dueTimeController.dispose();
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildTitleField(),
                  _buildDescriptionField(),
                  _buildPriorityAndAssignToRow(),
                  _buildPointsRewardField(),
                  _buildPrivateTaskField(),
                  _buildDueDateAndTimeRow(),
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.task != null ? "Edit Task" : "Create New Task",
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: AppColors.textColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  // Title Field Widget
  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          "Title *",
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: _titleController,
          hintText: "Enter your title",
        ),
      ],
    );
  }

  // Description Field Widget
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          "Description",
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: _descriptionController,
          hintText: "Enter task description",
          maxLines: 3,
        ),
      ],
    );
  }

  // Priority and Assign To Row Widget
  Widget _buildPriorityAndAssignToRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            // Priority
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Priority",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomDropdown<String>(
                    value: selectedPriority.isEmpty ? null : selectedPriority,
                    hintText: "Select",
                    items: [
                      "High",
                      "Medium", 
                      "Low",
                    ].toDropdownItems((item) => item),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPriority = newValue ?? "";
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Assign To
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assign To",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() {
                    final familyMembers = _familyViewModel.familyMembers;
                    final children = _familyViewModel.children;
                    
                    // Build dropdown items: Unassigned + Children/Teens
                    final List<String> assignToOptions = ["Unassigned"];
                    final Map<String, FamilyMemberModel> memberMap = {};
                    
                    for (var member in children) {
                      final displayName = "${member.displayName} (${member.role == 'child' ? 'Child' : 'Teen'})";
                      assignToOptions.add(displayName);
                      memberMap[displayName] = member;
                    }
                    
                    return CustomDropdown<String>(
                      value: selectedAssignToMemberId != null 
                          ? memberMap.entries.firstWhere(
                              (e) => e.value.id == selectedAssignToMemberId,
                              orElse: () => memberMap.entries.first,
                            ).key
                          : (selectedAssignToMemberId == null && assignToOptions.contains("Unassigned") ? "Unassigned" : null),
                      hintText: "Select",
                      prefixIcon: Icon(
                        Icons.filter_list,
                        color: AppColors.textColor,
                        size: 20.sp,
                      ),
                      items: assignToOptions.toDropdownItems((item) => item),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue == "Unassigned" || newValue == null) {
                            selectedAssignToMemberId = null;
                          } else {
                            final member = memberMap[newValue];
                            selectedAssignToMemberId = member?.id;
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Points Reward Field Widget
  Widget _buildPointsRewardField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          "Points Reward",
          style: TextStyle(
            fontFamily: 'Prompt_Bold',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 8.h),
        CustomDropdown<String>(
          value: selectedPointsReward.isEmpty ? null : selectedPointsReward,
          hintText: "Select Points",
          items: [
            "None (No Points)",
            "5 Points",
            "10 Points",
            "15 Points",
            "20 Points",
            "25 Points",
            "30 Points",
            "50 Points",
          ].toDropdownItems((item) => item),
          onChanged: (String? newValue) {
            setState(() {
              selectedPointsReward = newValue ?? "";
            });
          },
        ),
      ],
    );
  }

  // Private Task Field Widget
  Widget _buildPrivateTaskField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            Icon(
              Icons.lock,
              color: AppColors.textColor,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Private Task",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    "Only you can see this task",
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      color: AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isPrivateTask,
              onChanged: (value) {
                setState(() {
                  isPrivateTask = value;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  // Due Date and Time Row Widget
  Widget _buildDueDateAndTimeRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            // Due Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Date",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDatePicker(
                          selectedDate: selectedDate,
                          onDateSelected: (date) {
                            setState(() {
                              selectedDate = date;
                              _dueDateController.text = "${date.day}/${date.month}/${date.year}";
                            });
                          },
                          onClose: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: _buildTextField(
                      controller: _dueDateController,
                      hintText: "Pick Date",
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Due Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Time",
                    style: TextStyle(
                      fontFamily: 'Prompt_Bold',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomTimePicker(
                          selectedTime: selectedTime,
                          onTimeSelected: (time) {
                            setState(() {
                              selectedTime = time;
                              _dueTimeController.text = time.format(context);
                            });
                          },
                          onClose: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    child: _buildTextField(
                      controller: _dueTimeController,
                      hintText: "--:--",
                      suffixIcon: Icons.access_time,
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Action Buttons Widget
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Row(
          children: [
            // Cancel Button
            Expanded(
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Create Task Button
            Expanded(
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isSubmitting ? null : _handleCreateTask,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Center(
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
                              widget.task != null ? "Update Task" : "Create Task",
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
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 14.sp,
            color: AppColors.subHeadingColor,
          ),
          prefixIcon: prefixIcon != null ? Icon(
            prefixIcon,
            color: AppColors.textColor,
            size: 20.sp,
          ) : null,
          suffixIcon: suffixIcon != null ? Icon(
            suffixIcon,
            color: AppColors.textColor,
            size: 20.sp,
          ) : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  /// Handle create/update task button press
  Future<void> _handleCreateTask() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a title",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPriority.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a priority",
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
      // Parse points from "5 Points" or "None (No Points)" format
      int points = 0;
      if (selectedPointsReward != "None (No Points)") {
        final match = RegExp(r'(\d+)').firstMatch(selectedPointsReward);
        if (match != null) {
          points = int.parse(match.group(1)!);
        }
      }

      // Build assignedTo array
      List<AssignedMember> assignedTo = [];
      if (selectedAssignToMemberId != null) {
        final member = _familyViewModel.getMemberById(selectedAssignToMemberId!);
        if (member != null) {
          // Determine member type
          String memberType = "Child";
          if (member.role == 'child') {
            memberType = member.isTeen ? "Teen" : "Child";
          } else if (member.role == 'parent') {
            memberType = "Parent";
          }
          
          assignedTo.add(AssignedMember(
            memberId: member.id,
            memberType: memberType,
          ));
        }
      }

      // Format dueTime from TimeOfDay to "HH:mm"
      String? dueTimeStr;
      if (selectedTime != null) {
        dueTimeStr = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      }

      if (widget.task != null) {
        // Update existing task - only send changed fields
        await _taskViewModel.updateTask(
          taskId: widget.task!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: selectedPriority,
          assignedTo: assignedTo,
          points: points,
          isPrivate: isPrivateTask,
          dueDate: selectedDate,
          dueTime: dueTimeStr,
        );
      } else {
        // Create new task
        await _taskViewModel.createTask(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: selectedPriority,
          assignedTo: assignedTo,
          points: points,
          isPrivate: isPrivateTask,
          dueDate: selectedDate,
          dueTime: dueTimeStr,
        );
      }

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

}
