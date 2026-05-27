import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/features/products/data/repositories/product_repository.dart';
import 'package:product_list_app/features/products/logic/cubit/product_state.dart';
import '../../../../core/errors/failures.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  List<ProductModel> _allProducts = [];

  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      _allProducts = await repository.getProduct();

      emit(
        ProductLoaded(products: _allProducts, filteredProducts: _allProducts),
      );
    } catch (e) {
      if (e is Failure) {
        emit(ProductError(e.message));
      } else {
        emit(ProductError("Unexpected error occurred"));
      }
    }
  }

  void searchProducts(String query) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final filtered = current.products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(
        ProductLoaded(products: current.products, filteredProducts: filtered),
      );
    }
  }

  void filteredCategory(String category) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;

      final filtered = current.products
          .where((p) => p.category == category)
          .toList();
      emit(
        ProductLoaded(products: current.products, filteredProducts: filtered),
      );
    }
  }

  void sortLowToHigh() {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;

      final sorted = List<ProductModel>.from(current.filteredProducts)
        ..sort((a, b) => a.price.compareTo(b.price));
      emit(ProductLoaded(products: current.products, filteredProducts: sorted));
    }
  }

  void sortHighToLow() {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;

      final sorted = List<ProductModel>.from(current.filteredProducts)
        ..sort((a, b) => b.price.compareTo(a.price));
      emit(ProductLoaded(products: current.products, filteredProducts: sorted));
    }
  }

  void resetFilters() {
    if (_allProducts.isNotEmpty) {
      emit(
        ProductLoaded(products: _allProducts, filteredProducts: _allProducts),
      );
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
    resetFilters();
  }
}
