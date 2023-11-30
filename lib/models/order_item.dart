//
//import 'dart:convert';

import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double total;
  final double shipping;
  final List<CartItem> products;
  final DateTime dateTime;
  final String phone;
  bool isDelivery;

  int get productCount {
    return products.length;
  }

  OrderItem({
    this.id,
    required this.total,
    required this.products,
    required this.shipping,
    DateTime? dateTime,
    required this.phone,
    this.isDelivery = false,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith({
    String? id,
    double? total,
    double? shipping,
    List<CartItem>? products,
    DateTime? dateTime,
    String? phone,
    bool? isDelivery,
  }) {
    return OrderItem(
      id: id ?? this.id,
      total: total ?? this.total,
      shipping: shipping ?? this.shipping,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
      phone: phone ?? this.phone,
      isDelivery: isDelivery ?? this.isDelivery,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'products': products,
      'shipping': shipping,
      'dateTime': dateTime.toIso8601String(),
      'phone': phone,
      'isDelivery': isDelivery,
    };
  }

  // fromJson
  static OrderItem fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      total: json['total'],
      shipping: json['shipping'],
      // products: json['products'].toList().cast<CartItem>(), // convert Map<String, dynamic> to List<CartItem>
      products: List<dynamic>.from(json['products'])
          .map((i) => CartItem.fromJson(i))
          .toList(),
      dateTime: DateTime.parse(
          json['dateTime']), // convert Map<String, dynamic> to DateTime
      phone: json['phone'],
      isDelivery: json['isDelivery'],
    );
  }
}
