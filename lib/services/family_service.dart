import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/family_member_model.dart';
import 'api_service.dart';

class FamilyService {
  /// Get all family members
  Future<List<FamilyMemberModel>> getFamilyMembers() async {
    try {
      final response = await ApiService.get(
        endpoint: '/api/children/family-members',
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
          return data.map((json) => FamilyMemberModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load family members');
        }
      } else if (response.statusCode == 401) {
      
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(errorResponse['message'] ?? 'Failed to load family members');
        } catch (e) {
          throw Exception('Failed to load family members with status ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Get only children (for task assignment)
  Future<List<FamilyMemberModel>> getChildren() async {
    final members = await getFamilyMembers();
    return members.where((member) => member.role == 'child').toList();
  }
  
  /// Get only parents
  Future<List<FamilyMemberModel>> getParents() async {
    final members = await getFamilyMembers();
    return members.where((member) => member.role == 'parent').toList();
  }

  /// Map UI notification preference to API enum value
  String? _mapNotificationPreference(String? uiValue) {
    if (uiValue == null || uiValue.isEmpty) {
      return '';
    }
    
    // Map UI values to API enum values
    // Based on common API patterns, trying lowercase for most, camelCase for multi-word
    switch (uiValue.toLowerCase()) {
      case 'sms':
        return 'sms';
      case 'email':
        return 'email';
      case 'push notification':
      case 'pushnotification':
        return 'pushNotification'; // Try camelCase for multi-word
      case 'none':
        return 'none';
      default:
        // If it's already in the correct format, return as is
        return uiValue.toLowerCase();
    }
  }

  /// Add child or teen profile
  Future<FamilyMemberModel> addChildOrTeenProfile({
    required String name,
    required String role,
    String? phoneNumber,
    String? email,
    String? notificationPreference,
    String? colorCode,
  }) async {
    try {
      // Build request body - only include fields that have values
      final body = <String, dynamic>{
        'name': name,
        'role': role,
      };

      // Add optional fields only if they have values
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        body['phoneNumber'] = phoneNumber;
      } else {
        body['phoneNumber'] = '';
      }

      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      } else {
        body['email'] = '';
      }

      // Map notification preference to API enum format
      final mappedNotificationPreference = _mapNotificationPreference(notificationPreference);
      body['notificationPreference'] = mappedNotificationPreference ?? '';

      if (colorCode != null && colorCode.isNotEmpty) {
        body['colorCode'] = colorCode;
      } else {
        body['colorCode'] = '';
      }

      debugPrint("📤 Creating child/teen profile:");
      debugPrint("   Name: $name");
      debugPrint("   Role: $role");
      debugPrint("   Phone: ${body['phoneNumber']}");
      debugPrint("   Email: ${body['email']}");
      debugPrint("   Notification: ${body['notificationPreference']}");
      debugPrint("   Color: ${body['colorCode']}");

      final response = await ApiService.post(
        endpoint: '/api/children',
        body: body,
      );

      debugPrint("📥 Response status: ${response.statusCode}");
      debugPrint("📥 Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return FamilyMemberModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to create child profile');
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
                : 'Failed to create child profile';
            debugPrint("❌ API Validation Errors: $errorMessage");
            throw Exception(errorMessage);
          }
          
          // Handle single message field
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to create child profile';
          debugPrint("❌ API Error: $errorMessage");
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          debugPrint("❌ Failed to parse error response: ${response.body}");
          throw Exception('Failed to create child profile with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in addChildOrTeenProfile: $e");
      rethrow;
    }
  }

  /// Delete child or teen profile
  Future<void> deleteChild(String childId) async {
    try {
      debugPrint("🗑️ Deleting child with ID: $childId");

      final response = await ApiService.delete(
        endpoint: '/api/children/$childId',
      );

      debugPrint("📥 Delete response status: ${response.statusCode}");
      debugPrint("📥 Delete response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          debugPrint("✅ Child deleted successfully");
          return;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to delete child');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else if (response.statusCode == 404) {
        throw Exception('Child not found');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          
          // Handle errors array (for validation errors)
          if (errorResponse.containsKey('errors') && errorResponse['errors'] is List) {
            final errors = errorResponse['errors'] as List;
            final errorMessage = errors.isNotEmpty 
                ? errors.join(', ') 
                : 'Failed to delete child';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to delete child';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to delete child with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in deleteChild: $e");
      rethrow;
    }
  }
}

