import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import 'api_service.dart';

class TaskService {
  /// Get all tasks
  Future<List<TaskModel>> getTasks() async {
    try {
      debugPrint("📥 Fetching tasks from API...");

      final response = await ApiService.get(
        endpoint: '/api/tasks',
      );

      debugPrint("📥 Tasks response status: ${response.statusCode}");
      debugPrint("📥 Tasks response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] as List<dynamic>;
          return data.map((json) => TaskModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load tasks');
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
                : 'Failed to load tasks';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to load tasks';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to load tasks with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in getTasks: $e");
      rethrow;
    }
  }

  /// Create a new task
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String priority,
    required List<AssignedMember> assignedTo,
    required int points,
    required bool isPrivate,
    DateTime? dueDate,
    String? dueTime,
  }) async {
    try {
      debugPrint("📤 Creating task...");
      debugPrint("   Title: $title");
      debugPrint("   Priority: $priority");
      debugPrint("   Assigned To: ${assignedTo.length} member(s)");
      debugPrint("   Points: $points");
      debugPrint("   Is Private: $isPrivate");

      final body = {
        'title': title,
        'description': description,
        'priority': priority,
        'assignedTo': assignedTo.map((m) => m.toJson()).toList(),
        'isPrivate': isPrivate,
      };

      // Only include points if it's greater than 0 (API doesn't accept 0)
      if (points > 0) {
        body['points'] = points;
      }

      if (dueDate != null) {
        // Format as YYYY-MM-DD
        body['dueDate'] = '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
      }

      if (dueTime != null && dueTime.isNotEmpty) {
        body['dueTime'] = dueTime;
      }

      debugPrint("📤 Request body: ${jsonEncode(body)}");

      final response = await ApiService.post(
        endpoint: '/api/tasks',
        body: body,
      );

      debugPrint("📥 Create task response status: ${response.statusCode}");
      debugPrint("📥 Create task response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return TaskModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to create task');
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
            // Format error messages to be more user-friendly
            final formattedErrors = errors.map((e) {
              String errorStr = e.toString();
              // Remove backticks and make messages more readable
              errorStr = errorStr.replaceAll('`', '');
              // Make specific error messages more user-friendly
              if (errorStr.contains('is not a valid enum value for path `points`')) {
                return 'Points must be greater than 0. Please select a valid points reward.';
              }
              return errorStr;
            }).toList();
            final errorMessage = formattedErrors.isNotEmpty 
                ? formattedErrors.join(', ') 
                : 'Failed to create task';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to create task';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to create task with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in createTask: $e");
      rethrow;
    }
  }

  /// Update an existing task
  Future<TaskModel> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? priority,
    List<AssignedMember>? assignedTo,
    int? points,
    bool? isPrivate,
    DateTime? dueDate,
    String? dueTime,
  }) async {
    try {
      debugPrint("📤 Updating task $taskId...");

      final body = <String, dynamic>{};

      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (priority != null) body['priority'] = priority;
      if (assignedTo != null) {
        body['assignedTo'] = assignedTo.map((m) => m.toJson()).toList();
      }
      // Only include points if it's greater than 0 (API doesn't accept 0)
      if (points != null && points > 0) {
        body['points'] = points;
      }
      if (isPrivate != null) body['isPrivate'] = isPrivate;
      if (dueDate != null) {
        // Format as YYYY-MM-DD
        body['dueDate'] = '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
      }
      if (dueTime != null) {
        if (dueTime.isEmpty) {
          body['dueTime'] = null; // Allow clearing dueTime
        } else {
          body['dueTime'] = dueTime;
        }
      }

      debugPrint("📤 Update request body: ${jsonEncode(body)}");

      final response = await ApiService.put(
        endpoint: '/api/tasks/$taskId',
        body: body,
      );

      debugPrint("📥 Update task response status: ${response.statusCode}");
      debugPrint("📥 Update task response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return TaskModel.fromJson(data);
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to update task');
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
            // Format error messages to be more user-friendly
            final formattedErrors = errors.map((e) {
              String errorStr = e.toString();
              // Remove backticks and make messages more readable
              errorStr = errorStr.replaceAll('`', '');
              // Make specific error messages more user-friendly
              if (errorStr.contains('is not a valid enum value for path `points`')) {
                return 'Points must be greater than 0. Please select a valid points reward.';
              }
              return errorStr;
            }).toList();
            final errorMessage = formattedErrors.isNotEmpty 
                ? formattedErrors.join(', ') 
                : 'Failed to update task';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to update task';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to update task with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in updateTask: $e");
      rethrow;
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      debugPrint("📤 Deleting task $taskId...");

      final response = await ApiService.delete(
        endpoint: '/api/tasks/$taskId',
      );

      debugPrint("📥 Delete task response status: ${response.statusCode}");
      debugPrint("📥 Delete task response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (jsonResponse['success'] == true) {
          debugPrint("✅ Task deleted successfully");
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to delete task');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden. Please check your permissions.');
      } else if (response.statusCode == 404) {
        throw Exception('Task not found.');
      } else {
        try {
          final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
          
          // Handle errors array (for validation errors)
          if (errorResponse.containsKey('errors') && errorResponse['errors'] is List) {
            final errors = errorResponse['errors'] as List;
            final errorMessage = errors.isNotEmpty 
                ? errors.join(', ') 
                : 'Failed to delete task';
            throw Exception(errorMessage);
          }
          
          final errorMessage = errorResponse['message'] ?? 
                              errorResponse['error'] ?? 
                              'Failed to delete task';
          throw Exception(errorMessage);
        } catch (e) {
          if (e is Exception) {
            rethrow;
          }
          throw Exception('Failed to delete task with status ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint("❌ Exception in deleteTask: $e");
      rethrow;
    }
  }
}

