import 'package:flutter/material.dart';

class ProductFilterBar extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;
  final String hintText;

  const ProductFilterBar({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),

      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
