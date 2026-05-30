import 'package:product_list_app/features/products/data/models/product_model.dart';

abstract class WishlistState {}

class WishListInitial extends WishlistState {}

class WishListUpdated extends WishlistState {
  final List<ProductModel> items;

  final String? message;

  WishListUpdated(this.items, {this.message});
}
