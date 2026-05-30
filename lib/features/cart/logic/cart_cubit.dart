import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    loadCart();
  }

  void loadCart() {
    final savedItems = cartBox.get('cartItems');

    if (savedItems != null) {
      _cartItems.addAll(List<CartModel>.from(savedItems));
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  final Box cartBox = Hive.box('cartBox');

  Future<void> saveCart(List<CartModel> items) async {
    await cartBox.put('cartItems', items);
  }

  final List<CartModel> _cartItems = [];

  Future<void> addToCart(CartModel newItem) async {
    try {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == newItem.product.id,
      );

      if (index != -1) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(newItem);
      }
      await saveCart(_cartItems);
      emit(CartUpdated(List.from(_cartItems)));
    } catch (e) {
      emit(CartError("Failed to add item"));
    }
  }

  Future<void> increaseQuantity(int productId) async {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _cartItems[index].quantity++;
      await saveCart(_cartItems);
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  Future<void> decreaseQuantity(int productId) async {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
      await saveCart(_cartItems);
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  Future<void> removeFromCart(int productId) async {
    _cartItems.removeWhere((item) => item.product.id == productId);
    if (_cartItems.isEmpty) {
      await saveCart(_cartItems);
      emit(CartEmpty());
    } else {
      await saveCart(_cartItems);
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
