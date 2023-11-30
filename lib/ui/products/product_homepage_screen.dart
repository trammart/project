import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'products_manager.dart';
import '../../models/product.dart';

import 'package:snackstore/ui/products/product_detail_screen.dart';

class ProductHomePageScreen extends StatelessWidget {
  const ProductHomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.select<ProductsManager, List<Product>>(
        (productsManager) => productsManager.items);
    final List<String> advertisements = [
      'https://vn-test-11.slatic.net/p/14530f7b3c208d533918098fe9910356.jpg',
      'https://www.laysvietnam.com/wp-content/uploads/2021/06/banner-lays-20210609-01.jpg',
      'https://vnn-imgs-f.vgcloud.vn/2019/07/30/15/gioi-tre-phu-vang-mang-xa-hoi-lan-toa-niem-vui-2.jpg',
    ];
    return SizedBox(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Good morning,",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Let's take a look at our products today.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 160,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: advertisements.map((imageUrl) {
                    return buildAdvertisementItem(imageUrl);
                  }).toList(),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Recommended",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  width: double.infinity,
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (ctx, i) {
                      return SizedBox(
                        width: 230,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Colors.amber[300],
                          margin: const EdgeInsets.all(10.0),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 7,
                                top: 5,
                                child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        products[i].isFavoriteListenable,
                                    builder: (ctx, isFavorite, child) {
                                      return IconButton(
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
                                              .toggleFavoriteStatus(
                                                  products[i]);
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Added product to your wishlist.',
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
                                      );
                                    }),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ProductDetailScreen.routeName,
                                    arguments: products[i].id,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 130,
                                          height: 170,
                                          child: Image.network(
                                            products[i].imageUrl,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            products[i].title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "\$${products[i].price}",
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "All Products",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Column(
                  children: products
                      .map(
                        (product) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: const EdgeInsets.only(bottom: 15.0),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                right: 15,
                                top: 10,
                                child: ValueListenableBuilder<bool>(
                                    valueListenable:
                                        product.isFavoriteListenable,
                                    builder: (ctx, isFavorite, child) {
                                      return IconButton(
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
                                              .toggleFavoriteStatus(product);
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.green,
                                                content: const Text(
                                                  'Added product to your wishlist.',
                                                ),
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
                                      );
                                    }),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ProductDetailScreen.routeName,
                                    arguments: product.id,
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 80,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            color: Colors.yellow[300],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                product.imageUrl,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 25),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            product.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "\$${product.price}",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdvertisementItem(String imageUrl) {
    return SizedBox(
      width: 350,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
