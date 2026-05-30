import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/logic/address_cubit.dart';
import '../../data/models/address_model.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  void saveAddress() {
    final address = AddressModel(
      name: nameController.text,
      phone: phoneController.text,
      street: streetController.text,
      city: cityController.text,
      pincode: pincodeController.text,
    );

    context.read<AddressCubit>().saveAddress(address);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Address Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address')),

      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoaded && state.address != null) {
            final address = state.address!;

            nameController.text = address.name;
            phoneController.text = address.phone;
            streetController.text = address.street;
            cityController.text = address.city;
            pincodeController.text = address.pincode;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: saveAddress,
                  child: const Text('Save Address'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
