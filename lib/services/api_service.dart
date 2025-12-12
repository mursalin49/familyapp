import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  //static const String baseURL = 'https://twenty-bottles-say.loca.lt';
  static const String baseURL = 'https://tjt-walton-mom-backend.onrender.com';

  /// Get default headers with authentication token
  static Future<Map<String, String>> _getDefaultHeaders({
    Map<String, String>? additionalHeaders,
  }) async {
    final token = await StorageService.getToken();

    if (token != null) {
      debugPrint("   Token length: ${token.length}");
      debugPrint(
        "   Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...",
      );
    } else {}

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    if (token != null) {
      debugPrint(
        "   Authorization: Bearer ${token.substring(0, token.length > 30 ? 30 : token.length)}...",
      );
    }

    return headers;
  }

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      return response;
    } catch (e, stackTrace) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final response = await http.get(url, headers: defaultHeaders);
      return response;
    } catch (e, stackTrace) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      final response = await http.put(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      return response;
    } catch (e, stackTrace) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final requestBody = jsonEncode(body);

      final response = await http.patch(
        url,
        headers: defaultHeaders,
        body: requestBody,
      );

      return response;
    } catch (e, stackTrace) {
      throw Exception('Network error: $e');
    }
  }

  static Future<http.Response> delete({
    required String endpoint,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseURL$endpoint');

    final defaultHeaders = requireAuth
        ? await _getDefaultHeaders(additionalHeaders: headers)
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (headers != null) ...headers,
          };

    try {
      final response = await http.delete(url, headers: defaultHeaders);

      return response;
    } catch (e, stackTrace) {
      throw Exception('Network error: $e');
    }
  }
}
