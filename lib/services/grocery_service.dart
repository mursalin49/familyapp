// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../models/grocery_model.dart';
// import 'api_service.dart';
//
// class GroceryService {
//   static const String _endpoint = '/api/groceries';
//
//   // ===== GET ALL GROCERIES =====
//   Future<List<GroceryItemModel>> getGroceries() async {
//     try {
//       final response = await ApiService.get(endpoint: _endpoint);
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         // ✅ Handle API response structure
//         List<dynamic> data = [];
//
//         if (decoded is Map<String, dynamic>) {
//           if (decoded.containsKey('data') && decoded['data'] is List) {
//             data = decoded['data'];
//           } else if (decoded.containsKey('groceries') &&
//               decoded['groceries'] is List) {
//             data = decoded['groceries'];
//           } else {
//             data = [];
//           }
//         } else if (decoded is List) {
//           data = decoded;
//         }
//
//         debugPrint('✅ Fetched ${data.length} groceries');
//         return data.map((json) => GroceryItemModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load groceries: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error fetching groceries: $e');
//       rethrow;
//     }
//   }
//
//   // ===== ADD NEW GROCERY =====
//   Future<GroceryItemModel> addGrocery(GroceryItemModel item) async {
//     try {
//       final response = await ApiService.post(
//         endpoint: _endpoint,
//         body: item.toJson(),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = jsonDecode(response.body);
//
//         // ✅ Handle API response
//         Map<String, dynamic> itemData;
//
//         if (decoded is Map<String, dynamic>) {
//           if (decoded.containsKey('data') && decoded['data'] is Map) {
//             itemData = decoded['data'];
//           } else {
//             itemData = decoded;
//           }
//         } else {
//           itemData = {};
//         }
//
//         debugPrint('✅ Grocery added: ${itemData['name'] ?? 'Unknown'}');
//         return GroceryItemModel.fromJson(itemData);
//       } else {
//         throw Exception('Failed to add grocery: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error adding grocery: $e');
//       rethrow;
//     }
//   }
//
//   // ===== UPDATE GROCERY =====
//   Future<GroceryItemModel> updateGrocery(
//     String id,
//     GroceryItemModel item,
//   ) async {
//     try {
//       final response = await ApiService.put(
//         endpoint: '$_endpoint/$id',
//         body: item.toJson(),
//       );
//
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//
//         Map<String, dynamic> itemData;
//
//         if (decoded is Map<String, dynamic>) {
//           if (decoded.containsKey('data') && decoded['data'] is Map) {
//             itemData = decoded['data'];
//           } else {
//             itemData = decoded;
//           }
//         } else {
//           itemData = {};
//         }
//
//         debugPrint('✅ Grocery updated: ${itemData['name'] ?? 'Unknown'}');
//         return GroceryItemModel.fromJson(itemData);
//       } else {
//         throw Exception('Failed to update grocery: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error updating grocery: $e');
//       rethrow;
//     }
//   }
//
//   // ===== DELETE GROCERY =====
//   Future<void> deleteGrocery(String id) async {
//     try {
//       final response = await ApiService.delete(endpoint: '$_endpoint/$id');
//
//       if (response.statusCode != 200 && response.statusCode != 204) {
//         throw Exception('Failed to delete grocery: ${response.statusCode}');
//       }
//
//       debugPrint('✅ Grocery deleted: $id');
//     } catch (e) {
//       debugPrint('❌ Error deleting grocery: $e');
//       rethrow;
//     }
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/grocery_model.dart';
import 'api_service.dart';

class GroceryService {
  static const String _endpoint = '/api/groceries';

  // ===== GET ALL GROCERIES =====
  Future<List<GroceryItemModel>> getGroceries() async {
    try {
      final response = await ApiService.get(endpoint: _endpoint);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // 🔍 DEBUG: পুরো API response দেখুন
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        debugPrint('📦 FULL API RESPONSE:');
        debugPrint(response.body);
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        // ✅ Handle API response structure
        List<dynamic> data = [];

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is List) {
            data = decoded['data'];
          } else if (decoded.containsKey('groceries') &&
              decoded['groceries'] is List) {
            data = decoded['groceries'];
          } else {
            data = [];
          }
        } else if (decoded is List) {
          data = decoded;
        }

        // 🔍 DEBUG: প্রতিটা item এর details দেখুন
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        debugPrint('📋 ITEMS FOUND: ${data.length}');
        for (int i = 0; i < data.length; i++) {
          final item = data[i];
          debugPrint('─────────────────────────────────────');
          debugPrint('🔢 Item #${i + 1}:');
          debugPrint('   _id: ${item['_id']}');
          debugPrint('   id: ${item['id']}');
          debugPrint('   name: ${item['name']}');
          debugPrint('   itemName: ${item['itemName']}');
          debugPrint('   quantity: ${item['quantity']}');
          debugPrint('   category: ${item['category']}');
          debugPrint('   completed: ${item['completed']}');
        }
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        final groceryList = data.map((json) => GroceryItemModel.fromJson(json)).toList();

        // 🔍 DEBUG: Parse করার পরে দেখুন
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        debugPrint('✅ PARSED MODELS:');
        for (var grocery in groceryList) {
          debugPrint('   ${grocery.toString()}');
        }
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        return groceryList;
      } else {
        throw Exception('Failed to load groceries: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching groceries: $e');
      rethrow;
    }
  }

  // ===== ADD NEW GROCERY =====
  Future<GroceryItemModel> addGrocery(GroceryItemModel item) async {
    try {
      // 🔍 DEBUG: কী send করছি দেখুন
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📤 ADDING ITEM:');
      debugPrint('   Sending: ${jsonEncode(item.toJson())}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await ApiService.post(
        endpoint: _endpoint,
        body: item.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        // 🔍 DEBUG: Response দেখুন
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        debugPrint('📥 ADD RESPONSE:');
        debugPrint(response.body);
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

        // ✅ Handle API response
        Map<String, dynamic> itemData;

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            itemData = decoded['data'];
          } else {
            itemData = decoded;
          }
        } else {
          itemData = {};
        }

        final addedItem = GroceryItemModel.fromJson(itemData);
        debugPrint('✅ Grocery added: ${addedItem.toString()}');
        return addedItem;
      } else {
        throw Exception('Failed to add grocery: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error adding grocery: $e');
      rethrow;
    }
  }

  // ===== UPDATE GROCERY =====
  Future<GroceryItemModel> updateGrocery(
      String id,
      GroceryItemModel item,
      ) async {
    try {
      final response = await ApiService.put(
        endpoint: '$_endpoint/$id',
        body: item.toJson(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        Map<String, dynamic> itemData;

        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map) {
            itemData = decoded['data'];
          } else {
            itemData = decoded;
          }
        } else {
          itemData = {};
        }

        debugPrint('✅ Grocery updated: ${itemData['itemName'] ?? itemData['name'] ?? 'Unknown'}');
        return GroceryItemModel.fromJson(itemData);
      } else {
        throw Exception('Failed to update grocery: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error updating grocery: $e');
      rethrow;
    }
  }

  // ===== DELETE GROCERY =====
  Future<void> deleteGrocery(String id) async {
    try {
      final response = await ApiService.delete(endpoint: '$_endpoint/$id');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete grocery: ${response.statusCode}');
      }

      debugPrint('✅ Grocery deleted: $id');
    } catch (e) {
      debugPrint('❌ Error deleting grocery: $e');
      rethrow;
    }
  }
}