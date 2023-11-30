import 'package:flutter/material.dart';
import 'package:snackstore/ui/cart/order_success.dart';
import 'package:snackstore/ui/orders/orders_manager.dart';
import 'package:provider/provider.dart';

import 'cart_manager.dart';
import 'cart_item_card.dart';

//import '../shared/dialog_utils.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  final double shipping = 2.5;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            'MY CART',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: cart.productEntries.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: buildCartDetails(cart),
                  ),
                  const SizedBox(height: 10),
                  buildCartSummary(cart, context),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: buildCartOrderNowButton(cart, context),
                  ),
                ],
              ),
            )
          : const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage(
                        'assets/images/snack-store-empty-favorite.png'),
                    width: 240,
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: Text(
                      "Your Cart is Empty",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        "Looks like you haven't added anthing to your cart yet.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ElevatedButton buildCartOrderNowButton(
      CartManager cart, BuildContext context) {
    return ElevatedButton(
      onPressed: cart.totalAmount <= 0
          ? null
          : () async {
              final phoneController = TextEditingController();
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Enter your phone number',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: "We'll contact you via this phone number",
                        floatingLabelStyle: TextStyle(color: Colors.black)),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Cancle',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        bool isPhoneNumberValid = false;
                        if (phoneController.text.isNotEmpty &&
                            RegExp(r'^\d{10}$')
                                .hasMatch(phoneController.text)) {
                          isPhoneNumberValid = true;
                        }
                        if (isPhoneNumberValid) {
                          final orderManager = context.read<OrdersManager>();
                          await orderManager.addOrder(
                            cart.products,
                            cart.totalAmount + shipping,
                            shipping,
                            phoneController.text,
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.of(ctx).pop(true);
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (context) => const OrderSuccessDialogue(),
                          );
                          // context.read<OrdersManager>().addOrder(
                          //       cart.products,
                          //       cart.totalAmount + shipping,
                          //       shipping,
                          //     );
                          cart.clearAllItems();
                        } else {
                          // Hiển thị thông báo khi số điện thoại không hợp lệ
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Invalid phone number. Please try again!'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.amber[700],
        textStyle: TextStyle(
          color: Theme.of(context).primaryTextTheme.titleLarge?.color,
        ),
        minimumSize: const Size(350, 50),
      ),
      child: const Text(
        'Order Now',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: cart.productEntries
              .map(
                (entry) => CartItemCard(
                  productId: entry.key,
                  cardItem: entry.value,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Sub Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Shipping',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      cart.totalAmount > 0
                          ? '\$${shipping.toStringAsFixed(2)}'
                          : '\$${0.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Divider(
                  height: 25,
                  thickness: 1,
                  indent: 3,
                  endIndent: 3,
                  color: Colors.black12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Text(
                      cart.totalAmount > 0
                          ? '\$${(cart.totalAmount + shipping).toStringAsFixed(2)}'
                          : '\$${(cart.totalAmount + 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
