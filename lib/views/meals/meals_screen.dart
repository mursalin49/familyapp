import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../widgets/app_header.dart';
import 'widgets/meals_header.dart';
import 'widgets/meal_plans_tab.dart';
import 'widgets/grocery_list_tab.dart';
import 'add_meal_modal.dart';
import 'package:get/get.dart';
import '../../viewmodels/meal_view_model.dart';

class MealsTabControllerX extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  final List<String> groceryCategories = [
    'Produce',
    'Meat',
    'Dairy',
    'Pantry',
    'Frozen',
    'Other',
  ];

  late MealsTabControllerX controller;
  late MealViewModel _mealViewModel;

  final List<String> tabs = ["Meal Plans", "Grocery List"];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    controller = Get.put(MealsTabControllerX());
    _mealViewModel = Get.find<MealViewModel>();

    // Fetch meals when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mealViewModel.fetchMeals();
    });
  }

  @override
  void dispose() {
    // Don't dispose Get controllers here, they manage themselves
    super.dispose();
  }

  void _deleteMeal(String id) {
    _mealViewModel.deleteMeal(id);
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AddMealModal(days: days, mealTypes: mealTypes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF757575).withOpacity(0.2),
                    width: 1,
                  ),
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
                    const MealsHeader(),
                    const SizedBox(height: 20),

                    // Tabs
                    _buildTabs(),

                    const SizedBox(height: 24),

                    // Content with Obx for reactive updates
                    Obx(() {
                      if (controller.selectedIndex.value == 0) {
                        return MealPlansTab(
                          days: days,
                          mealTypes: mealTypes,
                          meals: _mealViewModel.meals.value,
                          onDeleteMeal: _deleteMeal,
                          onShowAddMealDialog: _showAddMealDialog,
                        );
                      } else {
                        return GroceryListTab(
                          groceryCategories: groceryCategories,
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF1F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF757575).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
            () => Row(
          children: List.generate(tabs.length, (index) {
            final bool isSelected = controller.selectedIndex.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : const Color(0xFFEDF1F7),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                        : [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Prompt_regular',
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.textColor
                              : const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}