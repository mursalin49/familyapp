import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/custom_dropdown.dart';
import 'package:get/get.dart';
import '../../../viewmodels/grocery_view_model.dart';
import '../../../models/grocery_model.dart';
import '../../../viewmodels/meal_view_model.dart';
import '../share_list_dialog.dart';

class GroceryListTab extends StatefulWidget {
  final List<String> groceryCategories;

  const GroceryListTab({super.key, required this.groceryCategories});

  @override
  State<GroceryListTab> createState() => _GroceryListTabState();
}

class _GroceryListTabState extends State<GroceryListTab> {
  final GroceryViewModel _groceryViewModel = Get.find<GroceryViewModel>();
  String? _selectedCategory;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _groceryViewModel.fetchGroceries();
    });
  }

  @override
  void dispose() {
    itemNameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _addItem() {
    // ✅ Step 1: Validate item name
    final name = itemNameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter item name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // ✅ Step 2: Validate quantity (required and > 0)
    final quantityText = quantityController.text.trim();
    if (quantityText.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter quantity",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      Get.snackbar(
        "Error",
        "Quantity must be a number greater than 0",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // ✅ Step 3: Use category or default to 'Uncategorized'
    final category = _selectedCategory ?? 'Uncategorized';

    // ✅ All validations passed - add item
    debugPrint('✅ Adding item: name=$name, qty=$quantity, category=$category');
    _groceryViewModel.addItem(name, quantity, category);

    // ✅ Clear form after successful add
    itemNameController.clear();
    quantityController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  void _showMealsDialog() async {
    final mealViewModel = Get.find<MealViewModel>();
    if (mealViewModel.meals.isEmpty) {
      await mealViewModel.fetchMeals();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Meal to Add Ingredients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (mealViewModel.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (mealViewModel.meals.isEmpty) {
                    return const Center(child: Text("No meals found."));
                  }
                  return ListView.builder(
                    itemCount: mealViewModel.meals.length,
                    itemBuilder: (context, index) {
                      final meal = mealViewModel.meals[index];
                      return ListTile(
                        title: Text(meal.name),
                        subtitle: Text(meal.day),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            if (meal.id != null) {
                              _groceryViewModel.addIngredientsFromMeal(
                                meal.id!,
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog() {
    if (_groceryViewModel.uncompletedItems.isEmpty) {
      Get.snackbar(
        "Info",
        "No items to share",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ShareListDialog(
        itemsToShare: _groceryViewModel.uncompletedItems,
        groceryViewModel: _groceryViewModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: const Color(0xFF757575).withOpacity(0.2),
                    ),
                  ),
                ),
                onPressed: _showMealsDialog,
                icon: const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textDark,
                ),
                label: const Text(
                  "From Meals",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: const Color(0xFF757575).withOpacity(0.2),
                    ),
                  ),
                ),
                onPressed: _showShareDialog,
                icon: const Icon(
                  Icons.share_outlined,
                  size: 16,
                  color: AppColors.textDark,
                ),
                label: const Text(
                  "Share",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Item Name Input
        TextField(
          controller: itemNameController,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: "Item name",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color(0xFF757575).withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color(0xFF757575).withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            hintStyle: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 12),

        // Quantity, Category, Add Button
        Row(
          children: [
            // Quantity Input - ✅ Required field
            Expanded(
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Qty *", // ✅ Required field
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xFF757575).withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xFF757575).withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  hintStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Category Dropdown - ✅ Optional field
            Expanded(
              child: CustomDropdown<String>(
                items: widget.groceryCategories.toDropdownItems((item) => item),
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                hintText: "Category (optional)", // ✅ Now optional
              ),
            ),
            const SizedBox(width: 8),
            // Add Button
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: _addItem,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Shopping List Status
        Obx(
              () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.textDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Shopping List (${_groceryViewModel.uncompletedCount} items)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              if (_groceryViewModel.completedCount > 0)
                TextButton(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Clear Completed Items?"),
                        content: Text(
                          "This will remove ${_groceryViewModel.completedCount} completed items",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              _groceryViewModel.clearCompleted();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Clear",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Grocery List
        Obx(() {
          if (_groceryViewModel.isLoading.value &&
              _groceryViewModel.groceries.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_groceryViewModel.groceries.isEmpty) {
            return Center(
              child: Text(
                "All items completed!",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _groceryViewModel.groceries.length,
            itemBuilder: (context, index) {
              final item = _groceryViewModel.groceries[index];
              return Dismissible(
                key: Key(item.id ?? item.name + index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  _groceryViewModel.deleteItem(item);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      // Checkbox
                      GestureDetector(
                        onTap: () => _groceryViewModel.toggleItem(item),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            color: item.completed
                                ? AppColors.primary
                                : Colors.white,
                          ),
                          child: item.completed
                              ? const Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Item Name & Quantity (Vertical)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Name
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: item.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.completed
                                    ? Colors.grey
                                    : AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Quantity only
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Category (Right side, before delete icon)
                      if (item.category != 'Uncategorized')
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                      // Delete Icon (With Confirmation)
                      GestureDetector(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text("Delete Item?"),
                              content: Text(
                                "Are you sure you want to delete '${item.name}'?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _groceryViewModel.deleteItem(item);
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red[300],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}