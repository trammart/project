import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/ui/screens.dart';

import '../auth/auth_manager.dart';
import '../orders/orders_screen.dart';
import '../products/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthManager>().authToken!.userId ==
        'YXbO1Ms39wOYdhsPrCRlpGuY9Qr1';
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage(
                  'https://www.laysvietnam.com/wp-content/uploads/2019/03/bg-yellow.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.05),
                  BlendMode.darken,
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                'STORE MANAGEMENT',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white, 
                ),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopify),
            title: const Text('Snack Store'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          isAdmin == true
              ? ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Products Management'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(UserProductsScreen.routeName);
                  },
                )
              : const SizedBox(),
          const Divider(),
          isAdmin == true
              ? ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: const Text('Categories Management'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(CategoryScreen.routeName);
                  },
                )
              : const SizedBox(),
          const Divider(),
          isAdmin == true
              ? ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Orders Management'),
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(OrdersScreen.routeName);
                  },
                )
              : const SizedBox(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
