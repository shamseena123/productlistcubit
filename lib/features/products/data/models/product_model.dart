class ProductModel {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final double rating;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? "",
      image: json['image'] ?? "",
      rating: (json['rating'] != null)
          ? (json['rating']['rate'] as num).toDouble()
          : 0.0,
      ratingCount: json['rating']?['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'image': image,
      'rating': {'rate': rating, 'count': ratingCount},
    };
  }
}
