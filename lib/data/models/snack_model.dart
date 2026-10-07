class SnackModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;

  const SnackModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.stock = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'stock': stock,
    };
  }

  factory SnackModel.fromMap(Map<String, dynamic> map) {
    return SnackModel(
      id: map['id']?.toString() ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: map['price'] is num
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price'].toString()) ?? 0.0,
      imageUrl: (map['imageUrl'] ?? map['image_url'] ?? '').toString(),
      stock: map['stock'] is int
          ? map['stock'] as int
          : int.tryParse(map['stock'].toString()) ?? 0,
    );
  }
}
