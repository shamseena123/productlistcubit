import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const ProductSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: controller,

        onChanged: onChanged,

        decoration: InputDecoration(
          hintText: "Search products",
          prefixIcon: const Icon(Icons.search),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
