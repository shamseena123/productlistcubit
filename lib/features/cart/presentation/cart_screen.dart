import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';
import 'package:product_list_app/features/orders/data/order_model.dart';
import 'package:product_list_app/features/orders/logic/orders_cubit.dart';
import 'package:product_list_app/features/orders/presentation/order_screen.dart';

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
          final cubit = context.read<CartCubit>();

          // ✅ FIX 3: SAFETY GUARD (VERY IMPORTANT)
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

            // ✅ EXTRA SAFETY (prevents ghost UI issue)
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "Your Cart is Empty 🛒",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

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
                            "\$${item.product.price} x ${item.quantity}",
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
                      Text("Subtotal: \$${cubit.subtotal.toStringAsFixed(2)}"),
                      const SizedBox(height: 5),

                      Text("VAT (5%): \$${cubit.vat.toStringAsFixed(2)}"),
                      const SizedBox(height: 5),

                      Text(
                        "Delivery: \$${cubit.deliveryCharge.toStringAsFixed(2)}",
                      ),

                      const Divider(),

                      Text(
                        "Grand Total: \$${cubit.grandtotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🧾 CHECKOUT BUTTON
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
                                    "Total Amount: \$${cubit.grandtotal.toStringAsFixed(2)}",
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
                                        print("CONFIRM CLICKED");

                                        final messenger = ScaffoldMessenger.of(
                                          context,
                                        );
                                        final navigator = Navigator.of(context);

                                        final cartCubit = context
                                            .read<CartCubit>();
                                        final ordersCubit = context
                                            .read<OrdersCubit>();

                                        final order = OrderModel(
                                          items: cartCubit.cartItems,
                                          totalPrice: cartCubit.grandtotal,
                                          dateTime: DateTime.now(),
                                        );

                                        try {
                                          await ordersCubit.addOrder(order);
                                          await cartCubit.checkout();

                                          navigator
                                              .pop(); // close dialog AFTER logic

                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Order placed successfully 🎉",
                                              ),
                                            ),
                                          );

                                          navigator.push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const OrdersScreen(),
                                            ),
                                          );
                                        } catch (e) {
                                          print("CHECKOUT ERROR: $e");

                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Something went wrong ❌",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Confirm"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Checkout (\$${cubit.grandtotal.toStringAsFixed(2)})",
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
