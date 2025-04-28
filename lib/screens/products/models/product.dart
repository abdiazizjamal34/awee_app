class Product {
  final String id;
  final String name;
  final String sku;
  final String Price;
  final String stock;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.Price,
    required this.stock,
    required this.description,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      sku: json['sku'].toString(), // <- FIX HERE
      Price: (json['price'] ?? 0).toDouble().toString(),
      stock: (json['stock'] ?? 0).toString(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }
}
