import 'package:product_list_app/features/cart/data/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartModel> items;

  CartUpdated(this.items);
}

class CartEmpty extends CartState {}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
