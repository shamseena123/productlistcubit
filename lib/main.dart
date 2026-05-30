import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:product_list_app/core/storage/local_storage_services.dart';
import 'package:product_list_app/features/address/data/logic/address_cubit.dart';
// import 'package:product_list_app/features/address/data/logic/address_cubit.dart';
import 'package:product_list_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:product_list_app/features/auth/presentation/login_screen.dart';
import 'package:product_list_app/features/cart/data/cart_model.dart';
import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/products/data/models/product_model.dart';
import 'package:product_list_app/features/products/data/repositories/product_repository.dart';
import 'package:product_list_app/features/products/data/services/api_service.dart';
import 'package:product_list_app/features/products/logic/cubit/product_cubit.dart';
import 'package:product_list_app/features/products/presentation/screens/product_list_screen.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'core/theme/app_theme.dart';

import 'package:product_list_app/features/address/data/logic/address_cubit.dart';

import 'package:product_list_app/features/address/data/models/address_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());

  await Hive.openBox('cartBox');

  await Hive.openBox('wishlistBox');

  await Hive.openBox('addressBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    final repository = ProductRepository(apiService: apiService);

    final storageService = LocalStorageServices();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit(repository)),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => WishlistCubit()),
        BlocProvider(create: (context) => AddressCubit()),
        BlocProvider(
          create: (context) => AuthCubit(storageService)..checkLoginStatus(),
        ),
        // BlocProvider(create: (_) => AddressCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product List APP',
        theme: AppTheme.lightTheme,

        home: BlocBuilder<AuthCubit, bool>(
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const ProductListScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
