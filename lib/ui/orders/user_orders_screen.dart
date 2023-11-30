import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orders_manager.dart';
import 'order_item_card.dart';
import '../../models/order_item.dart';
import '../shared/app_drawer.dart';

import 'package:snackstore/ui/cart/cart_screen.dart';

import '../cart/cart_manager.dart';
import '../products/top_right_badge.dart';

class UserOrdersScreen extends StatefulWidget {
  static const routeName = '/user-orders';

  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    _fetchOrders = context.read<OrdersManager>().fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 0),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 28.0),
          child: Text(
            'MY ORDER',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          buildShoppingCartIcon(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchOrders,
        builder: (context, snapshot) {
          final orders = context.select<OrdersManager, List<OrderItem>>(
              (ordersManager) => ordersManager.orders);
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (ctx, i) => OrderItemCard(orders[i]),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildShoppingCartIcon(context) {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: const Icon(
              Icons.shopping_cart,
            ),
            color: Colors.black,
          ),
        );
      },
    );
  }
}
