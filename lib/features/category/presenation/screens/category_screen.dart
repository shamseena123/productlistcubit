import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/category/widget/product_card_categ.dart';
import 'package:product_list_app/features/products/logic/cubit/product_cubit.dart';
import 'package:product_list_app/features/products/logic/cubit/product_state.dart';
import 'package:product_list_app/features/products/presentation/screens/product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = "All";
  String selectedSort = "None";

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "CATEGORIES",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          if (state is ProductLoaded) {
            /// ✅ safe category generation (NO mutation)
            final categories = [
              "All",
              ...state.products.map((e) => e.category).toSet(),
            ];

            final products = state.filteredProducts;

            return Column(
              children: [
                /// SEARCH + SORT
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      /// SEARCH
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            context.read<ProductCubit>().searchProducts(value);
                          },
                          decoration: const InputDecoration(
                            hintText: "Search products...",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// SORT
                      DropdownButton<String>(
                        value: selectedSort,
                        items: const [
                          DropdownMenuItem(value: "None", child: Text("None")),
                          DropdownMenuItem(
                            value: "Low to High",
                            child: Text("Low to High"),
                          ),
                          DropdownMenuItem(
                            value: "High to Low",
                            child: Text("High to Low"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => selectedSort = value!);

                          if (value == "Low to High") {
                            context.read<ProductCubit>().sortLowToHigh();
                          } else if (value == "High to Low") {
                            context.read<ProductCubit>().sortHighToLow();
                          } else {
                            context.read<ProductCubit>().resetFilters();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return ListTile(
                              dense: true,
                              selected: selectedCategory == category,
                              title: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedCategory == category
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });

                                context.read<ProductCubit>().filteredCategory(
                                  category,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      Expanded(
                        child: products.isEmpty
                            ? const Center(child: Text("No products found"))
                            : GridView.builder(
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.72,
                                    ),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  return ProductCardCategory(
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
                                      // navigate to details page
                                    },
                                  );
                                },
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
