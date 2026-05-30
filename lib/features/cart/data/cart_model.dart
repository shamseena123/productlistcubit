import 'package:hive/hive.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartModel {
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  int quantity;

  CartModel({required this.product, this.quantity = 1});

  // =========================
  // JSON ENCODE
  // =========================
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }

  // =========================
  // JSON DECODE
  // =========================
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }
}
