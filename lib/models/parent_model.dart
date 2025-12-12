class ParentModel {
  final String id;
  final String firstname;
  final String lastname;
  final String familyname;
  final String email;
  final String role;
  final String? createdAt;

  ParentModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.familyname,
    required this.email,
    required this.role,
    this.createdAt,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      familyname: json['familyname'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'familyname': familyname,
      'email': email,
      'role': role,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}

