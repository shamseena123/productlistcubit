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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),

        child: SizedBox(
          height: double.infinity, // 🔥 LOCK HEIGHT
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE (fixed)
              Stack(
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(product.image, fit: BoxFit.contain),
                    ),
                  ),

                  /// Wishlist stays same
                  Positioned(
                    top: 6,
                    right: 6,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, state) {
                        final isFav =
                            state is WishListUpdated &&
                            state.items.any((e) => e.id == product.id);

                        return GestureDetector(
                          onTap: () {
                            context.read<WishlistCubit>().toggleWishlist(
                              product,
                            );
                          },
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
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

              /// CONTENT (FIXED HEIGHT DISTRIBUTION)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

                      const SizedBox(height: 4),

                      /// PRICE
                      Text(
                        PriceFormatter.format(product.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// RATING
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${product.rating}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // const Spacer(), // 🔥 PUSH BUTTON TO BOTTOM
                      /// BUTTON (no fixed height)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CartCubit>().addToCart(
                              CartModel(product: product),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(fontSize: 12, color: Colors.white),
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
      ),
    );
  }
}
