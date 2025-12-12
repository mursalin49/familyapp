
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../healpers/route.dart';

class AuthViewModel extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Signup controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final familyNameController = TextEditingController();

  final AuthService _authService = AuthService();

  // Observable loading state
  var isLoading = false.obs;
  var currentUser = Rxn<UserModel>();
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  /// Check if user is logged in by checking for stored token
  Future<void> checkAuthStatus() async {
    try {
      final token = await StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;
        
        // Load user data from storage
        final userId = await StorageService.getUserId();
        final userEmail = await StorageService.getUserEmail();
        
        if (userId != null && userEmail != null) {
          // Create a basic user model from stored data
          currentUser.value = UserModel(
            id: userId,
            email: userEmail,
          );
        }
      } else {
        isLoggedIn.value = false;
      }
    } catch (e) {
      isLoggedIn.value = false;
    }
  }

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated() async {
    try {
      final token = await StorageService.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get current user info from API
  Future<void> getUserInfo() async {
    try {
      final userData = await _authService.getUserInfo();
      currentUser.value = UserModel.fromJson(userData);
      debugPrint("✅ Loaded user info: ${currentUser.value?.familyname}");
    } catch (e) {
      debugPrint("❌ Error loading user info: $e");
      // Don't show snackbar here as it might be called on app start
    }
  }

  /// Sign out user and clear all stored data
  Future<void> signOut() async {
    try {
      await StorageService.clearAll();
      currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
    }
  }

  /// Sign in with email and password
  Future<void> signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter email and password");
      return;
    }

    debugPrint("🔐 Attempting login...");
    debugPrint("📧 Email: ${emailController.text.trim()}");
    debugPrint("🔑 Password: ${passwordController.text.isNotEmpty ? '***' : 'empty'}");

    isLoading.value = true;

    try {
      final response = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      debugPrint("✅ Login API Response received");
      debugPrint("📦 Response success: ${response.success}");
      debugPrint("📝 Response message: ${response.message}");

      if (response.success) {
        // Store token and user data
        await StorageService.saveToken(response.data.token);
        await StorageService.saveUserId(response.data.parent.id);
        await StorageService.saveUserEmail(response.data.parent.email);
        
        debugPrint("💾 Token saved: ${response.data.token.substring(0, 20)}...");
        debugPrint("👤 User ID saved: ${response.data.parent.id}");
        
        // Update current user
        currentUser.value = UserModel.fromParentModel(response.data.parent);
        isLoggedIn.value = true;

        // Show success message
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home screen
        Get.offNamed(AppRoutes.bottomNavScreen);
      } else {
        debugPrint("❌ Login failed: ${response.message}");
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Login Exception caught!");
      debugPrint("🔴 Error type: ${e.runtimeType}");
      debugPrint("🔴 Error message: $e");
      debugPrint("🔴 Stack trace: $stackTrace");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      debugPrint("🏁 Login process completed");
    }
  }

  /// Sign up with user details
  Future<void> signUp() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        familyNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.signUp(
        firstname: firstNameController.text.trim(),
        lastname: lastNameController.text.trim(),
        email: emailController.text.trim(),
        familyname: familyNameController.text.trim(),
        password: passwordController.text,
      );

      if (response.success) {
        // Store token and user data
        await StorageService.saveToken(response.data.token);
        await StorageService.saveUserId(response.data.parent.id);
        await StorageService.saveUserEmail(response.data.parent.email);
        
        // Update current user
        currentUser.value = UserModel.fromParentModel(response.data.parent);
        isLoggedIn.value = true;

        // Show success message
        Get.snackbar(
          "Success",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home screen
        Get.offNamed(AppRoutes.bottomNavScreen);
      } else {
        Get.snackbar(
          "Error",
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void createAccount() {
    debugPrint("Create Account pressed");
    Get.toNamed("/create_account");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    familyNameController.dispose();
    super.onClose();
  }
}
