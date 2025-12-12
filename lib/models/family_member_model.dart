class FamilyMemberModel {
  final String id;
  final String role; // "parent" or "child"
  
  // Parent fields
  final String? firstname;
  final String? lastname;
  final String? email;
  
  // Child fields
  final String? name;
  final String? colorCode;
  
  FamilyMemberModel({
    required this.id,
    required this.role,
    this.firstname,
    this.lastname,
    this.email,
    this.name,
    this.colorCode,
  });
  
  // Get display name
  String get displayName {
    if (role == 'parent') {
      if (firstname != null && lastname != null) {
        return '$firstname $lastname';
      }
      return email ?? 'Unknown';
    } else {
      return name ?? 'Unknown';
    }
  }
  
  // Get first letter for avatar
  String get avatarLetter {
    if (role == 'parent') {
      return firstname?.isNotEmpty == true 
          ? firstname![0].toUpperCase()
          : (lastname?.isNotEmpty == true 
              ? lastname![0].toUpperCase() 
              : '?');
    } else {
      return name?.isNotEmpty == true 
          ? name![0].toUpperCase() 
          : '?';
    }
  }
  
  // Check if member is a teen (child with specific role or age)
  bool get isTeen {
    // You can add logic here to determine if child is a teen
    // For now, we'll assume all children can be teens
    return role == 'child';
  }
  
  // Get color for avatar
  String get avatarColor {
    if (colorCode != null) {
      return colorCode!;
    }
    // Default colors based on role
    return role == 'parent' ? '#EC4899' : '#FFC0CB';
  }
  
  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    return FamilyMemberModel(
      id: json['_id'] as String? ?? json['id'] as String,
      role: json['role'] as String,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      colorCode: json['colorCode'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    if (role == 'parent') {
      return {
        '_id': id,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'role': role,
      };
    } else {
      return {
        '_id': id,
        'name': name,
        'role': role,
        'colorCode': colorCode,
      };
    }
  }
}

