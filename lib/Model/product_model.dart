class ProductModel {
  final String name;
  final String category;
  final String imageUrl;
  final double amount;
  final double discount;

  ProductModel({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.amount,
    required this.discount,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
    );
  }
}
