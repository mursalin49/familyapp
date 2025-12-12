import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/task_model.dart';
import '../../utils/app_colors.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleComplete;

  const TaskItemWidget({
    super.key,
    required this.task,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFF3F4F6), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Header
          Row(
            children: [
              // Checkbox
              GestureDetector(
                onTap: onToggleComplete,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                    color: task.isCompleted ? AppColors.primary : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12.sp,
                        )
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              // Lock Icon
              if (task.isPrivate)
                Icon(
                  Icons.lock,
                  color: AppColors.subHeadingColor,
                  size: 16.sp,
                ),
              SizedBox(width: 8.w),
              // Task Title
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontFamily: 'Prompt_Bold',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              // Action Icons
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit,
                      color: AppColors.subHeadingColor,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.subHeadingColor,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Priority and Points Tags
          Row(
            children: [
              _buildTag(
                task.priority,
                _getPriorityColor(task.priority),
              ),
              SizedBox(width: 8.w),
              _buildTag(
                "${task.points} points",
                const Color(0xFF8B5CF6),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Description
          Text(
            task.description,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.subHeadingColor,
            ),
          ),
          SizedBox(height: 8.h),
          // Due Date and Time
          if (task.dueDate != null)
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.subHeadingColor,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  "Due ${_formatDate(task.dueDate!)}${task.dueTime != null ? ' at ${_formatTimeFromString(task.dueTime!)}' : ''}",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    color: AppColors.subHeadingColor,
                  ),
                ),
              ],
            ),
          SizedBox(height: 8.h),
          // Assigned To and Task ID
          Row(
            children: [
              Expanded(
                child: Text(
                  "Assigned to ${task.assignedToDisplay}",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    color: AppColors.subHeadingColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                "Task #${task.id}",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  color: AppColors.subHeadingColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Prompt_regular',
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
      case "High Priority":
        return const Color(0xFFEF4444);
      case "Medium":
      case "Medium Priority":
        return const Color(0xFFF59E0B);
      case "Low":
      case "Low Priority":
        return const Color(0xFF10B981);
      default:
        return AppColors.subHeadingColor;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "--:--";
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  String _formatTimeFromString(String timeStr) {
    // Format "HH:mm" to "H:MM AM/PM"
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return timeStr;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      final displayMinute = minute.toString().padLeft(2, '0');
      
      return "$displayHour:$displayMinute $period";
    } catch (e) {
      return timeStr;
    }
  }
}
