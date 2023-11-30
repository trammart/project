//
import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../models/order_item.dart';
import '../../models/auth_token.dart';

import '../../services/orders_service.dart';

class OrdersManager with ChangeNotifier {
  List<OrderItem> _orders = [];

  final OrdersService _ordersService;

  OrdersManager([AuthToken? authToken])
      : _ordersService = OrdersService(authToken);

  set authToken(AuthToken? authToken) {
    _ordersService.authToken = authToken;
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchUserOrders([bool filterByUser = true]) async {
    _orders = await _ordersService.fetchOrders(filterByUser);
    notifyListeners();
  }

  Future<void> fetchOrders([bool filterByUser = false]) async {
    _orders = await _ordersService.fetchOrders(filterByUser);
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      double shipping, String phone) async {
    final order = OrderItem(
      // id: 'o${DateTime.now().toIso8601String()}',
      total: total,
      shipping: shipping,
      products: cartProducts,
      dateTime: DateTime.now(),
      phone: phone,
      isDelivery: false,
    );
    final newProduct = await _ordersService.addOrder(order);
    if (newProduct != null) {
      _orders.insert(
        0,
        OrderItem(
          id: 'o${DateTime.now().toIso8601String()}',
          total: total,
          shipping: shipping,
          products: cartProducts,
          dateTime: DateTime.now(),
          phone: phone,
          isDelivery: false,
        ),
      );

      notifyListeners();
    }
  }

  Future<void> updateDeliveryStatus(String orderId) async {
    if (await _ordersService.updateDeliveryStatus(orderId)) {
      final index = orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        _orders[index].isDelivery = true;
        notifyListeners();
      }
    }
  }
}
