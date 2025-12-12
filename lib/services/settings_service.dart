import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import 'api_service.dart';

class SettingsService {
  /// Get user settings
  Future<SettingsModel> getSettings() async {
    try {
      debugPrint("📥 Fetching settings from API...");

      final response = await ApiService.get(
        endpoint: '/api/settings',
      );

      debugPrint("📥 Settings response status: ${response.statusCode}");
      debugPrint("📥 Settings response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return SettingsModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load settings');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          
          // Handle errors array (for validation errors)
          if (errorResponse.containsKey('errors') && errorResponse['errors'] is List) {
            final errors = errorResponse['errors'] as List;
            final errorMessage = errors.isNotEmpty 
                ? errors.join(', ') 
                : 'Failed to load settings';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to load settings';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to load settings with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in getSettings: $e");
      rethrow;
    }
  }

  /// Update mindful usage settings
  Future<SettingsModel> updateMindfulUsage({
    required bool enabled,
    required int reminderInterval,
    required int breakDuration,
    required int dailyUsageGoal,
  }) async {
    try {
      debugPrint("📤 Updating mindful usage settings...");
      debugPrint("   Enabled: $enabled");
      debugPrint("   Reminder Interval: $reminderInterval");
      debugPrint("   Break Duration: $breakDuration");
      debugPrint("   Daily Usage Goal: $dailyUsageGoal");

      final response = await ApiService.patch(
        endpoint: '/api/settings/mindfulUsage',
        body: {
          'enabled': enabled,
          'reminderInterval': reminderInterval,
          'breakDuration': breakDuration,
          'dailyUsageGoal': dailyUsageGoal,
        },
      );

      debugPrint("📥 Update response status: ${response.statusCode}");
      debugPrint("📥 Update response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return SettingsModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to update mindful usage settings');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          
          // Handle errors array (for validation errors)
          if (errorResponse.containsKey('errors') && errorResponse['errors'] is List) {
            final errors = errorResponse['errors'] as List;
            final errorMessage = errors.isNotEmpty 
                ? errors.join(', ') 
                : 'Failed to update mindful usage settings';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to update mindful usage settings';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to update mindful usage settings with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in updateMindfulUsage: $e");
      rethrow;
    }
  }
}

