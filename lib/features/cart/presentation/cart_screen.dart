import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MY CART",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartEmpty || state is CartInitial) {
            return const Center(child: Text("Your Cart is Empty"));
          }
          if (state is CartUpdated) {
            final items = state.items;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(
                            item.product.image,
                            width: 50,
                            height: 50,
                          ),

                          title: Text(
                            "₹${item.product.price.toString()} x ${item.quantity}",
                          ),

                          //ACTION BUTTON
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //DECREASE
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context.read<CartCubit>().decreaseQuantity(
                                    item.product.id,
                                  );
                                },
                              ),

                              Text("${item.quantity}"),

                              //Increase
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  context.read<CartCubit>().increaseQuantity(
                                    item.product.id,
                                  );
                                },
                              ),

                              //Remove
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<CartCubit>().removeFromCart(
                                    item.product.id,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subtotal: ₹${context.read<CartCubit>().subtotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 5),

                      Text(
                        "Vat(5%): ₹${context.read<CartCubit>().vat.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 5),

                      Text(
                        "Delivery: ₹${context.read<CartCubit>().deliveryCharge.toStringAsFixed(2)}",
                      ),

                      const Divider(),

                      Text(
                        "Grand Total: ₹${context.read<CartCubit>().grandtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
