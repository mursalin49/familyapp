import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';

class RecentChatCard extends StatelessWidget{
  final String title;
  final String time;
  final String description;

  const RecentChatCard({super.key, required this.title, required this.time, required this.description});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF757575).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),

              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

}