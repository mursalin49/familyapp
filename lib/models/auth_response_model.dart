import 'parent_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: AuthData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AuthData {
  final ParentModel parent;
  final String token;

  AuthData({
    required this.parent,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      parent: ParentModel.fromJson(json['parent'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent': parent.toJson(),
      'token': token,
    };
  }
}

