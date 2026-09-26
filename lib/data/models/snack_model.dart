class SnackModel {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;

  SnackModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
  });

  // Konversi dari Map (SQLite) ke Object Model
  factory SnackModel.fromMap(Map<String, dynamic> map) {
    return SnackModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      imageUrl: map['image_url'] as String,
      stock: map['stock'] as int,
    );
  }

  // Konversi dari Object Model ke Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'stock': stock,
    };
  }
}
