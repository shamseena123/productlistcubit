import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String image;

  @HiveField(5)
  final double rating;

  @HiveField(6)
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

  // =========================
  // JSON DECODE (SAFE)
  // =========================
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'];

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: (ratingData is Map && ratingData['rate'] != null)
          ? (ratingData['rate'] as num).toDouble()
          : 0.0,
      ratingCount: (ratingData is Map && ratingData['count'] != null)
          ? ratingData['count']
          : 0,
    );
  }

  // =========================
  // JSON ENCODE
  // =========================
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
