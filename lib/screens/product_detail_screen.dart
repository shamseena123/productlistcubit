import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "PRODUCT DETAILS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        backgroundColor: const Color.fromARGB(255, 93, 171, 109),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(child: Image.network(product.image, height: 220)),
            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "Price:${product.price}",
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 10),

            Text("Category:${product.category}"),

            const SizedBox(height: 10),

            Row(children: [Icon(Icons.start), Text("${product.rating}")]),
          ],
        ),
      ),
    );
  }
}
