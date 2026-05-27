import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/products/data/repositories/product_repository.dart';
import 'package:product_list_app/features/products/data/services/api_service.dart';
import 'package:product_list_app/features/products/logic/cubit/product_cubit.dart';
import 'package:product_list_app/features/products/presentation/screens/product_list_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    final repository = ProductRepository(apiService: apiService);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit(repository)),
        BlocProvider(create: (context) => CartCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product List APP',
        theme: AppTheme.lightTheme,

        home: const ProductListScreen(),
      ),
    );
  }
}
