import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/ui/auth/auth_manager.dart';
import 'dart:math';
//import 'package:intl/intl.dart';

import '../../models/order_item.dart';
import 'orders_manager.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;
  bool isConfirmationVisible = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border:
                Border(left: BorderSide(color: Colors.amber[700]!, width: 7)),
          ),
          child: Column(
            children: <Widget>[
              buildOrderSummary(),
              if (_expanded) buildOrderDetails()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      height: min(widget.order.productCount * 20.0 + 10, 100),
      child: ListView(
        children: widget.order.products
            .map(
              (prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${prod.quantity}x \$${prod.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildOrderSummary() {
    // return ListTile(
    //   title: Text('\$${widget.order.total}'),
    //   subtitle: Text(
    //     DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
    //   ),
    //   trailing: IconButton(
    //     icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
    //     onPressed: () {
    //       setState(() {
    //         _expanded = !_expanded;
    //       });
    //     },
    //   ),
    // );
    final isAdmin = context.read<AuthManager>().authToken!.userId ==
        'YXbO1Ms39wOYdhsPrCRlpGuY9Qr1';
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // get first 8 characters from order id (removed '-')
                    'ID  \#${widget.order.id!.substring(1, 8)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    // get first 16 characters from order dateTime
                    widget.order.dateTime.toString().substring(0, 16),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${widget.order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 7,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.order.isDelivery
                        ? 'Đã vận chuyển'
                        : 'Chưa vận chuyển',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: TextButton(
              child: const Text(
                'ORDER DETAILS',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => {
                showModalBottomSheet(
                  context: context,
                  // backgroundColor: Colors.amber[200],
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 650,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Column(
                          children: <Widget>[
                            const Center(
                              child: Divider(
                                height: 50,
                                thickness: 5,
                                indent: 130,
                                endIndent: 130,
                                color: Colors.black12,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Your Order Details',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Products Details',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 20.0, 20.0, 0),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 200,
                                    ),
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        children: widget.order.products
                                            .map(
                                              (product) => Row(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Column(
                                                            children: <Widget>[
                                                              SizedBox(
                                                                height: 80,
                                                                width: 80,
                                                                child: Image
                                                                    .network(
                                                                  product
                                                                      .imageUrl,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                product.title,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    '\$${product.price.toStringAsFixed(2)}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 70,
                                                                  ),
                                                                  Text(
                                                                    'x ${product.quantity}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              margin: const EdgeInsets.all(0),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          'Sub Total',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${(widget.order.total - widget.order.shipping).toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          'Shipping',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${widget.order.shipping.toStringAsFixed(2)}',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text(
                                          'Total',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '\$${widget.order.total.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            isAdmin == true
                                ? Center(
                                    child: Text(
                                      'Contact: ${widget.order.phone}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            (widget.order.isDelivery == false &&
                                    isAdmin == true)
                                ? Center(
                                    child: isConfirmationVisible == true
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              final orderManager =
                                                  context.read<OrdersManager>();
                                              await orderManager
                                                  .updateDeliveryStatus(widget
                                                      .order.id as String);

                                              setState(() {
                                                // Set the flag to hide the confirmation button
                                                isConfirmationVisible = false;
                                              });

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(
                                                  const SnackBar(
                                                    content: Row(
                                                      children: [
                                                        Icon(Icons.check,
                                                            color:
                                                                Colors.white),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Đã duyệt đơn hàng thành công',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  ),
                                                );
                                            },
                                            child: const Text(
                                              'Delivery Confirmation',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Container(),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
