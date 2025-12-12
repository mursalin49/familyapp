
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mom_app/views/auth/teen_invite_login_screen.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_textstyles.dart';
import 'signin_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF1F5),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// ---------- White Card ----------
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// Icon
                      SvgPicture.asset(
                        'assets/icons/tabler_users.svg',
                        height: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),

                      /// Title
                      Text(
                        "Forget Your Password?",
                        style: AppTextStyles.title1
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "Contact your family admin for password assistance",
                        style: AppTextStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      /// ---------- Parents Card ----------
                      _infoCard(
                        title: "Parents",
                        iconPath: "assets/icons/Vector.svg",
                        description:
                        "As the family admin, you can reset anyone’s password including your own through the Family Settings.\n\nGo to Settings ➜ Family Members and click “Reset Password” next to any family member.",
                        textColor: Colors.blue.shade700,
                        bgColor: Colors.blue.shade50,
                        borderColor: Colors.blue.shade200,
                      ),

                      const SizedBox(height: 16),

                      /// ---------- Teens Card ----------
                      _infoCard(
                        title: "Teens & Family Members",
                        iconPath: "assets/icons/msg.svg",
                        description:
                        "Ask your parent to reset your password. They can do this instantly from the Family Settings in their app.",
                        textColor: Colors.purple.shade700,
                        bgColor: Colors.purple.shade50,
                        borderColor: Colors.purple.shade200,
                      ),

                      const SizedBox(height: 28),

                      /// ---------- Buttons ----------
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const SignInScreen());
                        },
                        child: const Text("Back to Parent Login", style: TextStyle(color: Colors.white),),
                      ),
                      const SizedBox(height: 12),

                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => const TeenInviteLoginScreen());
                        },
                        child: const Text(
                          "Back to Teen Login",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ---------- Go Back ----------
                      TextButton.icon(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.primary),
                        label: const Text(
                          "Go Back",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String description,
    required String iconPath,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 28,
            width: 28,
            color: textColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.subtitleSmall.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

