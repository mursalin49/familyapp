import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            offset: const Offset(4, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 65.h, bottom: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/icons/appIcon.svg"),
                SizedBox(width: 10.w),
                Text(
                  "THE MOM APP",
                  style: TextStyle(
                    fontFamily: 'Prompt_Bold',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/notificationIcon.svg",
                      width: 22.w, height: 22.h),
                ),
                SizedBox(width: 16.w),
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/profileIcon.svg",
                      width: 19.w, height: 19.h),
                ),
                SizedBox(width: 5.w),
                Text(
                  "TJ",
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(width: 10.w),
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset("assets/icons/settingsIcon.svg",
                      width: 20.w, height: 20.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h); // appbar height নির্ধারণ
}
