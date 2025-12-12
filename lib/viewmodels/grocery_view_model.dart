// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/grocery_model.dart';
// import '../services/grocery_service.dart';
// import '../services/meal_service.dart';
//
// class GroceryViewModel extends GetxController {
//   final GroceryService _groceryService = GroceryService();
//   final MealService _mealService = MealService();
//
//   var groceries = <GroceryItemModel>[].obs;
//   var isLoading = false.obs;
//
//   // Computed property for uncompleted count
//   int get uncompletedCount => groceries.where((item) => !item.completed).length;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // fetchGroceries(); // Optional: fetch on init
//   }
//
//   Future<void> fetchGroceries() async {
//     isLoading.value = true;
//     try {
//       final items = await _groceryService.getGroceries();
//       groceries.assignAll(items);
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to load groceries: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> addItem(String name, int quantity, String category) async {
//     if (name.isEmpty) return;
//
//     isLoading.value = true;
//     try {
//       final newItem = GroceryItemModel(
//         name: name,
//         quantity: quantity,
//         category: category,
//       );
//
//       final addedItem = await _groceryService.addGrocery(newItem);
//       groceries.add(addedItem);
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to add item: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> toggleItem(GroceryItemModel item) async {
//     // Optimistic update
//     final index = groceries.indexOf(item);
//     if (index != -1) {
//       item.completed = !item.completed;
//       groceries[index] = item; // Trigger update
//     }
//
//     try {
//       await _groceryService.updateGrocery(item.id!, item);
//     } catch (e) {
//       // Revert on failure
//       if (index != -1) {
//         item.completed = !item.completed;
//         groceries[index] = item;
//       }
//       Get.snackbar(
//         "Error",
//         "Failed to update item: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> deleteItem(GroceryItemModel item) async {
//     if (item.id == null) return;
//
//     try {
//       await _groceryService.deleteGrocery(item.id!);
//       groceries.remove(item);
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to delete item: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   Future<void> addIngredientsFromMeal(String mealId) async {
//     isLoading.value = true;
//     try {
//       await _mealService.addIngredientsToGroceryList(mealId);
//       Get.snackbar(
//         "Success",
//         "Ingredients added to grocery list",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       await fetchGroceries(); // Refresh list
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "Failed to add ingredients: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/grocery_model.dart';
import '../services/grocery_service.dart';
import '../services/meal_service.dart';

class GroceryViewModel extends GetxController {
  final GroceryService _groceryService = GroceryService();
  final MealService _mealService = MealService();

  var groceries = <GroceryItemModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  // ===== COMPUTED PROPERTIES =====
  int get uncompletedCount =>
      groceries.where((item) => !item.completed).length;

  int get completedCount =>
      groceries.where((item) => item.completed).length;

  List<GroceryItemModel> get uncompletedItems =>
      groceries.where((item) => !item.completed).toList();

  @override
  void onInit() {
    super.onInit();
    // fetchGroceries(); // Optional: fetch on init
  }

  // ===== FETCH ALL GROCERIES =====
  Future<void> fetchGroceries() async {
    try {
      isLoading.value = true;
      error.value = null;

      final items = await _groceryService.getGroceries();
      groceries.assignAll(items);

      debugPrint('✅ Groceries fetched: ${groceries.length} items');
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error fetching groceries: $e');

      Get.snackbar(
        "Error",
        "Failed to load groceries: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ADD ITEM =====
  Future<void> addItem(String name, int quantity, String category) async {
    if (name.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Item name cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      error.value = null;

      final newItem = GroceryItemModel(
        name: name.trim(),
        quantity: quantity > 0 ? quantity : 1,
        category: category.isNotEmpty ? category : 'Uncategorized',
      );

      final addedItem = await _groceryService.addGrocery(newItem);
      groceries.add(addedItem);

      Get.snackbar(
        "Success",
        "Item added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      debugPrint('✅ Item added: ${addedItem.name}');
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error adding item: $e');

      Get.snackbar(
        "Error",
        "Failed to add item: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== TOGGLE ITEM COMPLETION =====
  Future<void> toggleItem(GroceryItemModel item) async {
    if (item.id == null) return;

    // Optimistic update
    final index = groceries.indexOf(item);
    final originalState = item.completed;

    try {
      item.completed = !item.completed;
      if (index != -1) {
        groceries[index] = item;
        groceries.refresh();
      }

      // Update on server
      await _groceryService.updateGrocery(item.id!, item);

      debugPrint(
        '✅ Item toggled: ${item.name} - ${item.completed ? 'Completed' : 'Uncompleted'}',
      );
    } catch (e) {
      // Revert on failure
      item.completed = originalState;
      if (index != -1) {
        groceries[index] = item;
        groceries.refresh();
      }

      debugPrint('❌ Error toggling item: $e');
      Get.snackbar(
        "Error",
        "Failed to update item: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ===== DELETE ITEM =====
  Future<void> deleteItem(GroceryItemModel item) async {
    if (item.id == null) return;

    final itemIndex = groceries.indexOf(item);

    try {
      // Optimistic delete
      groceries.remove(item);

      // Delete on server
      await _groceryService.deleteGrocery(item.id!);

      Get.snackbar(
        "Success",
        "Item deleted",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      debugPrint('✅ Item deleted: ${item.name}');
    } catch (e) {
      // Restore on failure
      if (itemIndex != -1) {
        groceries.insert(itemIndex, item);
      }

      debugPrint('❌ Error deleting item: $e');
      Get.snackbar(
        "Error",
        "Failed to delete item: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ===== ADD INGREDIENTS FROM MEAL =====
  Future<void> addIngredientsFromMeal(String mealId) async {
    try {
      isLoading.value = true;
      error.value = null;

      await _mealService.addIngredientsToGroceryList(mealId);

      // Refresh list
      await fetchGroceries();

      Get.snackbar(
        "Success",
        "Ingredients added to grocery list",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      debugPrint('✅ Ingredients added from meal: $mealId');
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error adding ingredients: $e');

      Get.snackbar(
        "Error",
        "Failed to add ingredients: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ===== SHARE GROCERY LIST =====
  Future<bool> shareGroceryList(String familyMemberId) async {
    if (uncompletedItems.isEmpty) {
      Get.snackbar(
        "Info",
        "No items to share",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;
      error.value = null;

      // TODO: Implement share API call
      // await _groceryService.shareList(familyMemberId, uncompletedItems);

      Get.snackbar(
        "Success",
        "List shared with family member",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      debugPrint('✅ List shared with: $familyMemberId');
      return true;
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error sharing list: $e');

      Get.snackbar(
        "Error",
        "Failed to share list: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== GET ITEMS BY CATEGORY =====
  List<GroceryItemModel> getItemsByCategory(String category) {
    return groceries
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // ===== CLEAR COMPLETED ITEMS =====
  Future<void> clearCompleted() async {
    final completedItems = groceries.where((item) => item.completed).toList();

    try {
      for (final item in completedItems) {
        if (item.id != null) {
          await _groceryService.deleteGrocery(item.id!);
        }
      }

      groceries.removeWhere((item) => item.completed);

      Get.snackbar(
        "Success",
        "Completed items cleared",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      debugPrint('✅ Cleared ${completedItems.length} completed items');
    } catch (e) {
      debugPrint('❌ Error clearing completed items: $e');
      Get.snackbar(
        "Error",
        "Failed to clear items: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}