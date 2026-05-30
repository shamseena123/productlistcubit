import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Wishlist")),

      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishListUpdated) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(child: Text("Wishlist is Empty"));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];

                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),

                  title: Text(product.title),

                  subtitle: Text("\$${product.price}"),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<WishlistCubit>().removeFromlist(product.id);
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
