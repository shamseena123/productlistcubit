import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:product_list_app/features/cart/logic/cart_cubit.dart';
import 'package:product_list_app/features/cart/logic/cart_state.dart';
import 'package:product_list_app/features/cart/presentation/cart_screen.dart';

import 'package:product_list_app/features/products/presentation/screens/home_screen.dart';

import 'package:product_list_app/features/whislist/logic/wishlist_cubit.dart';
import 'package:product_list_app/features/whislist/logic/wishlist_state.dart';
import 'package:product_list_app/features/whislist/presentation/screens/wishlist_screen.dart';
import 'package:product_list_app/features/profile/presentation/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(), // Home
   
    const WishlistScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          /// HOME
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          
          /// WISHLIST WITH BADGE
          BottomNavigationBarItem(
            icon: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                int count = 0;

                if (state is WishListUpdated) {
                  count = state.items.length;
                }

                return Stack(
                  children: [
                    const Icon(Icons.favorite),

                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: "Wishlist",
          ),

          /// CART WITH BADGE
          BottomNavigationBarItem(
            icon: BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                int count = 0;

                if (state is CartUpdated) {
                  count = state.items.length;
                }

                return Stack(
                  children: [
                    const Icon(Icons.shopping_cart),

                    if (count > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: "Cart",
          ),

          /// PROFILE
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
