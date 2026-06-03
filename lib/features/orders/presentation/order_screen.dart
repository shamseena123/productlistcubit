import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/orders_cubit.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: const Color(0xFF7C3AED),
      ),

      body: BlocBuilder<OrdersCubit, List>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders yet 🧾"),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Total: \$${order.totalPrice}"),
                  subtitle: Text(order.dateTime.toString()),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              );
            },
          );
        },
      ),
    );
  }
}