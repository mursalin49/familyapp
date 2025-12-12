
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_app/views/auth/teen_invite_login_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyles.dart';
import '../../../viewmodels/auth_view_mode.dart';
import '../../healpers/route.dart';
import '../notes/notes_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'JointFamily.dart';
import 'forgot_password_screen.dart';
import 'create_account_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.backgroundGradientStart,
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // -------- Logo --------
                    Image.asset(
                      'assets/images/logo.png',
                      height: 136,
                      width: 297,
                    ),
                    const SizedBox(height: 10),

                    // -------- Title --------
                    Text(
                      "Welcome Back",
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Sign in to your family command center",
                      style: AppTextStyles.subtitle,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // -------- Email --------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: AppTextStyles.subtitleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: "Enter your email",
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(height: 20),

                    // -------- Password --------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: AppTextStyles.subtitleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: "Enter your password",
                      controller: viewModel.passwordController,
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
                    const SizedBox(height: 28),

                    // -------- Sign In Button --------
                    Obx(() => CustomButton(
                      text: viewModel.isLoading.value ? "Signing In..." : "Sign In",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onPressed: viewModel.isLoading.value
                          ? null
                          : () {
                              viewModel.signIn();
                            },
                    )),
                    const SizedBox(height: 12),

                    Text("OR", style: AppTextStyles.subtitleSmall),
                    const SizedBox(height: 12),

                    // -------- Teen Login --------
                    CustomButton(
                      icon: Icons.group,
                      text: "Teen Login",
                      color: Colors.white,
                      textColor: AppColors.secondary,
                      onPressed: () {
                        Get.toNamed(AppRoutes.teenLogin);
                      },
                    ),
                    const SizedBox(height: 12),

                    // -------- Join Family --------
                    CustomButton(
                      text: "Join Family with Invite Code",
                      color: Colors.white,
                      textColor: AppColors.blue,
                      icon: Icons.group_add_outlined,
                      onPressed: () {
                        //Get.to(() => const JoinFamilyScreen());
                      },
                    ),
                    const SizedBox(height: 12),

                    // -------- Forgot Password --------
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ForgetPasswordScreen());
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // -------- Create Account --------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.createAccountScreen);
                          },
                          child: Text(
                            "Create one",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
