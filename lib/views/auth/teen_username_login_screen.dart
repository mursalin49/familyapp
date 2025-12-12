
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mom_app/theme/app_colors.dart';
import 'package:mom_app/theme/app_textstyles.dart';
import '../bottom_nav/bottom_nav.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'forgot_password_screen.dart';
import 'teen_invite_login_screen.dart';
import 'signin_screen.dart';


class TeenUsernameLoginScreen extends StatefulWidget {
  const TeenUsernameLoginScreen({super.key});

  @override
  State<TeenUsernameLoginScreen> createState() =>
      _TeenUsernameLoginScreenState();
}

class _TeenUsernameLoginScreenState extends State<TeenUsernameLoginScreen> {
  bool _obscurePassword = true;

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
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 40),

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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
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

                      /// Tabs (Invite code / Username)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => const TeenInviteLoginScreen());
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/prime_mobile.svg',
                                      height: 18,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "Invite code",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Instruction
                      Text(
                        "Use your username and password",
                        style: AppTextStyles.subtitleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      /// Username Label
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter your username",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Username Field
                      const CustomTextField(
                        hintText: "Username",
                      ),
                      const SizedBox(height: 18),

                      /// Password Label
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter your password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Password Field
                      CustomTextField(
                        hintText: "Password",
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Login Button
                      CustomButton(
                        text: "Login",
                        color: AppColors.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          Get.to(() => const BottomNavScreen());
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Forgot Password
                      TextButton(
                        onPressed: () {
                          Get.to(() => const ForgetPasswordScreen());
                        },
                        child: Text(
                          "Forgot your password?",
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),

                      const SizedBox(height: 24),
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
                        icon:
                        const Icon(Icons.arrow_back, color: Colors.black54),
                        label: const Text(
                          "Parent Login",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
}
