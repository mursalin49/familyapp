
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../healpers/route.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/auth_view_mode.dart';
import '../auth/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final authViewModel = Get.find<AuthViewModel>();
      
      await Future.delayed(const Duration(seconds: 2));
      
      final isAuthenticated = await authViewModel.isAuthenticated();
      
      debugPrint("🔍 Auth check result: $isAuthenticated");
      
      if (isAuthenticated) {
        Get.offAllNamed(AppRoutes.bottomNavScreen);
      } else {
        Get.offAllNamed(AppRoutes.signInScreen);
      }
    } catch (e) {
      Get.offAllNamed(AppRoutes.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundGradientStart,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.15),

            // App Logo
            Image.asset(
              'assets/images/logo.png',
              height: 270,
              width: 393,
            ),
            const SizedBox(height: 20),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.circle, size: 8, color: AppColors.primary),
                SizedBox(width: 6),
                Icon(Icons.circle, size: 8, color: AppColors.secondary),
                SizedBox(width: 6),
                Icon(Icons.circle, size: 8, color: AppColors.primary),
              ],
            ),

            SizedBox(height: screenHeight * 0.4),

            const Text(
              "Version 3.0",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
