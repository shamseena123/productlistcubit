import 'package:equatable/equatable.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;

  const ProductLoaded({required this.products, required this.filteredProducts});

  @override
  List<Object> get props => [products, filteredProducts];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
