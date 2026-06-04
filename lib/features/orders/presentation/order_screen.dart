import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';
import 'package:product_list_app/features/orders/data/order_model.dart';
import 'package:product_list_app/features/orders/presentation/order_detail_screen.dart';
import '../logic/orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

 @override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final storage = LocalStorageServices();
    final email = await storage.getString("currentUser");

    if (email != null) {
      context.read<OrdersCubit>().loadOrders(email);
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: const Color(0xFF7C3AED),
      ),

      body: BlocBuilder<OrdersCubit, List<OrderModel>>(
        builder: (context, orders) {
          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet 🧾"));
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

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
