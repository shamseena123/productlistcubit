import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/order_model.dart';

class OrdersCubit extends Cubit<List<OrderModel>> {
  OrdersCubit() : super([]) {
    loadOrders();
  }

  final Box ordersBox = Hive.box('ordersBox');

 void loadOrders() {
  final data = ordersBox.get('orders_list');

  if (data == null || data is! List) {
    emit([]);
    return;
  }

  final orders = data
      .map(
        (e) => OrderModel.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
      .toList();

  emit(orders.reversed.toList());
}
  Future<void> addOrder(OrderModel order) async {
    final data = ordersBox.get('orders_list');

    List existing = data ?? [];

    final updated = [
      ...existing,
      order.toJson(), // 🔥 ONLY JSON
    ];

    await ordersBox.put('orders_list', updated);
    print("ORDER SAVED: ${order.toJson()}");

    loadOrders();
  }
}
