import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishListInitial()) {
    loadWishlist();
  }

  final Box wishlistBox = Hive.box('wishlistBox');
  final List<ProductModel> _wishlistItems = [];

  // =========================
  // LOAD FROM HIVE (DECODE)
  // =========================
  void loadWishlist() {
    final savedItems = wishlistBox.get('wishlistItems');

    if (savedItems != null) {
      final List list = savedItems;

      _wishlistItems.clear();

      _wishlistItems.addAll(
        list.map(
          (item) => ProductModel.fromJson(Map<String, dynamic>.from(item)),
        ),
      );

      emit(WishListUpdated(List.from(_wishlistItems)));
    } else {
      _wishlistItems.clear();
      emit(WishListUpdated([]));
    }
  }

  // =========================
  // SAVE TO HIVE (ENCODE)
  // =========================
  Future<void> saveWishlist() async {
    final data = _wishlistItems.map((item) => item.toJson()).toList();

    await wishlistBox.put('wishlistItems', data);
  }

  // =========================
  // ADD ITEM
  // =========================
  Future<void> addToWishlist(ProductModel product) async {
    final exists = _wishlistItems.any((item) => item.id == product.id);

    if (!exists) {
      _wishlistItems.add(product);

      await saveWishlist();

      emit(WishListUpdated(List.from(_wishlistItems)));
    }
  }

  Future<void> toggleWishlist(ProductModel product) async {
    final exists = _wishlistItems.any((item) => item.id == product.id);

    if (exists) {
      _wishlistItems.removeWhere((item) => item.id == product.id);

      await saveWishlist();

      emit(
        WishListUpdated(
          List.from(_wishlistItems),
          message: "Removed from wishlist",
        ),
      );
    } else {
      _wishlistItems.add(product);

      await saveWishlist();

      emit(
        WishListUpdated(
          List.from(_wishlistItems),
          message: "Added to wishlist",
        ),
      );
    }
  }

  
  Future<void> removeFromlist(int productId) async {
    _wishlistItems.removeWhere((item) => item.id == productId);

    await saveWishlist();

    emit(WishListUpdated(List.from(_wishlistItems)));
  }

  void clearWishlistState() {
  _wishlistItems.clear();
  emit(WishListUpdated([]));
}
}
