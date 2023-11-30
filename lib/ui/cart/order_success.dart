import 'package:flutter/material.dart';

import '../orders/user_orders_screen.dart';

class OrderSuccessDialogue extends StatelessWidget {
  const OrderSuccessDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        height: 600.0,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(
              flex: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Image.asset("assets/images/chip.jpg"),
            ),
            const Spacer(
              flex: 5,
            ),
            const Text(
              "Order Success!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(
              flex: 2,
            ),
            const Text(
              "We will contact as soon as possible",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff7C7C7C),
              ),
            ),
            const Spacer(
              flex: 4,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UserOrdersScreen.routeName);
              },
              child: const Text(
                "View orders",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
            ),
            const Spacer(
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
