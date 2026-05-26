import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 61, 120, 73);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      centerTitle: true,
    ),
  );
}
