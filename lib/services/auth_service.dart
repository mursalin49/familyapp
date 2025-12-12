import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/auth_response_model.dart';
import 'api_service.dart';

class AuthService {
  Future<AuthResponseModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: '/api/auth/signin',
        body: {
          'email': email,
          'password': password,
        },
        requireAuth: false, 
      );


      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          return AuthResponseModel.fromJson(jsonResponse);
        } catch (e) {
          throw Exception('Invalid response format from server');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Login failed');
        } catch (e) {
          throw Exception('Login failed with status ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred during login: $e');
    }
  }

  /// Get current user info
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/auth/me',
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get user info');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Failed to get user info');
        } catch (e) {
          throw Exception('Failed to get user info with status ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred while getting user info: $e');
    }
  }

  /// Sign up with user details
  Future<AuthResponseModel> signUp({
    required String firstname,
    required String lastname,
    required String email,
    required String familyname,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: '/api/auth/signup',
        body: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'familyname': familyname,
          'password': password,
        },
        requireAuth: false, // Signup doesn't need authentication
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          return AuthResponseModel.fromJson(jsonResponse);
        } catch (e) {
          throw Exception('Invalid response format from server');
        }
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Signup failed');
        } catch (e) {
          throw Exception('Signup failed with status ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('An error occurred during signup: $e');
    }
  }
}
