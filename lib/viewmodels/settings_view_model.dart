import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/settings_model.dart';
import '../services/settings_service.dart';

class SettingsViewModel extends GetxController {
  final SettingsService _settingsService = SettingsService();
  
  var settings = Rxn<SettingsModel>();
  var isLoading = false.obs;
  var error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// Load settings from API
  Future<void> loadSettings() async {
    isLoading.value = true;
    error.value = null;

    try {
      final loadedSettings = await _settingsService.getSettings();
      settings.value = loadedSettings;
      debugPrint("✅ Settings loaded successfully");
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading settings: $e");
      Get.snackbar(
        "Error",
        "Failed to load settings",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh settings
  Future<void> refresh() async {
    await loadSettings();
  }

  /// Get reminder interval as display string
  String getReminderIntervalDisplay(int minutes) {
    return "Every $minutes minutes";
  }

  /// Convert theme string to display format
  String getThemeDisplay(String theme) {
    if (theme.toLowerCase() == 'light') {
      return 'Light';
    } else if (theme.toLowerCase() == 'dark') {
      return 'Dark';
    }
    return theme;
  }

  /// Update mindful usage settings
  Future<void> updateMindfulUsage({
    required bool enabled,
    required int reminderInterval,
    required int breakDuration,
    required int dailyUsageGoal,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final updatedSettings = await _settingsService.updateMindfulUsage(
        enabled: enabled,
        reminderInterval: reminderInterval,
        breakDuration: breakDuration,
        dailyUsageGoal: dailyUsageGoal,
      );

      // Update local settings with the response
      settings.value = updatedSettings;
      debugPrint("✅ Mindful usage settings updated successfully");

      Get.snackbar(
        "Success",
        "Mindful usage settings updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error updating mindful usage settings: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}

