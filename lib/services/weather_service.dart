import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import 'api_service.dart';

class WeatherService {
  /// Get outfit suggestion based on city
  Future<OutfitSuggestionModel> getOutfitSuggestion({required String city}) async {
    try {
      debugPrint("📥 Fetching weather/outfit suggestion for city: $city");

      final response = await ApiService.post(
        endpoint: '/api/outfit/suggest',
        body: {
          'city': city,
        },
      );

      debugPrint("📥 Weather response status: ${response.statusCode}");
      debugPrint("📥 Weather response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return OutfitSuggestionModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get weather suggestion');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          final errors = errorResponse['errors'] as List<dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            throw Exception(errors.first.toString());
          }
          throw Exception(errorResponse['message'] ?? 'Failed to get weather suggestion');
        } catch (e) {
          throw Exception('Failed to get weather suggestion with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Error in getOutfitSuggestion: $e");
      rethrow;
    }
  }
}

