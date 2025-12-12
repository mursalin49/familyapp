import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FamilyMemberCard extends StatelessWidget{
  final String name;
  final String relation;
  final bool isActive;

  const FamilyMemberCard({super.key, required this.name, required this.relation, required this.isActive});


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
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              Icon(Icons.circle, color: isActive ? Colors.green : Color(0xFF757575), size: 10,)
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            relation,
            style: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

}