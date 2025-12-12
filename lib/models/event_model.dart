class EventModel {
  final String id;
  final String title;
  final String description;
  final String? location;
  final bool allDayEvent;
  final DateTime startDate;
  final String? startTime; // "HH:mm" format
  final DateTime? endDate;
  final String? endTime; // "HH:mm" format
  final String visibility; // "private", "shared"
  final List<String> assignedTo; // Array of user IDs
  final bool assignedToAll;
  final CreatedBy? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.location,
    required this.allDayEvent,
    required this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    required this.visibility,
    required this.assignedTo,
    required this.assignedToAll,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Parse startDate
    DateTime startDate;
    if (json['startDate'] != null) {
      try {
        startDate = DateTime.parse(json['startDate'] as String);
      } catch (e) {
        startDate = DateTime.now();
      }
    } else {
      startDate = DateTime.now();
    }

    // Parse endDate
    DateTime? endDate;
    if (json['endDate'] != null) {
      try {
        endDate = DateTime.parse(json['endDate'] as String);
      } catch (e) {
        endDate = null;
      }
    }

    // Parse assignedTo - can be string, array of strings, or array of user objects
    List<String> assignedTo = [];
    if (json['assignedTo'] != null) {
      if (json['assignedTo'] is List) {
        final assignedToList = json['assignedTo'] as List;
        if (assignedToList.isNotEmpty) {
          // Check if it's an array of objects (user objects) or strings (user IDs)
          if (assignedToList.first is Map) {
            // Array of user objects - extract _id from each
            assignedTo = assignedToList
                .map((e) => (e as Map<String, dynamic>)['_id'] as String? ?? '')
                .where((id) => id.isNotEmpty)
                .toList();
          } else {
            // Array of strings (user IDs)
            assignedTo = assignedToList.map((e) => e.toString()).toList();
          }
        }
      } else if (json['assignedTo'] is String) {
        assignedTo = [json['assignedTo'] as String];
      }
    }

    // Parse createdBy
    CreatedBy? createdBy;
    if (json['createdBy'] != null && json['createdBy'] is Map) {
      createdBy = CreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>);
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

    return EventModel(
      id: json['_id'] as String? ?? json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      location: json['location'] as String?,
      allDayEvent: json['allDayEvent'] as bool? ?? false,
      startDate: startDate,
      startTime: json['startTime'] as String?,
      endDate: endDate,
      endTime: json['endTime'] as String?,
      visibility: json['visibility'] as String? ?? 'shared',
      assignedTo: assignedTo,
      assignedToAll: json['assignedToAll'] as bool? ?? false,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      if (location != null) 'location': location,
      'allDayEvent': allDayEvent,
      'startDate': '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
      if (startTime != null) 'startTime': startTime,
      if (endDate != null) 'endDate': '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}',
      if (endTime != null) 'endTime': endTime,
      'visibility': visibility,
      if (assignedTo.isNotEmpty) 'assignedTo': assignedTo.length == 1 ? assignedTo.first : assignedTo,
      'assignedToAll': assignedToAll,
    };
  }
}

class CreatedBy {
  final String id;
  final String? firstname;
  final String? lastname;
  final String? email;

  CreatedBy({
    required this.id,
    this.firstname,
    this.lastname,
    this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json['_id'] as String? ?? json['id'] as String,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
    );
  }
}

