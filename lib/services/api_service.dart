import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUri = "https://fakestoreapi.com/products";

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUri));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception("failed to load products:${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Something went wrong:${e}");
    }
  }
}
