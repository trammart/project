import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/ui/orders/user_orders_screen.dart';

import '../auth/auth_manager.dart';

//import 'package:snackstore/ui/orders/orders_screen.dart';

import '../products/user_products_screen.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthManager>().authToken!.userId ==
        'YXbO1Ms39wOYdhsPrCRlpGuY9Qr1';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              backgroundImage: isAdmin
                  ? const AssetImage('assets/images/male-user-avatar.png')
                  : const AssetImage('assets/images/user-avatar.png'),
              radius: 55,
            ),
            const SizedBox(height: 10),
            Text(
              isAdmin ? 'Snack Store Admin' : 'Snack Store User',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Can Tho, Viet Nam',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 221, 180, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.shopping_bag_outlined),
                            ],
                          ),
                        ),
                        title: const Text('My Orders'),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UserOrdersScreen.routeName);
                        },
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 186, 220, 247),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.logout),
                            ],
                          ),
                        ),
                        title: const Text('Sign Out'),
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Sign Out Confirmation'),
                            content: const Text('Are you sure to sign out?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context, 'Cancel'),
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => {
                                  Navigator.pop(context, 'OK'),
                                  context.read<AuthManager>().logout(),
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
