import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final VoidCallback onClose;

  const CustomTimePicker({
    super.key,
    this.selectedTime,
    required this.onTimeSelected,
    required this.onClose,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;
  
  late int selectedHour;
  late int selectedMinute;
  late bool isPM;

  @override
  void initState() {
    super.initState();
    final initialTime = widget.selectedTime ?? TimeOfDay.now();
    selectedHour = initialTime.hourOfPeriod;
    selectedMinute = initialTime.minute;
    isPM = initialTime.period == DayPeriod.pm;
    
    _hourController = FixedExtentScrollController(initialItem: selectedHour - 1);
    _minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    _periodController = FixedExtentScrollController(initialItem: isPM ? 1 : 0);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 10.w),
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
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      "Set time",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Time Picker
                _buildTimePicker(),
                
                SizedBox(height: 24.h),
                
                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      height: 200.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hours
          Flexible(
            flex: 1,
            child: _buildScrollableColumn(
              controller: _hourController,
              items: List.generate(12, (index) => (index + 1).toString().padLeft(2, '0')),
              onChanged: (index) {
                setState(() {
                  selectedHour = index + 1;
                });
              },
            ),
          ),
          
          // Colon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ),
          
          // Minutes
          Flexible(
            flex: 1,
            child: _buildScrollableColumn(
              controller: _minuteController,
              items: List.generate(60, (index) => index.toString().padLeft(2, '0')),
              onChanged: (index) {
                setState(() {
                  selectedMinute = index;
                });
              },
            ),
          ),
          
          // Colon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor,
              ),
            ),
          ),
          
          // Seconds
          Flexible(
            flex: 1,
            child: _buildScrollableColumn(
              controller: FixedExtentScrollController(initialItem: 0),
              items: List.generate(60, (index) => index.toString().padLeft(2, '0')),
              onChanged: (index) {
                // Seconds not used in this implementation
              },
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // AM/PM
          Flexible(
            flex: 1,
            child: _buildScrollableColumn(
              controller: _periodController,
              items: ['AM', 'PM'],
              onChanged: (index) {
                setState(() {
                  isPM = index == 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableColumn({
    required FixedExtentScrollController controller,
    required List<String> items,
    required Function(int) onChanged,
  }) {
    return Container(
      height: 200.h,
      child: ListWheelScrollView(
        controller: controller,
        itemExtent: 40.h,
        onSelectedItemChanged: onChanged,
        physics: const FixedExtentScrollPhysics(),
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = _isItemSelected(controller, index);
          
          return Container(
            height: 40.h,
            child: Center(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: isSelected ? 18.sp : 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppColors.textColor : AppColors.subHeadingColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isItemSelected(FixedExtentScrollController controller, int index) {
    if (controller == _hourController) {
      return selectedHour - 1 == index;
    } else if (controller == _minuteController) {
      return selectedMinute == index;
    } else if (controller == _periodController) {
      return (isPM ? 1 : 0) == index;
    }
    return false;
  }

  Widget _buildActionButtons() {
    return Row(
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
                onTap: widget.onClose,
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
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
        
        // Save Time Button
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
                onTap: () {
                  final time = TimeOfDay(
                    hour: isPM ? selectedHour + 12 : selectedHour,
                    minute: selectedMinute,
                  );
                  widget.onTimeSelected(time);
                  widget.onClose();
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Text(
                    "Save Time",
                    style: TextStyle(
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
    );
  }
}
