import 'package:flutter/material.dart';
import 'package:product_list_app/screens/product_detail_screen.dart';
import 'package:product_list_app/widgets/product_card.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> futureProducts;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProduct = [];

  String selectedCategory = "All";

  List<String> categories = ["All"];

  String selectedSort = "None";

  List<String> sortOptions = ["None", "Low to High", "High to Low"];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService().fetchProducts();
  }

  void searchProducts(String query) {
    setState(() {
      filteredProduct = allProducts.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void filteredCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        filteredProduct = allProducts;
      } else {
        filteredProduct = allProducts.where((product) {
          return product.category == category;
        }).toList();
      }
    });
  }

  void sortProducts(String option) {
    setState(() {
      selectedSort = option;
      if (option == "Low to High") {
        filteredProduct.sort((a, b) => a.price.compareTo(b.price));
      } else if (option == "High to Low") {
        filteredProduct.sort((a, b) => b.price.compareTo(a.price));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,

        centerTitle: true,
        title: const Text(
          "PRODUCTS",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        backgroundColor: const Color.fromARGB(255, 61, 120, 73),
      ),

      body: FutureBuilder<List<ProductModel>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text("Error:${snapshot.error}"),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureProducts = ApiService().fetchProducts();
                      });
                    },
                    child: const Text("retry"),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: Text("No product found"));
          }
          final products = snapshot.data!;

          if (allProducts.isEmpty) {
            allProducts = products;
            filteredProduct = products;

            categories = [
              "All",
              ...products.map((p) => p.category).toSet().toList(),
            ];
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),

                child: TextField(
                  controller: searchController,

                  onChanged: searchProducts,

                  decoration: InputDecoration(
                    hintText: "Search Products",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField(
                  initialValue: selectedCategory,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,

                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    filteredCategory(value!);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField(
                  initialValue: selectedSort,

                  decoration: InputDecoration(
                    hintText: "Sort price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: sortOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  onChanged: (value) {
                    sortProducts(value!);
                  },
                ),
              ),

              Expanded(
                child: filteredProduct.isEmpty
                    ? const Center(child: Text("No product found"))
                    : ListView.builder(
                        itemCount: filteredProduct.length,

                        itemBuilder: (context, index) {
                          final product = filteredProduct[index];

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
        },
      ),
    );
  }
}
