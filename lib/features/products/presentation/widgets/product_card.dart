import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import '../../../../core/utils/price_formatter.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      child: ListTile(
        onTap: onTap,
        leading: Image.network(product.image, width: 50, height: 50),

        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PriceFormatter.format(product.price)),
            Text(product.category),
            Row(
              children: [
                const Icon(Icons.star, size: 18),
                Text("${product.rating}"),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            final cartCubit = context.read<CartCubit>();

            cartCubit.addToCart(CartModel(product: product));
            // context.read<CartCubit>().addToCart(CartModel(product: product));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${product.title}Added to Cart")),
            );
          },
          child: const Text("Add to Cart"),
        ),
      ),
    );
  }
}
