import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_grid_tile.dart';
import 'products_manager.dart';
import 'package:snackstore/ui/products/product_detail_screen.dart';
import 'package:snackstore/ui/cart/cart_manager.dart';

import '../../models/product.dart';

class ProductFavoriteScreen extends StatelessWidget {
  final bool showFavorites;

  const ProductFavoriteScreen(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => productsManager.favoriteItems);

    return products.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
            child: Column(
              children: <Widget>[
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "YOUR WISHLIST",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: GridView.builder(
                    itemCount: products.length,
                    itemBuilder: (ctx, i) => ValueListenableBuilder<bool>(
                        valueListenable: products[i].isFavoriteListenable,
                        builder: (ctx, isFavorite, child) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: IconButton(
                                    icon: Icon(
                                      size: 28,
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    color: isFavorite
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.black45,
                                    onPressed: () {
                                      ctx
                                          .read<ProductsManager>()
                                          .toggleFavoriteStatus(products[i]);
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Removed product from your wishlist.',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration:
                                                const Duration(seconds: 2),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              textColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      ProductDetailScreen.routeName,
                                      arguments: products[i].id,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.yellow[300],
                                              radius: 58.0,
                                              child: Image.network(
                                                products[i].imageUrl,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            products[i].title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "\$${products[i].price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
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
                    "Your Wishlist is Empty",
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
                      "Looks like you haven't added anthing to your wishlist yet.",
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
          );
  }
}
