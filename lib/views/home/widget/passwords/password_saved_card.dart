import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'edit_password_dialog.dart';

class PasswordSavedCard extends StatelessWidget{
  final String title;
  final String category;
  final String url;
  final String mail;
  final String password;
  final String updatedDate;
  final bool isFavorite;

  const PasswordSavedCard({super.key, required this.title, required this.category, required this.url, required this.mail, required this.password, required this.updatedDate, required this.isFavorite});


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
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(Icons.star, color: Color(0xFFEAB308), size: 15)
                ],
              ),

              Row(
                children: [
                  SvgPicture.asset("assets/icons/goIcon.svg", width: 16.w, height: 16.h,),
                  SizedBox(width: 10.w),
                  Icon(Icons.star, color: Color(0xFFEAB308), size: 18)
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Color(0xFF5E208D).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF5E208D).withOpacity(0.2)),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontFamily: 'Prompt_regular',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E208D),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SvgPicture.asset("assets/icons/globalIcon.svg", width: 16.w, height: 16.h,),
              SizedBox(width: 4,),
              Text(
                url,
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/icons/profileIcon.svg", width: 16.w, height: 16.h,),
                  SizedBox(width: 4),
                  Text(
                    mail,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),

              InkWell(
                onTap: (){},
                child: Icon(Icons.copy, size: 18,),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/icons/globalIcon.svg", width: 16.w, height: 16.h,),
                  SizedBox(width: 4),
                  Text(
                    password,
                    style: TextStyle(
                      fontFamily: 'Prompt_regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  InkWell(
                    onTap: (){},
                    child: Icon(Icons.remove_red_eye, size: 18,),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: (){},
                    child: Icon(Icons.copy, size: 18,),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Updated: $updatedDate",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF757575),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      Get.dialog(const EditPasswordDialog());
                    },
                    child: SvgPicture.asset("assets/icons/editIcon.svg", width: 16, height: 16,),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: (){},
                    child: Icon(Icons.copy, size: 18,),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

}