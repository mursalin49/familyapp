
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../models/meal_model.dart';

class MealPlansTab extends StatelessWidget {
  final List<String> days;
  final List<String> mealTypes;
  final List<MealModel> meals;
  final Function(String id) onDeleteMeal;
  final void Function() onShowAddMealDialog;

  const MealPlansTab({
    super.key,
    required this.days,
    required this.mealTypes,
    required this.meals,
    required this.onDeleteMeal,
    required this.onShowAddMealDialog,
  });

  List<Widget> _buildIngredientList(List<String>? ingredients) {
    //  null check
    if (ingredients == null || ingredients.isEmpty) {
      return [const SizedBox.shrink()];
    }

    return [
      const SizedBox(height: 8),
      ...ingredients
          .map(
            (item) => Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
          child: Text(
            '• $item',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ),
      )
          .toList(),
      const SizedBox(height: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Add Meal Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Weekly Meal Plan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onShowAddMealDialog(),
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                "Add Meal",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Days Column
        Column(
          children: days.map((day) {
            // Filter meals for this day
            final dayMeals = meals
                .where((m) => m.day.toLowerCase() == day.toLowerCase())
                .toList();

            return DayCard(
              day: day,
              meals: dayMeals,
              onDeleteMeal: onDeleteMeal,
              buildIngredientList: _buildIngredientList,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class DayCard extends StatelessWidget {
  final String day;
  final List<MealModel> meals;
  final Function(String id) onDeleteMeal;
  final Function(List<String>?) buildIngredientList;

  const DayCard({
    super.key,
    required this.day,
    required this.meals,
    required this.onDeleteMeal,
    required this.buildIngredientList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Name Header
          Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Meals List or Empty State
          if (meals.isEmpty)
            const Center(
              child: Text(
                "No meals planned",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return MealItemCard(
                  meal: meal,
                  onDelete: () {
                    if (meal.id != null) {
                      onDeleteMeal(meal.id!);
                    }
                  },
                  buildIngredientList: buildIngredientList,
                );
              },
            ),
        ],
      ),
    );
  }
}

class MealItemCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onDelete;
  final Function(List<String>?) buildIngredientList;

  const MealItemCard({
    super.key,
    required this.meal,
    required this.onDelete,
    required this.buildIngredientList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Meal Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    meal.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                // Delete Button
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Meal Name
            Text(
              meal.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            //  Ingredients List - null safe
            if (meal.ingredients != null && meal.ingredients!.isNotEmpty)
              ...buildIngredientList(meal.ingredients),

            //  Notes - null check
            if (meal.notes != null && meal.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Note: ${meal.notes}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}