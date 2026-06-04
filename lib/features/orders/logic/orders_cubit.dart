import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../data/order_model.dart';

class OrdersCubit extends Cubit<List<OrderModel>> {
  OrdersCubit() : super([]);

  final Box ordersBox = Hive.box('ordersBox');

  void loadOrders(String email) {
    final data = ordersBox.get('orders_list_$email');

    // print("Email:$email");
    // print("DATA FROM HIVE:$data");

    if (data == null || data is! List) {
      emit([]);
      return;
    }

    final orders = data
        .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    emit(orders.reversed.toList());
  }

  Future<void> addOrder(String email, OrderModel order) async {
    final data = ordersBox.get('orders_list_$email');

    List existing = data ?? [];

    final updated = [
      ...existing,
      order.toJson(), // 🔥 ONLY JSON
    ];

    await ordersBox.put('orders_list_$email', updated);

    loadOrders(email);
  }
}
