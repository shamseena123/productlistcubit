import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/core/utils/price_formatter.dart';

import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';

class ProductCardCategory extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductCardCategory({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// IMAGE SECTION (stable height via AspectRatio)
            Stack(
              children: [
                SizedBox(
  height: 110,
  width: double.infinity,
  child: Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        product.image,
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                /// WISHLIST ICON
                Positioned(
                  top: 6,
                  right: 6,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      bool isFav = false;

                      if (state is WishListUpdated) {
                        isFav = state.items.any((e) => e.id == product.id);
                      }

                      return GestureDetector(
                        onTap: () {
                          context.read<WishlistCubit>().toggleWishlist(product);
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: const Color(0xFF7C3AED),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            /// CONTENT (tight + controlled spacing)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    /// TITLE
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// PRICE
                    Text(
                      PriceFormatter.format(product.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A),
                      ),
                    ),

                    /// RATING
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text("${product.rating}",
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartCubit>().addToCart(
                            CartModel(product: product),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7C3AED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}