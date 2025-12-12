import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import 'api_service.dart';

class MessageService {
  /// Send a message to a family member
  Future<SendMessageResponse> sendMessage({
    required String recipientId,
    required String recipientType, // "Parent", "Teen", "Child"
    required String subject,
    required String message,
    required String deliveryMethod, // "in-app", "sms", "email", "all"
  }) async {
    try {
      debugPrint("📤 Sending message...");
      debugPrint("   Recipient ID: $recipientId");
      debugPrint("   Recipient Type: $recipientType");
      debugPrint("   Subject: $subject");
      debugPrint("   Message: $message");
      debugPrint("   Delivery Method: $deliveryMethod");

      final body = {
        'recipientId': recipientId,
        'recipientType': recipientType,
        'subject': subject,
        'message': message,
        'deliveryMethod': deliveryMethod,
      };

      debugPrint("📤 Request body: ${jsonEncode(body)}");

      final response = await ApiService.post(
        endpoint: '/api/messages/send',
        body: body,
      );

      debugPrint("📥 Send message response status: ${response.statusCode}");
      debugPrint("📥 Send message response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return SendMessageResponse.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to send message');
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
                : 'Failed to send message';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to send message';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to send message with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in sendMessage: $e");
      rethrow;
    }
  }
}

