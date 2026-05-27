import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<CartModel> _cartItems = [];

  void addToCart(CartModel newItem) {
    try {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == newItem.product.id,
      );

      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(newItem);
      }
      emit(CartUpdated(List.from(_cartItems)));
    } catch (e) {
      emit(CartError("Failed to add item"));
    }
  }

  void increaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _cartItems[index].quantity++;
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  void decreaseQuantity(int productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    if (_cartItems.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  double get subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  double get vat {
    return subtotal * 0.05;
  }

  double get deliveryCharge {
    return _cartItems.isEmpty ? 0 : 40;
  }

  double get grandtotal {
    return subtotal + vat + deliveryCharge;
  }
}
