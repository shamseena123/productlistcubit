// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:product_list_app/features/products/data/models/product_model.dart';

class CartModel {
  final ProductModel product;
  int quantity;
  CartModel({required this.product, this.quantity = 1});
}
