// import 'dart:convert';
// import '../models/meal_model.dart';
// import 'api_service.dart';
//
// class MealService {
//   static const String _endpoint = '/api/meals';
//
//   Future<List<MealModel>> getMeals() async {
//     try {
//       final response = await ApiService.get(endpoint: _endpoint);
//
//       if (response.statusCode == 200) {
//         final dynamic decoded = jsonDecode(response.body);
//         List<dynamic> data;
//
//         if (decoded is Map<String, dynamic>) {
//           if (decoded.containsKey('data') && decoded['data'] is List) {
//             data = decoded['data'];
//           } else if (decoded.containsKey('meals') && decoded['meals'] is List) {
//             data = decoded['meals'];
//           } else {
//             // Fallback or empty if structure unknown but success
//             data = [];
//           }
//         } else if (decoded is List) {
//           data = decoded;
//         } else {
//           data = [];
//         }
//
//         return data.map((json) => MealModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load meals: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching meals: $e');
//     }
//   }
//
//   Future<MealModel> addMeal(MealModel meal) async {
//     try {
//       final response = await ApiService.post(
//         endpoint: _endpoint,
//         body: meal.toJson(),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final dynamic decoded = jsonDecode(response.body);
//         Map<String, dynamic> mealData;
//
//         if (decoded.containsKey('data') && decoded['data'] is Map) {
//           mealData = decoded['data'];
//         } else if (decoded.containsKey('meal') && decoded['meal'] is Map) {
//           mealData = decoded['meal'];
//         } else {
//           mealData = decoded;
//         }
//
//         return MealModel.fromJson(mealData);
//       } else {
//         throw Exception(
//           'Failed to add meal: ${response.statusCode} ${response.body}',
//         );
//       }
//     } catch (e) {
//       throw Exception('Error adding meal: $e');
//     }
//   }
//
//   Future<MealModel> updateMeal(String id, MealModel meal) async {
//     try {
//       final response = await ApiService.put(
//         endpoint: '$_endpoint/$id',
//         body: meal.toJson(),
//       );
//
//       if (response.statusCode == 200) {
//         final dynamic decoded = jsonDecode(response.body);
//         Map<String, dynamic> mealData;
//
//         if (decoded.containsKey('data') && decoded['data'] is Map) {
//           mealData = decoded['data'];
//         } else if (decoded.containsKey('meal') && decoded['meal'] is Map) {
//           mealData = decoded['meal'];
//         } else {
//           mealData = decoded;
//         }
//
//         return MealModel.fromJson(mealData);
//       } else {
//         throw Exception('Failed to update meal: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error updating meal: $e');
//     }
//   }
//
//   Future<void> deleteMeal(String id) async {
//     try {
//       final response = await ApiService.delete(endpoint: '$_endpoint/$id');
//
//       if (response.statusCode != 200 && response.statusCode != 204) {
//         throw Exception('Failed to delete meal: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error deleting meal: $e');
//     }
//   }
//
//   Future<void> addIngredientsToGroceryList(String mealId) async {
//     try {
//       final response = await ApiService.post(
//         endpoint: '$_endpoint/$mealId/add-to-grocery-list',
//         body: {},
//       );
//
//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception(
//           'Failed to add ingredients: ${response.statusCode} ${response.body}',
//         );
//       }
//     } catch (e) {
//       throw Exception('Error adding ingredients to grocery list: $e');
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import 'api_service.dart';

class MealService {
  static const String _endpoint = '/api/meals';

  // ===== GET ALL MEALS =====
  Future<List<MealModel>> getMeals() async {
    try {
      final response = await ApiService.get(endpoint: _endpoint);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> data = _extractListFromResponse(decoded);

        return data.map((json) => MealModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load meals: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error fetching meals: $e');
      rethrow;
    }
  }

  // ===== ADD NEW MEAL =====
  Future<MealModel> addMeal(MealModel meal) async {
    try {
      final response = await ApiService.post(
        endpoint: _endpoint,
        body: meal.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = jsonDecode(response.body);
        final mealData = _extractMapFromResponse(decoded);

        return MealModel.fromJson(mealData);
      } else {
        throw Exception(
          'Failed to add meal: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error adding meal: $e');
      rethrow;
    }
  }

  // ===== UPDATE MEAL =====
  Future<MealModel> updateMeal(String id, MealModel meal) async {
    try {
      final response = await ApiService.put(
        endpoint: '$_endpoint/$id',
        body: meal.toJson(),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final mealData = _extractMapFromResponse(decoded);

        return MealModel.fromJson(mealData);
      } else {
        throw Exception(
          'Failed to update meal: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error updating meal: $e');
      rethrow;
    }
  }

  // ===== DELETE MEAL =====
  Future<void> deleteMeal(String id) async {
    try {
      final response = await ApiService.delete(endpoint: '$_endpoint/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete meal: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error deleting meal: $e');
      rethrow;
    }
  }

  // ===== ADD TO GROCERY LIST =====
  Future<void> addIngredientsToGroceryList(String mealId) async {
    try {
      final response = await ApiService.post(
        endpoint: '$_endpoint/$mealId/add-to-grocery-list',
        body: {},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Failed to add ingredients: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error adding to grocery list: $e');
      rethrow;
    }
  }

  // ===== HELPER: Extract List from Response =====
  List<dynamic> _extractListFromResponse(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data') && decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      } else if (decoded.containsKey('meals') && decoded['meals'] is List) {
        return decoded['meals'] as List<dynamic>;
      }
      return [];
    } else if (decoded is List) {
      return decoded;
    }
    return [];
  }

  // ===== HELPER: Extract Map from Response =====
  Map<String, dynamic> _extractMapFromResponse(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('data') && decoded['data'] is Map) {
        return decoded['data'] as Map<String, dynamic>;
      } else if (decoded.containsKey('meal') && decoded['meal'] is Map) {
        return decoded['meal'] as Map<String, dynamic>;
      }
      return decoded;
    }
    return {};
  }
}