import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:product_list_app/features/products/presentation/widgets/product_card.dart';

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
      ),

      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // LOADING
          if (state is ProductLoading) {
            return const LoadingWidget();
          }

          // ERROR
          if (state is ProductError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<ProductCubit>().loadProducts();
              },
            );
          }

          // SUCCESS
          if (state is ProductLoaded) {
            categories = [
              "All",
              ...state.products.map((p) => p.category).toSet(),
            ];
            return Column(
              children: [
                // SEARCH
                ProductSearchBar(
                  controller: searchController,
                  onChanged: (value) {
                    context.read<ProductCubit>().searchProducts(value);
                  },
                ),

                // CATEGORY FILTER
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

                // SORT
                ProductFilterBar(
                  value: selectedSort,
                  items: sortOptions,
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
                  hintText: "Sort Price",
                ),
                const SizedBox(height: 10),

                // PRODUCT LIST
                Expanded(
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
                                    builder: (_) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            );
                          },
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
