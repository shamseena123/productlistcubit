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
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
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
            return const Center(
              child: Text(
                "Your Cart is Empty 🛒",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          if (state is CartUpdated) {
            final items = state.items;
            final cubit = context.read<CartCubit>();

            return Column(
              children: [
                /// 🛒 CART LIST
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
                            "₹${item.product.price} x ${item.quantity}",
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cubit.decreaseQuantity(item.product.id);
                                },
                              ),

                              Text("${item.quantity}"),

                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cubit.increaseQuantity(item.product.id);
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  cubit.removeFromCart(item.product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 💰 TOTAL + CHECKOUT SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Subtotal: ₹${cubit.subtotal.toStringAsFixed(2)}"),
                      const SizedBox(height: 5),

                      Text("VAT (5%): ₹${cubit.vat.toStringAsFixed(2)}"),
                      const SizedBox(height: 5),

                      Text(
                        "Delivery: ₹${cubit.deliveryCharge.toStringAsFixed(2)}",
                      ),

                      const Divider(),

                      Text(
                        "Grand Total: ₹${cubit.grandtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🧾 CHECKOUT BUTTON (WITH CONFIRM DIALOG)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Order"),
                                  content: Text(
                                    "Total Amount: ₹${cubit.grandtotal.toStringAsFixed(2)}",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        await cubit.checkout();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Order placed successfully 🎉",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text("Confirm"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Checkout (₹${cubit.grandtotal.toStringAsFixed(2)})",
                          ),
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
