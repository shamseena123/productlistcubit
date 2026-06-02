import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/features/products/data/repositories/product_repository.dart';
import 'package:product_list_app/features/products/logic/cubit/product_state.dart';
import '../../../../core/errors/failures.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;

  ProductCubit(this.repository) : super(ProductInitial());

  List<ProductModel> _allProducts = [];

  String _selectedCategory = "All";
  String _selectedSort = "None";
  String _searchQuery = "";

  /// LOAD PRODUCTS
  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      _allProducts = await repository.getProduct();

      _applyFilters();
    } catch (e) {
      if (e is Failure) {
        emit(ProductError(e.message));
      } else {
        emit(ProductError("Unexpected error occurred"));
      }
    }
  }

  /// CORE FILTER ENGINE (CATEGORY + SEARCH + SORT)
  void _applyFilters() {
    List<ProductModel> filtered = List.from(_allProducts);

    /// CATEGORY FILTER
    if (_selectedCategory != "All") {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    /// SEARCH FILTER
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    /// SORT FILTER
    if (_selectedSort == "Low to High") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == "High to Low") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    emit(ProductLoaded(products: _allProducts, filteredProducts: filtered));
  }

  /// SEARCH
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// CATEGORY
  void filteredCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// SORT LOW → HIGH
  void sortLowToHigh() {
    _selectedSort = "Low to High";
    _applyFilters();
  }

  /// SORT HIGH → LOW
  void sortHighToLow() {
    _selectedSort = "High to Low";
    _applyFilters();
  }

  /// RESET ALL FILTERS
  void resetFilters() {
    _selectedCategory = "All";
    _selectedSort = "None";
    _searchQuery = "";
    _applyFilters();
  }

  /// REFRESH
  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
