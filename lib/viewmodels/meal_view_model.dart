// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/meal_model.dart';
// import '../services/meal_service.dart';
//
// class MealViewModel extends GetxController {
//   final MealService _mealService = MealService();
//
//   var meals = <MealModel>[].obs;
//   var isLoading = false.obs;
//   var error = Rxn<String>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // fetchMeals(); // Optional: Fetch on init
//   }
//
//   Future<void> fetchMeals() async {
//     isLoading.value = true;
//     error.value = null;
//
//     try {
//       final fetchedMeals = await _mealService.getMeals();
//       meals.assignAll(fetchedMeals);
//     } catch (e) {
//       error.value = e.toString();
//       debugPrint("Error fetching meals: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> addMeal(MealModel meal) async {
//     isLoading.value = true;
//     error.value = null;
//
//     try {
//       final newMeal = await _mealService.addMeal(meal);
//       // Refresh list to ensure data consistency
//       await fetchMeals();
//       Get.snackbar(
//         "Success",
//         "Meal added successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       return true;
//     } catch (e) {
//       error.value = e.toString();
//       debugPrint("Error adding meal: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to add meal: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> deleteMeal(String id) async {
//     try {
//       await _mealService.deleteMeal(id);
//       await fetchMeals(); // Refresh list
//       return true;
//     } catch (e) {
//       error.value = e.toString();
//       debugPrint("Error deleting meal: $e");
//       Get.snackbar(
//         "Error",
//         "Failed to delete meal: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/meal_model.dart';
import '../services/meal_service.dart';

class MealViewModel extends GetxController {
  final MealService _mealService = MealService();

  var meals = <MealModel>[].obs;
  var isLoading = false.obs;
  var error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // Optionally fetch meals on init
    // fetchMeals();
  }

  // ===== FETCH ALL MEALS =====
  Future<void> fetchMeals() async {
    try {
      isLoading.value = true;
      error.value = null;

      final fetchedMeals = await _mealService.getMeals();
      meals.assignAll(fetchedMeals);

      debugPrint('✅ Meals fetched: ${meals.length} items');
    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error fetching meals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ADD NEW MEAL =====
  Future<bool> addMeal(MealModel meal) async {
    try {
      isLoading.value = true;
      error.value = null;

      final newMeal = await _mealService.addMeal(meal);

      // Add to local list (don't refetch, just add)
      meals.add(newMeal);

      Get.snackbar(
        "Success",
        "Meal added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      debugPrint('✅ Meal added: ${newMeal.name}');
      return true;

    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error adding meal: $e');

      Get.snackbar(
        "Error",
        "Failed to add meal: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== DELETE MEAL =====
  Future<bool> deleteMeal(String id) async {
    try {
      isLoading.value = true;
      error.value = null;

      await _mealService.deleteMeal(id);

      // Remove from local list
      meals.removeWhere((meal) => meal.id == id);

      Get.snackbar(
        "Success",
        "Meal deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      debugPrint('✅ Meal deleted: $id');
      return true;

    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error deleting meal: $e');

      Get.snackbar(
        "Error",
        "Failed to delete meal: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== UPDATE MEAL =====
  Future<bool> updateMeal(String id, MealModel meal) async {
    try {
      isLoading.value = true;
      error.value = null;

      final updatedMeal = await _mealService.updateMeal(id, meal);

      // Update local list
      final index = meals.indexWhere((m) => m.id == id);
      if (index != -1) {
        meals[index] = updatedMeal;
        meals.refresh();
      }

      Get.snackbar(
        "Success",
        "Meal updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      debugPrint('✅ Meal updated: ${updatedMeal.name}');
      return true;

    } catch (e) {
      error.value = e.toString();
      debugPrint('❌ Error updating meal: $e');

      Get.snackbar(
        "Error",
        "Failed to update meal: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ===== GET MEALS BY DAY =====
  List<MealModel> getMealsByDay(String day) {
    return meals
        .where((meal) => meal.day.toLowerCase() == day.toLowerCase())
        .toList();
  }

  // ===== GET MEALS BY TYPE =====
  List<MealModel> getMealsByType(String type) {
    return meals
        .where((meal) => meal.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  // ===== ADD MEAL TO GROCERY LIST =====
  Future<bool> addToGroceryList(String mealId) async {
    try {
      await _mealService.addIngredientsToGroceryList(mealId);

      Get.snackbar(
        "Success",
        "Ingredients added to grocery list",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      debugPrint('✅ Ingredients added to grocery list: $mealId');
      return true;

    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add ingredients: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      debugPrint('❌ Error adding to grocery list: $e');
      return false;
    }
  }

  // ===== CLEAR ALL MEALS =====
  void clearMeals() {
    meals.clear();
    error.value = null;
    debugPrint('🗑️ Meals cleared');
  }
}