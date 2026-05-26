import 'package:product_list_app/core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/errors/failures.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final List data = await apiClient.get(AppConstants.baseUrl);

      return data.map((item) => ProductModel.fromJson(item)).toList();
    } catch (e) {
      throw ServerFailure("Something went wrong:$e");
    }
  }
}
