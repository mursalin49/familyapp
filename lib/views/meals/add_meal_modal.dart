// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../utils/app_colors.dart';
// import '../../theme/app_textstyles.dart';
// import '../widgets/custom_dropdown.dart';
// import 'package:mom_app/viewmodels/meal_view_model.dart';
// import '../../models/meal_model.dart';
// import 'package:get/get.dart';
//
// class AddMealModal extends StatefulWidget {
//   final List<String> days;
//   final List<String> mealTypes;
//
//   const AddMealModal({super.key, required this.days, required this.mealTypes});
//
//   @override
//   State<AddMealModal> createState() => _AddMealModalState();
// }
//
// class _AddMealModalState extends State<AddMealModal> {
//   late TextEditingController _mealNameController;
//   late TextEditingController _ingredientsController;
//   late TextEditingController _notesController;
//
//   String? _selectedDay;
//   String? _selectedMealType;
//
//   @override
//   void initState() {
//     super.initState();
//     _mealNameController = TextEditingController();
//     _ingredientsController = TextEditingController();
//     _notesController = TextEditingController();
//     _selectedMealType = widget.mealTypes.isNotEmpty
//         ? widget.mealTypes.first
//         : null;
//   }
//
//   @override
//   void dispose() {
//     _mealNameController.dispose();
//     _ingredientsController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         width: double.infinity,
//         margin: EdgeInsets.symmetric(),
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF000000).withOpacity(0.1),
//               offset: const Offset(0, 4),
//               blurRadius: 20,
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.9,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header
//               Padding(
//                 padding: EdgeInsets.all(20.w),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Add Meal",
//                         style: TextStyle(
//                           fontFamily: 'Prompt_Bold',
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textColor,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.of(context).pop(),
//                       child: Icon(
//                         Icons.close,
//                         color: AppColors.subHeadingColor,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Content
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Select Day Dropdown
//                       _buildDropdownField(
//                         label: "Select day",
//                         value: _selectedDay,
//                         items: widget.days,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedDay = value;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 16.h),
//
//                       // Meal Type Dropdown
//                       _buildDropdownField(
//                         label: "Meal type",
//                         value: _selectedMealType,
//                         items: widget.mealTypes,
//                         onChanged: (value) {
//                           setState(() {
//                             _selectedMealType = value;
//                           });
//                         },
//                       ),
//                       SizedBox(height: 16.h),
//
//                       // Meal Name
//                       _buildTextField(
//                         controller: _mealNameController,
//                         label: "Meal name",
//                         hint: "Meal name",
//                       ),
//                       SizedBox(height: 16.h),
//
//                       // Ingredients
//                       _buildTextField(
//                         controller: _ingredientsController,
//                         label: "Ingredients (comma separated)",
//                         hint: "Ingredients (comma separated)",
//                         maxLines: 3,
//                       ),
//                       SizedBox(height: 16.h),
//
//                       // Notes
//                       _buildTextField(
//                         controller: _notesController,
//                         label: "Notes (optional)",
//                         hint: "Notes (optional)",
//                         maxLines: 4,
//                       ),
//                       SizedBox(height: 24.h),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Add Meal Button
//               Padding(
//                 padding: EdgeInsets.all(20.w),
//                 child: SizedBox(
//                   child: Obx(() {
//                     final mealViewModel = Get.find<MealViewModel>();
//                     return ElevatedButton(
//                       onPressed: mealViewModel.isLoading.value
//                           ? null
//                           : _addMeal,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                       ),
//                       child: mealViewModel.isLoading.value
//                           ? SizedBox(
//                               height: 20.h,
//                               width: 20.h,
//                               child: const CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : Text(
//                               "Add Meal",
//                               style: TextStyle(
//                                 fontFamily: 'Prompt_regular',
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdownField({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: 'Prompt_regular',
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textColor,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         CustomDropdown<String>(
//           items: items.toDropdownItems((item) => item),
//           value: value,
//           onChanged: (newValue) {
//             setState(() {
//               onChanged(newValue);
//             });
//           },
//           hintText: label,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: 'Prompt_regular',
//             fontSize: 12.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textColor,
//           ),
//         ),
//         SizedBox(height: 6.h),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide(color: AppColors.primary),
//             ),
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 12.w,
//               vertical: 10.h,
//             ),
//             hintStyle: TextStyle(
//               fontFamily: 'Prompt_regular',
//               fontSize: 13.sp,
//               color: AppColors.subHeadingColor,
//             ),
//           ),
//           style: TextStyle(
//             fontFamily: 'Prompt_regular',
//             fontSize: 13.sp,
//             color: AppColors.textColor,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // void _addMeal() {
//   //   // TODO: Implement meal addition logic
//   //   // Validate inputs
//   //   if (_selectedDay == null) {
//   //     // Show error for missing day selection
//   //     return;
//   //   }
//   //
//   //   if (_mealNameController.text.isEmpty) {
//   //     // Show error for missing meal name
//   //     return;
//   //   }
//   //
//   //   // TODO: Add meal to meal plan
//   //   Navigator.of(context).pop();
//   // }
//   void _addMeal() async {
//     if (_selectedDay == null || _selectedDay!.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please select a day",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     if (_mealNameController.text.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please enter meal name",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     final mealViewModel = Get.find<MealViewModel>();
//
//     final newMeal = MealModel(
//       name: _mealNameController.text.trim(),
//       ingredients: _ingredientsController.text.trim().isNotEmpty
//           ? _ingredientsController.text.split(',').map((e) => e.trim()).toList()
//           : [],
//       notes: _notesController.text.trim(),
//       day: _selectedDay!,
//       type: _selectedMealType ?? widget.mealTypes.first,
//     );
//
//     final success = await mealViewModel.addMeal(newMeal);
//
//     if (success) {
//       Navigator.of(context).pop();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../../theme/app_textstyles.dart';
import '../widgets/custom_dropdown.dart';
import 'package:mom_app/viewmodels/meal_view_model.dart';
import '../../models/meal_model.dart';
import 'package:get/get.dart';

class AddMealModal extends StatefulWidget {
  final List<String> days;
  final List<String> mealTypes;

  const AddMealModal({
    super.key,
    required this.days,
    required this.mealTypes,
  });

  @override
  State<AddMealModal> createState() => _AddMealModalState();
}

class _AddMealModalState extends State<AddMealModal> {
  late TextEditingController _mealNameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _notesController;

  String? _selectedDay;
  String? _selectedMealType;

  @override
  void initState() {
    super.initState();
    _mealNameController = TextEditingController();
    _ingredientsController = TextEditingController();
    _notesController = TextEditingController();
    _selectedMealType =
    widget.mealTypes.isNotEmpty ? widget.mealTypes.first : null;
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    _ingredientsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addMeal() async {
    // ===== VALIDATION =====
    if (_selectedDay == null || _selectedDay!.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a day",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_mealNameController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter meal name",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedMealType == null || _selectedMealType!.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select meal type",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final mealViewModel = Get.find<MealViewModel>();

      // Create MealModel
      final newMeal = MealModel(
        name: _mealNameController.text.trim(),
        ingredients: _ingredientsController.text.trim().isNotEmpty
            ? _ingredientsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList()
            : [],
        notes: _notesController.text.trim(),
        day: _selectedDay!,
        type: _selectedMealType!,
      );

      // Add meal to Firebase
      final success = await mealViewModel.addMeal(newMeal);

      if (success) {
        // Close dialog
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add meal: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Add Meal",
                        style: TextStyle(
                          fontFamily: 'Prompt_Bold',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: AppColors.subHeadingColor,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Select Day Dropdown
                      _buildDropdownField(
                        label: "Select day",
                        value: _selectedDay,
                        items: widget.days,
                        onChanged: (value) {
                          setState(() {
                            _selectedDay = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Meal Type Dropdown
                      _buildDropdownField(
                        label: "Meal type",
                        value: _selectedMealType,
                        items: widget.mealTypes,
                        onChanged: (value) {
                          setState(() {
                            _selectedMealType = value;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Meal Name
                      _buildTextField(
                        controller: _mealNameController,
                        label: "Meal name",
                        hint: "e.g., Grilled Chicken",
                      ),
                      SizedBox(height: 16.h),

                      // Ingredients
                      _buildTextField(
                        controller: _ingredientsController,
                        label: "Ingredients (comma separated)",
                        hint: "e.g., Chicken, Rice, Garlic",
                        maxLines: 3,
                      ),
                      SizedBox(height: 16.h),

                      // Notes
                      _buildTextField(
                        controller: _notesController,
                        label: "Notes (optional)",
                        hint: "Any cooking tips or notes",
                        maxLines: 4,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // Add Meal Button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final mealViewModel = Get.find<MealViewModel>();
                    final isLoading = mealViewModel.isLoading.value;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _addMeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        disabledBackgroundColor:
                        AppColors.primary.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        "Add Meal",
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 6.h),
        CustomDropdown<String>(
          items: items.toDropdownItems((item) => item),
          value: value,
          onChanged: (newValue) {
            onChanged(newValue);
          },
          hintText: label,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            hintStyle: TextStyle(
              fontFamily: 'Prompt_regular',
              fontSize: 13.sp,
              color: AppColors.subHeadingColor,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Prompt_regular',
            fontSize: 13.sp,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }
}
