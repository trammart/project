import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'orders_manager.dart';
import 'order_item_card.dart';
import '../../models/order_item.dart';
import '../shared/app_drawer.dart';

import 'package:snackstore/ui/cart/cart_screen.dart';

import '../cart/cart_manager.dart';
import '../products/top_right_badge.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    _fetchOrders = context.read<OrdersManager>().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Management'),
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
