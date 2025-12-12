import 'package:flutter/material.dart';
import 'package:mom_app/views/meals/share_list_dialog.dart'; // ✅ Correct import
import '../../theme/app_colors.dart';
import '../../theme/app_textstyles.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_dropdown.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final List<Map<String, dynamic>> groceryItems = [
    {'name': 'Egg', 'quantity': 2, 'category': 'Dairy', 'completed': false},
    {'name': 'Oil', 'quantity': 1, 'category': 'Pantry', 'completed': true},
  ];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  String? selectedCategory;

  final List<String> categories = [
    'Produce',
    'Meat',
    'Dairy',
    'Pantry',
    'Frozen',
    'Other'
  ];

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _addItem() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter item name')),
      );
      return;
    }

    final quantity = int.tryParse(quantityController.text.trim()) ?? 1;
    final category = selectedCategory ?? 'Uncategorized';

    setState(() {
      groceryItems.add({
        'name': name,
        'quantity': quantity,
        'category': category,
        'completed': false,
      });
      nameController.clear();
      quantityController.clear();
      selectedCategory = null;
    });
  }

  void _toggleItem(int index) {
    setState(() {
      groceryItems[index]['completed'] = !groceryItems[index]['completed'];
    });
  }

  void _deleteItem(int index) {
    setState(() {
      groceryItems.removeAt(index);
    });
  }

  void _showShareDialog() {
    final itemsToShare =
    groceryItems.where((item) => !item['completed']).toList();

    if (itemsToShare.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items to share')),
      );
      return;
    }

    // ✅ Fixed: Only pass itemsToShare
    // showDialog(
    //   context: context,
    //   builder: (context) => ShareListDialog(
    //     itemsToShare: itemsToShare,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final uncompletedItemsCount =
        groceryItems.where((item) => !item['completed']).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.restaurant,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "Meal Planning & Grocery Lists",
                          style: TextStyle(
                            fontFamily: AppTextStyles.pomot,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tabs
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Meal Plans",
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "Grocery List",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Grocery List",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppColors.textDark.withOpacity(0.1),
                            foregroundColor: AppColors.textDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // TODO: Implement "From Meals" functionality
                          },
                          icon: const Icon(Icons.calendar_today_outlined,
                              size: 18),
                          label: const Text("From Meals"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.textDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: AppColors.grey,
                                width: 0.5,
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _showShareDialog,
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text("Share"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Item Name Input
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Item name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quantity, Category, Add Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quantity Input
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Category Dropdown
                        Expanded(
                          flex: 3,
                          child: CustomDropdown<String>(
                            items: categories.toDropdownItems((item) => item),
                            value: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            hintText: 'Category',
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Add Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primary,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _addItem,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Shopping List Title
                    Text(
                      "🛒 Shopping List ($uncompletedItemsCount items)",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Shopping List Items
                    if (groceryItems.isEmpty)
                      const Text(
                        "All items completed!",
                        style: TextStyle(color: AppColors.grey),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: groceryItems.length,
                        itemBuilder: (context, index) {
                          final item = groceryItems[index];
                          final isCompleted = item['completed'];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.grey.withOpacity(0.2),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Checkbox
                                GestureDetector(
                                  onTap: () => _toggleItem(index),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                      color: isCompleted
                                          ? AppColors.primary
                                          : Colors.white,
                                    ),
                                    child: isCompleted
                                        ? const Icon(
                                      Icons.check,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Item Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.pomot,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          decoration: isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                          color: isCompleted
                                              ? AppColors.grey
                                              : AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        '${item['quantity']} ${item['category'] != 'Uncategorized' ? '(${item['category']})' : ''}',
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.pomot,
                                          fontSize: 14,
                                          color: isCompleted
                                              ? AppColors.grey.withOpacity(0.7)
                                              : AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Delete Button
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  onPressed: () => _deleteItem(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}