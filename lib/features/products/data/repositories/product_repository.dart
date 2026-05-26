// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/features/products/data/services/api_service.dart';

class ProductRepository {
  final ApiService apiService;
  ProductRepository({required this.apiService});

  Future<List<ProductModel>> getProduct() async {
    try {
      return await apiService.fetchProducts();
    } catch (e) {
      throw Exception("Repository error:$e");
    }
  }
}
