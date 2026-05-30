import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/core/utils/price_formatter.dart';

import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';

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

        leading: Image.network(
          product.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),

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

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ❤️ WISHLIST BUTTON
            BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                bool isInWishlist = false;

                if (state is WishListUpdated) {
                  isInWishlist = state.items.any(
                    (item) => item.id == product.id,
                  );
                }

                return IconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<WishlistCubit>().toggleWishlist(product);
                  },
                );
              },
            ),

            /// 🛒 CART BUTTON
            ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().addToCart(
                  CartModel(product: product),
                );
              },
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
