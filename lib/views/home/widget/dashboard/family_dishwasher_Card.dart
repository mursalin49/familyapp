import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../utils/app_colors.dart';


class FamilyDishwasherCard extends StatefulWidget {
  const FamilyDishwasherCard({super.key});

  @override
  State<FamilyDishwasherCard> createState() => _FamilyDishwasherCardState();
}

class _FamilyDishwasherCardState extends State<FamilyDishwasherCard> {

  bool _isClean = true;
  static const Color primaryPink = Color(0xFFED3C8C);

  // Function to determine the status text and color
  Map<String, dynamic> _getStatusDetails() {
    if (_isClean) {
      return {
        'message': 'Clean or needs to be unloaded',
        'color': Colors.green.shade700,
        'icon': Icons.check_circle_outline,
      };
    } else {
      return {
        'message': 'Dirty or needs to be loaded',
        'color': Colors.red.shade700,
        'icon': Icons.warning_amber,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatusDetails();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF757575).withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 1. Title Row
            Row(
              children: <Widget>[
                Icon(Icons.people_alt_outlined, size: 28, color: Color(0xFF456EC6)),
                SizedBox(width: 10),
                Text(
                  "Family Dishwasher",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dirty / Clean",
                      style: TextStyle(
                        fontFamily: 'Prompt_regular',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/timerIcon.svg", color: Color(0xFF757575)),
                        SizedBox(width: 5.w),
                        Text(
                          "Updated 9/25/2025",
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

            const SizedBox(height: 15),

            // 3. Dynamic Status Message
            Row(
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: status['color'],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  status['message'],
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: status['color'],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFEAEEF4), // Light grey background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Shared with all family members - help keep everyone informed!",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}