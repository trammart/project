import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/models/product.dart';

import 'package:snackstore/ui/categories/filter_screen.dart';
import 'package:snackstore/ui/products/product_detail_screen.dart';
import 'package:snackstore/ui/products/products_manager.dart';

class ExploreScreen extends StatefulWidget {
  static const routeName = '/explore';

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<String> selectedCategories = [];
  SortOrder? _currentSortOrder;

  @override
  void initState() {
    super.initState();
    final productsManager = context.read<ProductsManager>();
    _currentSortOrder = null;
    productsManager.setOriginalItems(productsManager.items);
  }

  @override
  Widget build(BuildContext context) {
    final productsManager = context.read<ProductsManager>();
    var products = productsManager.items;

    if (selectedCategories.isNotEmpty) {
      // Lọc danh sách sản phẩm nếu có danh mục được chọn từ FilterScreen
      products = products
          .where((product) => selectedCategories.contains(product.category))
          .toList();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSortOptions(),
                GestureDetector(
                  onTap: () async {
                    final filter = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterScreen()),
                    );

                    if (filter != null) {
                      setState(() {
                        selectedCategories = filter.cast<String>();
                        _currentSortOrder = null;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: const Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
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
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.black45,
                                onPressed: () {
                                  productsManager
                                      .toggleFavoriteStatus(products[i]);
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 4 / 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSortOptions() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text('Sort by Price: '),
        ),
        DropdownButton<SortOrder?>(
          value: _currentSortOrder,
          onChanged: (SortOrder? newValue) {
            setState(() {
              if (newValue == null) {
                setState(() {
                  _currentSortOrder = null;
                  context.read<ProductsManager>().setSortOrder(null);
                });
              } else {
                _currentSortOrder = newValue;
                // Gọi hàm để cập nhật danh sách sản phẩm
                context
                    .read<ProductsManager>()
                    .setSortOrder(_currentSortOrder!);
              }
            });
          },
          items: const [
            DropdownMenuItem(
              value: null,
              child: Text('Default'),
            ),
            DropdownMenuItem(
              value: SortOrder.lowToHigh,
              child: Text('Low to High'),
            ),
            DropdownMenuItem(
              value: SortOrder.highToLow,
              child: Text('High to Low'),
            ),
          ],
        ),
      ],
    );
  }
}
