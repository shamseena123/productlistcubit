import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';
import 'package:product_list_app/features/address/data/logic/address_cubit.dart';

import 'package:product_list_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:product_list_app/features/orders/logic/orders_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final LocalStorageServices storageService = LocalStorageServices();
  String? emailError;
  String? passwordError;

  final emailController = TextEditingController();

  final passwordContoller = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "LOGIN ",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter Email",
                border: OutlineInputBorder(),
                errorText: emailError,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: passwordContoller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter Password",
                border: OutlineInputBorder(),
                errorText: passwordError,
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final password = passwordContoller.text.trim();

                  setState(() {
                    emailError = null;
                    passwordError = null;
                  });

                  if (!isValidEmail(email)) {
                    setState(() {
                      emailError =
                          "Enter valid email (example: test@gmail.com)";
                    });
                    return;
                  }

                  if (!isValidPassword(password)) {
                    setState(() {
                      passwordError =
                          "Password must be 6+ chars with letter & number";
                    });
                    return;
                  }

                  await context.read<AuthCubit>().login(email);

                  await storageService.saveString("currentUser", email);

context.read<AddressCubit>().initializeUserAddresses();
context.read<OrdersCubit>().loadOrders(email);
                },
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
