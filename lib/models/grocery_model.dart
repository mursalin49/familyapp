class GroceryItemModel {
  final String? id;
  final String name;
  final int quantity;
  final String category;
  bool completed;

  GroceryItemModel({
    this.id,
    required this.name,
    required this.quantity,
    this.category = 'Uncategorized',
    this.completed = false,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['_id'] ?? json['id'],
      // ✅ Handle both 'name' and 'itemName' from backend
      name: json['itemName'] ?? json['name'] ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 1,
      category: json['category'] ?? 'Uncategorized',
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'itemName': name, // ✅ Send as 'itemName' to match backend
      'quantity': quantity,
      'category': category,
      'completed': completed,
    };
  }

  // ✅ For debugging
  @override
  String toString() {
    return 'GroceryItem(id: $id, name: $name, qty: $quantity, category: $category, completed: $completed)';
  }
}
