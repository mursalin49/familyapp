class MealModel {
  final String? id;
  final String name;
  final List<String>? ingredients;
  final String? notes;
  final String day;
  final String type;

  MealModel({
    this.id,
    required this.name,
    this.ingredients,
    this.notes,
    required this.day,
    required this.type,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    var ingredientsData = json['ingredients'];
    List<String>? parsedIngredients;

    if (ingredientsData is String) {
      parsedIngredients = ingredientsData
          .split(',')
          .map((e) => e.trim())
          .toList();
    } else if (ingredientsData is List) {
      parsedIngredients = ingredientsData.map((e) => e.toString()).toList();
    }

    return MealModel(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? json['mealName'] ?? '',
      ingredients: parsedIngredients,
      notes: json['notes'],
      day: json['day'] ?? '',
      type: json['type'] ?? json['mealType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'mealName': name,
      'notes': notes,
      'day': day,
      'type': type,
      'mealType': type,
      'ingredients': ingredients?.join(', ') ?? '',
    };
  }
}
