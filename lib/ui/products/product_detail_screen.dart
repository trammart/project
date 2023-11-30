import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'package:snackstore/ui/cart/cart_screen.dart';

import '../cart/cart_manager.dart';
import 'top_right_badge.dart';

import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen(this.product, {super.key});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _amount = 1;
  @override
  void initState() {
    super.initState();
  }

  void _increaseAmount() {
    setState(() {
      _amount++;
    });
  }

  void _decreaseAmount() {
    if (_amount > 1) {
      setState(() {
        _amount--;
      });
    } else {
      setState(() {
        _amount = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        elevation: 0.0,
        actions: <Widget>[
          buildShoppingCartIcon(context),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 130.0,
                child: Image.network(
                  widget.product.imageUrl,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                  _buildProductTitle(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInputNumber(),
                      _buildProductPrice(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProductWeight(),
                  const SizedBox(height: 15),
                  _buildProductAbout(),
                  const SizedBox(height: 20),
                  _buildAddToCartButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildProductPrice() {
    return Text(
      '\$${widget.product.price.toStringAsFixed(2)}',
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 28,
      ),
    );
  }

  Row _buildInputNumber() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _decreaseAmount,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            backgroundColor: Colors.amber[700],
          ),
          child: const Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        Text(
          _amount.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        ElevatedButton(
          onPressed: _increaseAmount,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            backgroundColor: Colors.amber[700],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row _buildAddToCartButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            final cart = context.read<CartManager>();
            cart.addItem(widget.product, _amount);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Item added to cart',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.white,
                    onPressed: () {
                      cart.removeItem(widget.product.id!, _amount);
                    },
                  ),
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
            minimumSize: const Size(300, 50),
          ),
          child: const Text(
            'Add To Cart',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildProductTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.product.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Row _buildProductWeight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Category:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          widget.product.category,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Column _buildProductAbout() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Text(
                widget.product.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
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
