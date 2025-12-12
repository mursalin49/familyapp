import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mom_app/theme/app_colors.dart';
import 'package:mom_app/theme/app_textstyles.dart';
import '../bottom_nav/bottom_nav.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'teen_username_login_screen.dart';
import 'signin_screen.dart';


class TeenInviteLoginScreen extends StatelessWidget {
  const TeenInviteLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              /// Icon
              SvgPicture.asset(
                'assets/icons/tabler_users.svg',
                height: 80,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 16),

              /// Title
              Text("Teen Login", style: AppTextStyles.title1),
              const SizedBox(height: 6),
              Text(
                "Access your family coordination hub",
                style: AppTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              /// Main Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
                    Text(
                      "Welcome Back!",
                      style: AppTextStyles.title1.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Tabs (Invite Code / Username)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/prime_mobile.svg',
                                  height: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Invite code",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => const TeenUsernameLoginScreen());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1.2),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Username",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Description
                    Text(
                      "Use the same invite code your parents sent you",
                      style: AppTextStyles.subtitleSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    /// Invite Code Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Family Invite Code",
                        style: AppTextStyles.title2.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hintText: "Enter your invite code",
                    ),
                    const SizedBox(height: 20),

                    /// Login Button
                    CustomButton(
                      text: "Login with Invite Code",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: () {
                        Get.to(() => const BottomNavScreen());
                      },
                    ),
                    const SizedBox(height: 24),

                    /// Footer Text
                    const Text("Don’t have an account yet?"),
                    const SizedBox(height: 6),
                    Text(
                      "Get an invite code from your parents",
                      style: TextStyle(color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),

                    /// Parent Login Button
                    TextButton.icon(
                      onPressed: () {
                        Get.to(() => const SignInScreen());
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black54),
                      label: const Text(
                        "Parent Login",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
