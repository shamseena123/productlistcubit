import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/features/products/logic/cubit/product_cubit.dart';
import 'package:product_list_app/features/products/logic/cubit/product_state.dart';

import '../../../products/presentation/widgets/product_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = "All";
  String selectedSort = "None";

  final TextEditingController searchController = TextEditingController();

  List<String> categories = ["All"];

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
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
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            /// build categories from API
            categories = [
              "All",
              ...state.products.map((e) => e.category).toSet().toList(),
            ];

            return Column(
              children: [
                /// 🔍 SEARCH + SORT
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
                      /// 📂 CATEGORY LEFT PANEL
                      Container(
                        width: 120,
                        color: Colors.grey.shade200,
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];

                            return ListTile(
                              selected: selectedCategory == category,
                              title: Text(category),
                              onTap: () {
                                setState(() => selectedCategory = category);
                                context.read<ProductCubit>().filteredCategory(
                                  category,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      /// 📦 PRODUCT GRID
                      Expanded(
                        child: state.filteredProducts.isEmpty
                            ? const Center(child: Text("No products found"))
                            : GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.68,
                                    ),
                                itemCount: state.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = state.filteredProducts[index];

                                  return ProductCard(
                                    product: product,
                                    onTap: () {},
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
