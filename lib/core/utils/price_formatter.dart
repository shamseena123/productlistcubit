class PriceFormatter {
  static String format(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }
}
