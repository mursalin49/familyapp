
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom_app/views/auth/signin_screen.dart';
import '../../healpers/route.dart';
import '../../viewmodels/auth_view_mode.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import 'signin_screen.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AuthViewModel>();
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE6EE), // Light pink top
              Color(0xFFFFE6EE), // Light pink bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ---------- Logo ----------
                Image.asset(
                  'assets/images/logo.png',
                  height: 90,
                ),
                const SizedBox(height: 12),

                /// ---------- Join Title ----------
                const Text(
                  "Join The Mom App",
                  style: TextStyle(
                    color: Color(0xFFFF4081),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Create your family command center",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),

                /// ---------- First + Last Name ----------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- First Name ----
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "First Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            hintText: "First Name",
                            controller: viewModel.firstNameController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ---- Last Name ----
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Last Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomTextField(
                            hintText: "Last Name",
                            controller: viewModel.lastNameController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                /// ---------- Email ----------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: "Enter your email",
                  controller: viewModel.emailController,
                ),
                const SizedBox(height: 14),

                /// ---------- Password ----------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: "Create a password",
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
                const SizedBox(height: 14),

                /// ---------- Confirm Password ----------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: "Confirm your password",
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 14),

                /// ---------- Family Name ----------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Family Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  hintText: "e.g., The Smith Family",
                  controller: viewModel.familyNameController,
                ),
                const SizedBox(height: 20),

                /// ---------- Create Account Button ----------
                Obx(() => CustomButton(
                  text: viewModel.isLoading.value ? "Creating Account..." : "Create Account",
                  color: const Color(0xFFFF4081),
                  textColor: Colors.white,
                  onPressed: viewModel.isLoading.value
                      ? null
                      : () {
                          // Validate password match
                          if (viewModel.passwordController.text != confirmPasswordController.text) {
                            Get.snackbar(
                              "Error",
                              "Passwords do not match",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          viewModel.signUp();
                        },
                )),
                const SizedBox(height: 18),

                /// ---------- Already Have Account ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.signInScreen);
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFFFF4081),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
  }
}
