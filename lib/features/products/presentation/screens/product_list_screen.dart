import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/address/presentation/screens/address_screen.dart';

import 'package:product_list_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:product_list_app/features/cart/presentation/cart_screen.dart';
import 'package:product_list_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:product_list_app/features/products/presentation/widgets/product_card.dart';

import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';
import 'package:product_list_app/features/whislist/presentation/screens/wishlist_screen.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';

import '../../logic/cubit/product_cubit.dart';
import '../../logic/cubit/product_state.dart';

import '../widgets/product_search_bar.dart';
import '../widgets/product_filter_bar.dart';

import '../../../../core/theme/app_theme.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String selectedCategory = "All";
  List<String> categories = ["All"];

  String selectedSort = "None";
  List<String> sortOptions = ["None", "Low to High", "High to Low"];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          "PRODUCTS",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        actions: [
          /// ❤️ WISHLIST + 📍 ADDRESS
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              int count = 0;

              if (state is WishListUpdated) {
                count = state.items.length;
              }

              return Row(
                children: [
                  /// 📍 ADDRESS
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddressScreen()),
                      );
                    },
                    icon: const Icon(Icons.location_on, color: Colors.white),
                  ),

                  /// ❤️ WISHLIST
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WishlistScreen(),
                            ),
                          );
                        },
                      ),

                      if (count > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),

          /// 🛒 CART
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),

          /// 🚪 LOGOUT
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),

      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          /// LOADING
          if (state is ProductLoading) {
            return const LoadingWidget();
          }

          /// ERROR
          if (state is ProductError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ProductCubit>().loadProducts();
              },
            );
          }

          /// SUCCESS
          if (state is ProductLoaded) {
            categories = [
              "All",
              ...state.products.map((p) => p.category).toSet().toList(),
            ];

            return BlocListener<WishlistCubit, WishlistState>(
              listener: (context, state) {
                if (state is WishListUpdated && state.message != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message!)));
                }
              },
              child: Column(
                children: [
                  /// 🔍 SEARCH
                  ProductSearchBar(
                    controller: searchController,
                    onChanged: (value) {
                      context.read<ProductCubit>().searchProducts(value);
                    },
                  ),

                  /// 📂 CATEGORY
                  ProductFilterBar(
                    value: selectedCategory,
                    items: categories,
                    hintText: "Category",
                    onChanged: (value) {
                      selectedCategory = value!;
                      context.read<ProductCubit>().filteredCategory(value);
                    },
                  ),

                  const SizedBox(height: 10),

                  /// 💰 SORT
                  ProductFilterBar(
                    value: selectedSort,
                    items: sortOptions,
                    hintText: "Sort Price",
                    onChanged: (value) {
                      selectedSort = value!;

                      if (value == "Low to High") {
                        context.read<ProductCubit>().sortLowToHigh();
                      } else if (value == "High to Low") {
                        context.read<ProductCubit>().sortHighToLow();
                      } else {
                        context.read<ProductCubit>().resetFilters();
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  /// 📦 PRODUCT LIST
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<ProductCubit>().refreshProducts();
                      },
                      child: state.filteredProducts.isEmpty
                          ? const Center(child: Text("No product found"))
                          : ListView.builder(
                              itemCount: state.filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = state.filteredProducts[index];

                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
