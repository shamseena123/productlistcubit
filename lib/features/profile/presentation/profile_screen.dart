import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list_app/core/storage/local_storage_services.dart';

import 'package:product_list_app/features/address/data/logic/address_cubit.dart';
import 'package:product_list_app/features/address/presentation/screens/address_screen.dart';

import 'package:product_list_app/features/auth/logic/cubit/auth_cubit.dart';
import 'package:product_list_app/features/orders/presentation/order_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    final storage = context.read<AuthCubit>().storageService;

    final savedEmail = await storage.getString("currentUser");

    setState(() {
      email = savedEmail ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 40),
                ),

                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(email, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.add_location_alt),

                title: const Text("Add Address"),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddressScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressLoaded && state.addresses.isNotEmpty) {
                  final address = state.addresses.last;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Text(
                            "Saved Address",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            address.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(address.phone),

                          const SizedBox(height: 5),

                          Text(address.street),

                          Text(address.city),

                          Text(address.pincode),
                        ],
                      ),
                    ),
                  );
                }

                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No address saved"),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.shopping_bag),

                title: const Text(
                  "My orders",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrdersScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            ///  LOGOUT
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),

                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                onTap: () async {
                  final storage = LocalStorageServices();
  await context.read<AuthCubit>().logout();

 
  await storage.removeData("currentUser");

  context.read<AddressCubit>().reset();
}
              ),
            ),
          ],
        ),
      ),
    );
  }
}
