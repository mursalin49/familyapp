import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../theme/app_textstyles.dart';

class MealsHeader extends StatelessWidget {
  const MealsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.restaurant, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          "Meal Planning & Grocery Lists",
          style: TextStyle(
              fontFamily: AppTextStyles.pomot,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              //color: AppColors.textDark.withOpacity(0.8),
              color: Colors.black
          ),
        ),
      ],
    );
  }
}
