import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  /// Create a new event
  Future<EventModel> createEvent({
    required String title,
    required String description,
    String? location,
    required bool allDayEvent,
    required DateTime startDate,
    String? startTime,
    DateTime? endDate,
    String? endTime,
    required String visibility,
    List<String>? assignedTo,
    required bool assignedToAll,
  }) async {
    try {
      debugPrint("📤 Creating event...");
      debugPrint("   Title: $title");
      debugPrint("   All Day: $allDayEvent");
      debugPrint("   Visibility: $visibility");
      debugPrint("   Assigned To All: $assignedToAll");

      final body = <String, dynamic>{
        'title': title,
        'description': description,
        'allDayEvent': allDayEvent,
        'startDate': '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
        'visibility': visibility,
        'assignedToAll': assignedToAll,
      };

      if (location != null && location.isNotEmpty) {
        body['location'] = location;
      }

      // Only add startTime if not all day event
      if (!allDayEvent && startTime != null && startTime.isNotEmpty) {
        body['startTime'] = startTime;
      }

      // Handle endDate and endTime
      if (allDayEvent) {
        // For all-day events, endDate is required (use startDate if endDate not provided)
        final eventEndDate = endDate ?? startDate;
        body['endDate'] = '${eventEndDate.year}-${eventEndDate.month.toString().padLeft(2, '0')}-${eventEndDate.day.toString().padLeft(2, '0')}';
        // endTime is not needed for all-day events
      } else {
        // For timed events, add endDate and endTime if provided
        if (endDate != null) {
          body['endDate'] = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
        }
        if (endTime != null && endTime.isNotEmpty) {
          body['endTime'] = endTime;
        }
      }

      // Only add assignedTo if assignedToAll is false
      if (!assignedToAll && assignedTo != null && assignedTo.isNotEmpty) {
        // If single user, send as string, otherwise as array
        if (assignedTo.length == 1) {
          body['assignedTo'] = assignedTo.first;
        } else {
          body['assignedTo'] = assignedTo;
        }
      }

      debugPrint("📤 Request body: ${jsonEncode(body)}");

      final response = await ApiService.post(
        endpoint: '/api/events',
        body: body,
      );

      debugPrint("📥 Create event response status: ${response.statusCode}");
      debugPrint("📥 Create event response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return EventModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to create event');
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
                : 'Failed to create event';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to create event';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to create event with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in createEvent: $e");
      rethrow;
    }
  }

  /// Get all events
  Future<List<EventModel>> getEvents() async {
    try {
      debugPrint("📥 Fetching events from API...");

      final response = await ApiService.get(
        endpoint: '/api/events',
      );

      debugPrint("📥 Events response status: ${response.statusCode}");
      debugPrint("📥 Events response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
          return data.map((json) => EventModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load events');
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
                : 'Failed to load events';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to load events';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to load events with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in getEvents: $e");
      rethrow;
    }
  }

  /// Get events by date range
  Future<List<EventModel>> getEventsByRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      debugPrint("📥 Fetching events from API for range ${startDate.toIso8601String().split('T')[0]} to ${endDate.toIso8601String().split('T')[0]}...");

      // Format dates as YYYY-MM-DD
      final startDateStr = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final endDateStr = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      final response = await ApiService.get(
        endpoint: '/api/events/range?startDate=$startDateStr&endDate=$endDateStr',
      );

      debugPrint("📥 Events range response status: ${response.statusCode}");
      debugPrint("📥 Events range response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
          return data.map((json) => EventModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load events');
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
                : 'Failed to load events';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to load events';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to load events with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in getEventsByRange: $e");
      rethrow;
    }
  }
}

