//
import 'package:flutter/material.dart';
import 'package:snackstore/ui/cart/cart_screen.dart';
import 'package:snackstore/ui/categories/explore_screen.dart';
import 'package:snackstore/ui/categories/filter_screen.dart';
import 'package:snackstore/ui/products/product_homepage_screen.dart';
import 'package:snackstore/ui/products/products_manager.dart';
import 'package:snackstore/ui/products/product_favorite_screen.dart';
import 'package:provider/provider.dart';

import '../auth/auth_manager.dart';
import 'products_grid.dart';
import '../shared/app_drawer.dart';

import '../cart/cart_manager.dart';
import 'search_product.dart';
import 'top_right_badge.dart';

import '../user/user_profile.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;
  static late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _fetchProducts = context.read<ProductsManager>().fetchProducts();

    _pages = <Widget>[
      FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<bool>(
                valueListenable: _showOnlyFavorites,
                builder: (context, onlyFavorites, child) {
                  return const ProductHomePageScreen();
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      const ExploreScreen(),
      FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _showOnlyFavorites.value = true;
            return ValueListenableBuilder<bool>(
                valueListenable: _showOnlyFavorites,
                builder: (context, onlyFavorites, child) {
                  return ProductFavoriteScreen(onlyFavorites);
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      const UserProfile(),
    ];
  }

  int _cardIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _cardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthManager>().authToken!.userId ==
        'YXbO1Ms39wOYdhsPrCRlpGuY9Qr1';
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchProduct(),
              ),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Tìm kiếm sản phẩm',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          buildShoppingCartIcon(),
        ],
      ),
      drawer: isAdmin ? const AppDrawer() : null,
      body: _pages[_cardIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _cardIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        setState(() {
          if (selectedValue == FilterOptions.favorites) {
            _showOnlyFavorites.value = true;
          } else {
            _showOnlyFavorites.value = false;
          }
        });
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }

  Widget buildShoppingCartIcon() {
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
          ),
        );
      },
    );
  }
}
