import 'parent_model.dart';

class UserModel {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? familyname;
  final String? email;
  final String? role;

  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.familyname,
    this.email,
    this.role,
  });

  factory UserModel.fromParentModel(ParentModel parent) {
    return UserModel(
      id: parent.id,
      firstname: parent.firstname,
      lastname: parent.lastname,
      familyname: parent.familyname,
      email: parent.email,
      role: parent.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      firstname: json['firstname'],
      lastname: json['lastname'],
      familyname: json['familyname'],
      email: json['email'],
      role: json['role'],
    );
  }

  String get fullName => '$firstname $lastname';
}
