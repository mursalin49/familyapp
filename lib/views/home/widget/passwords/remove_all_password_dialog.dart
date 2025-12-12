import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemoveAllPasswordsDialog extends StatelessWidget {
  const RemoveAllPasswordsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Remove All Passwords",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                "Are you sure you want to delete all passwords?\nThis will permanently remove all your saved\npasswords and cannot be undone.",
                style: TextStyle(
                  fontFamily: 'Prompt_regular',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: (){

                },
                label: Text(
                  'Remove All',
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  elevation: 0,
                ),
              ),

              SizedBox(height: 8.h),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                label: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Prompt_regular',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1,  // Set the border width
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),

                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}