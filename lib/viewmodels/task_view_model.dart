import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskViewModel extends GetxController {
  final TaskService _taskService = TaskService();
  
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  /// Load all tasks from API
  Future<void> loadTasks() async {
    isLoading.value = true;
    error.value = null;

    try {
      final loadedTasks = await _taskService.getTasks();
      tasks.value = loadedTasks;
      debugPrint("✅ Loaded ${loadedTasks.length} tasks");
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error loading tasks: $e");
      Get.snackbar(
        "Error",
        "Failed to load tasks",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new task
  Future<void> createTask({
    required String title,
    required String description,
    required String priority,
    required List<AssignedMember> assignedTo,
    required int points,
    required bool isPrivate,
    DateTime? dueDate,
    String? dueTime,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final newTask = await _taskService.createTask(
        title: title,
        description: description,
        priority: priority,
        assignedTo: assignedTo,
        points: points,
        isPrivate: isPrivate,
        dueDate: dueDate,
        dueTime: dueTime,
      );

      debugPrint("✅ Task created successfully: ${newTask.title}");
      
      // Reload tasks list to include the new task
      await loadTasks();

      Get.snackbar(
        "Success",
        "Task created successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error creating task: $e");
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

  /// Update an existing task
  Future<void> updateTask({
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
    isLoading.value = true;
    error.value = null;

    try {
      final updatedTask = await _taskService.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        priority: priority,
        assignedTo: assignedTo,
        points: points,
        isPrivate: isPrivate,
        dueDate: dueDate,
        dueTime: dueTime,
      );

      debugPrint("✅ Task updated successfully: ${updatedTask.title}");
      
      // Reload tasks list to reflect the update
      await loadTasks();

      Get.snackbar(
        "Success",
        "Task updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error updating task: $e");
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

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    isLoading.value = true;
    error.value = null;

    try {
      await _taskService.deleteTask(taskId);

      debugPrint("✅ Task deleted successfully");
      
      // Reload tasks list to reflect the deletion
      await loadTasks();

      Get.snackbar(
        "Success",
        "Task deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      debugPrint("❌ Error deleting task: $e");
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

  /// Refresh tasks list
  Future<void> refresh() async {
    await loadTasks();
  }

  /// Get tasks grouped by assigned member
  Map<String, List<TaskModel>> getTasksGroupedByMember() {
    final Map<String, List<TaskModel>> grouped = {};
    
    for (var task in tasks) {
      if (task.assignedTo.isEmpty) {
        if (!grouped.containsKey("Unassigned")) {
          grouped["Unassigned"] = [];
        }
        grouped["Unassigned"]!.add(task);
      } else {
        for (var member in task.assignedTo) {
          final key = member.memberId;
          if (!grouped.containsKey(key)) {
            grouped[key] = [];
          }
          grouped[key]!.add(task);
        }
      }
    }
    
    return grouped;
  }
}

