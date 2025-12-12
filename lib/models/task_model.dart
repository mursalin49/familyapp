import 'package:flutter/material.dart';

class AssignedMember {
  final String memberId;
  final String memberType; // "Child", "Teen", "Parent"
  final String? id; // _id from API response

  AssignedMember({
    required this.memberId,
    required this.memberType,
    this.id,
  });

  factory AssignedMember.fromJson(Map<String, dynamic> json) {
    return AssignedMember(
      memberId: json['memberId'] as String,
      memberType: json['memberType'] as String,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'memberType': memberType,
    };
  }
}

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String priority; // "High", "Medium", "Low"
  final List<AssignedMember> assignedTo;
  final int points;
  final bool isPrivate;
  final DateTime? dueDate;
  final String? dueTime; // "HH:mm" format
  final String status; // "pending", "completed", etc.
  final bool pointsAwarded;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Computed property for backward compatibility
  String get assignedToDisplay {
    if (assignedTo.isEmpty) return "Unassigned";
    return assignedTo.map((m) => m.memberType).join(", ");
  }

  // Computed property for backward compatibility
  bool get isCompleted => status == "completed";

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.assignedTo,
    required this.points,
    required this.isPrivate,
    this.dueDate,
    this.dueTime,
    this.status = "pending",
    this.pointsAwarded = false,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Parse assignedTo array
    final assignedToList = json['assignedTo'] as List<dynamic>? ?? [];
    final assignedMembers = assignedToList
        .map((item) => AssignedMember.fromJson(item as Map<String, dynamic>))
        .toList();

    // Parse dueDate (can be ISO string or null)
    DateTime? dueDate;
    if (json['dueDate'] != null) {
      try {
        dueDate = DateTime.parse(json['dueDate'] as String);
      } catch (e) {
        dueDate = null;
      }
    }

    // Parse createdAt and updatedAt
    DateTime? createdAt;
    if (json['createdAt'] != null) {
      try {
        createdAt = DateTime.parse(json['createdAt'] as String);
      } catch (e) {
        createdAt = null;
      }
    }

    DateTime? updatedAt;
    if (json['updatedAt'] != null) {
      try {
        updatedAt = DateTime.parse(json['updatedAt'] as String);
      } catch (e) {
        updatedAt = null;
      }
    }

    return TaskModel(
      id: json['_id'] as String? ?? json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String,
      assignedTo: assignedMembers,
      points: json['points'] as int? ?? 0,
      isPrivate: json['isPrivate'] as bool? ?? false,
      dueDate: dueDate,
      dueTime: json['dueTime'] as String?,
      status: json['status'] as String? ?? 'pending',
      pointsAwarded: json['pointsAwarded'] as bool? ?? false,
      createdBy: json['createdBy'] as String?,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'assignedTo': assignedTo.map((m) => m.toJson()).toList(),
      'points': points,
      'isPrivate': isPrivate,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String().split('T')[0], // YYYY-MM-DD format
      if (dueTime != null) 'dueTime': dueTime,
    };
  }

  // Sample data (for backward compatibility - not used when API is connected)
  static List<TaskModel> getSampleTasks() {
    return [
      TaskModel(
        id: "101",
        title: "Personal Note",
        description: "Private task",
        priority: "Medium",
        assignedTo: [
          AssignedMember(memberId: "sample1", memberType: "Child"),
        ],
        points: 5,
        isPrivate: true,
        dueDate: DateTime(2025, 10, 19),
        dueTime: "18:47",
        status: "completed",
      ),
      TaskModel(
        id: "102",
        title: "Private Task",
        description: "Confidential",
        priority: "High",
        assignedTo: [
          AssignedMember(memberId: "sample1", memberType: "Child"),
        ],
        points: 10,
        isPrivate: true,
        dueDate: DateTime(2025, 10, 20),
        dueTime: "14:30",
        status: "completed",
      ),
      TaskModel(
        id: "103",
        title: "New Task",
        description: "dddddd",
        priority: "Medium",
        assignedTo: [],
        points: 5,
        isPrivate: true,
        dueDate: DateTime(2025, 10, 21),
        dueTime: "18:47",
      ),
      TaskModel(
        id: "104",
        title: "Neww",
        description: "dddddd",
        priority: "Low",
        assignedTo: [
          AssignedMember(memberId: "sample1", memberType: "Child"),
        ],
        points: 5,
        isPrivate: true,
        dueDate: DateTime(2025, 10, 22),
        dueTime: "14:30",
      ),
      TaskModel(
        id: "105",
        title: "Kitchen Cleanup",
        description: "Clean the kitchen after dinner",
        priority: "High",
        assignedTo: [
          AssignedMember(memberId: "sample2", memberType: "Child"),
        ],
        points: 10,
        isPrivate: false,
        dueDate: DateTime(2025, 10, 20),
        dueTime: "20:00",
        status: "completed",
      ),
      TaskModel(
        id: "106",
        title: "Homework",
        description: "Complete math homework",
        priority: "Medium",
        assignedTo: [
          AssignedMember(memberId: "sample2", memberType: "Child"),
        ],
        points: 15,
        isPrivate: false,
        dueDate: DateTime(2025, 10, 23),
        dueTime: "16:00",
      ),
    ];
  }
}

class TaskGroup {
  final String name;
  final String avatar;
  final List<TaskModel> tasks;
  bool isExpanded;

  TaskGroup({
    required this.name,
    required this.avatar,
    required this.tasks,
    this.isExpanded = false,
  });
}
