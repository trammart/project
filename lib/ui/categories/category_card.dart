import 'package:flutter/material.dart';
import 'package:snackstore/models/product_category.dart';

class ProductCategoryCardWidget extends StatelessWidget {
  const ProductCategoryCardWidget(
      {Key? key, required this.item, this.color = Colors.blue})
      : super(key: key);
  final ProductCategory item;

  final height = 200.0;
  final width = 175.0;
  final Color borderColor = const Color(0xffE2E2E2);
  final double borderRadius = 18;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.7),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: imageWidget(),
          ),
          SizedBox(
            height: 60,
            child: Center(
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return Image.asset(
      item.imageUrl,
      fit: BoxFit.contain,
    );
  }
}
