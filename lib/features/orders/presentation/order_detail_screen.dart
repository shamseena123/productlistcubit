import 'package:flutter/material.dart';

import 'package:product_list_app/features/orders/data/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total: \$${order.totalPrice}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text("Date: ${order.dateTime}"),

            const SizedBox(height: 20),

            const Text(
              "Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];

                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        item.product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.product.title),
                      subtitle: Text("Quantity: ${item.quantity}"),
                      trailing: Text("\$${item.product.price}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
