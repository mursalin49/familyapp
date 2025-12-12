import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_textstyles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class JoinFamilyScreen extends StatelessWidget {
  const JoinFamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // --- App Icon ---
              const Icon(Icons.family_restroom_rounded,
                  color: Colors.pink, size: 90),
              const SizedBox(height: 12),

              // --- App Title ---
              Text("Join Family",
                  style: AppTextStyles.title.copyWith(fontSize: 24)),
              const SizedBox(height: 4),
              Text(
                "Enter your family invite code below",
                style: AppTextStyles.subtitleSmall
                    .copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // --- Invite Code TextField ---

              const SizedBox(height: 24),

              // --- Join Button ---
              CustomButton(
                text: "Join Family",
                color: AppColors.primary,
                textColor: Colors.white,
                onPressed: () {
                  // TODO: Handle join logic
                },
              ),
              const SizedBox(height: 18),

              // --- Don’t have invite code ---
              Text(
                "Don’t have an invite code?",
                style: AppTextStyles.subtitleSmall,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {
                  // TODO: Go to request invite screen
                },

              ),
              const SizedBox(height: 30),

              // --- Back Button ---
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.pink),
                label: const Text(
                  "Go Back",
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
