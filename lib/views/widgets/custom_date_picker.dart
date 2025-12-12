import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onClose;

  const CustomDatePicker({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    required this.onClose,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime currentMonth;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    currentMonth = widget.selectedDate ?? DateTime.now();
    selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              _buildHeader(),
              
              // Days of week
              _buildDaysOfWeek(),
              
              // Calendar grid
              _buildCalendarGrid(),
              
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          GestureDetector(
            onTap: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
              });
            },
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.chevron_left,
                color: AppColors.textColor,
                size: 20.sp,
              ),
            ),
          ),
          
          // Month and year
          Text(
            _getMonthYearText(),
            style: TextStyle(
              fontFamily: 'Prompt_Bold',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor,
            ),
          ),
          
          // Next month button
          GestureDetector(
            onTap: () {
              setState(() {
                currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
              });
            },
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.textColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeek() {
    final daysOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: daysOfWeek.map((day) => 
          Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  color: AppColors.subHeadingColor,
                ),
              ),
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    
    // Calculate the number of days from previous month to show
    final daysFromPrevMonth = firstWeekday - 1;
    
    // Calculate the number of days from next month to show
    final totalCells = 42; // 6 weeks * 7 days
    final daysFromNextMonth = totalCells - daysFromPrevMonth - daysInMonth;
    
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: 42, // 6 weeks * 7 days
        itemBuilder: (context, index) {
          if (index < daysFromPrevMonth) {
            // Previous month days (empty)
            return const SizedBox();
          } else if (index < daysFromPrevMonth + daysInMonth) {
            // Current month days
            final day = index - daysFromPrevMonth + 1;
            final date = DateTime(currentMonth.year, currentMonth.month, day);
            final isSelected = selectedDate.year == date.year &&
                              selectedDate.month == date.month &&
                              selectedDate.day == date.day;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                });
                widget.onDateSelected(date);
                widget.onClose();
              },
              child: Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 14.sp,
                      color: isSelected ? Colors.white : AppColors.textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Next month days (empty)
            return const SizedBox();
          }
        },
      ),
    );
  }

  String _getMonthYearText() {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[currentMonth.month - 1]} ${currentMonth.year}';
  }
}
