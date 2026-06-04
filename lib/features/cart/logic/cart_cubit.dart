import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';
import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';
import 'package:product_list_app/features/orders/data/order_model.dart';
import 'package:product_list_app/features/orders/logic/orders_cubit.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    initializeUserCart();
  }

  final Box cartBox = Hive.box('cartBox');
  final LocalStorageServices storageService = LocalStorageServices();

  final List<CartModel> _cartItems = [];

  String _cartKey = "cartItems";

  // ✅ STEP 1: expose cart items for Orders feature
  List<CartModel> get cartItems => List.from(_cartItems);

  void loadCart() {
    _cartItems.clear();

    final savedItems = cartBox.get(_cartKey);

    if (savedItems != null) {
      final list = (savedItems as List);

      _cartItems.addAll(
        list.map((e) {
          if (e is Map) {
            return CartModel.fromJson(Map<String, dynamic>.from(e));
          } else if (e is CartModel) {
            return e;
          } else {
            throw Exception("Unknown cart data type");
          }
        }).toList(),
      );

      emit(CartUpdated(List.from(_cartItems)));
    } else {
      emit(CartEmpty());
    }
  }

  Future<void> initializeUserCart() async {
    final currentUser = await storageService.getString("currentUser");

    if (currentUser == null) {
      emit(CartEmpty());
      return;
    }

    _cartKey = "cartItems_$currentUser";

    loadCart();
  }

  Future<void> saveCart(List<CartModel> items) async {
    await cartBox.put(_cartKey, items.map((e) => e.toJson()).toList());
  }

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

    await saveCart(_cartItems);

    if (_cartItems.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartUpdated(List.from(_cartItems)));
    }
  }

  Future<void> checkout(BuildContext context) async {
    try {
      if (_cartItems.isEmpty) return;

      final email = await storageService.getString("currentUser");

      if (email == null) {
        emit(CartError("User not found"));
        return;
      }

      // 1. CREATE ORDER MODEL
      final order = OrderModel(
        items: List.from(_cartItems),
        totalPrice: grandtotal,
        dateTime: DateTime.now(),
      );

      // 2. SAVE ORDER (THIS FIXES YOUR ISSUE)
      await context.read<OrdersCubit>().addOrder(email, order);

      // 3. CLEAR CART
      _cartItems.clear();
      await cartBox.put(_cartKey, []);

      emit(CartEmpty());
    } catch (e) {
      emit(CartError("Checkout failed"));
    }
  }

  void clearCartState() {
    _cartItems.clear();
    emit(CartEmpty());
  }

  double get subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  double get vat => subtotal * 0.05;

  double get deliveryCharge => _cartItems.isEmpty ? 0 : 40;

  double get grandtotal => subtotal + vat + deliveryCharge;
}
