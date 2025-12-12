class GroceryItemModel {
  final String? id;
  final String name;
  final int quantity;
  final String category;
  bool completed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GroceryItemModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.completed = false,
    this.createdAt,
    this.updatedAt,
  });

  // ===== FROM JSON (API Response) =====
  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    // ✅ Parse itemName (backend sends 'itemName', not 'name')
    final parsedName = json['itemName'] as String? ?? json['name'] as String? ?? '';

    // ✅ Parse quantity - backend sends STRING "1", not int 1
    int parsedQuantity = 1;
    if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        parsedQuantity = json['quantity'] as int;
      } else if (json['quantity'] is String) {
        parsedQuantity = int.tryParse(json['quantity'] as String) ?? 1;
      }
    }

    return GroceryItemModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      name: parsedName,
      quantity: parsedQuantity,
      category: json['category'] as String? ?? 'Uncategorized',
      completed: json['completed'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // ===== TO JSON (For API requests) =====
  Map<String, dynamic> toJson() {
    return {
      'itemName': name, // ✅ Backend expects 'itemName'
      'quantity': quantity,
      'category': category,
      'completed': completed,
    };
  }

  // ===== COPY WITH =====
  GroceryItemModel copyWith({
    String? id,
    String? name,
    int? quantity,
    String? category,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroceryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'GroceryItemModel(id: $id, name: "$name", quantity: $quantity, category: "$category", completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroceryItemModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}