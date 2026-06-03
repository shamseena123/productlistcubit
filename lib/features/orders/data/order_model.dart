import 'package:product_list_app/features/cart/data/cart_model.dart';

class OrderModel {
  final List<CartModel> items;
  final double totalPrice;
  final DateTime dateTime;

  OrderModel({
    required this.items,
    required this.totalPrice,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "items": items.map((e) => e.toJson()).toList(),
      "totalPrice": totalPrice,
      "dateTime": dateTime.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      items: (json["items"] as List)
          .map((e) => CartModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      totalPrice: json["totalPrice"],
      dateTime: DateTime.parse(json["dateTime"]),
    );
  }
}