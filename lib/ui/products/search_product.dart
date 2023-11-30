import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_detail_screen.dart';
import 'product_grid_tile.dart';
import 'products_manager.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({Key? key}) : super(key: key);

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  String _searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final productsManager = Provider.of<ProductsManager>(context);

    // Kiểm tra xem có từ khóa tìm kiếm nào không
    final bool hasSearchQuery = _searchQuery.isNotEmpty;

    // Lọc sản phẩm dựa trên từ khóa tìm kiếm nếu có
    final filteredProducts =
        hasSearchQuery ? productsManager.searchProducts(_searchQuery) : [];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm sản phẩm',
            fillColor: Colors.grey[100],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.clear),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
            ),
            contentPadding: const EdgeInsets.fromLTRB(10.0, 12.0, 15.0, 12.0),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
      body: hasSearchQuery
          ? (filteredProducts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: Column(
                    children: <Widget>[
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "SEARCH'S RESULT",
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
                          itemCount: filteredProducts.length,
                          itemBuilder: (ctx, i) {
                            final product = filteredProducts[i];
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
                                        product.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                      color: product.isFavorite
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
                                        arguments: product.id,
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
                                              padding: const EdgeInsets.only(
                                                  top: 15),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.amber,
                                                radius: 58.0,
                                                child: Image.network(
                                                  product.imageUrl,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "\$${product.price}",
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
                          },
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
                            'assets/images/search.png'),
                        width: 240,
                      ),
                      SizedBox(height: 25),
                      Center(
                        child: Text(
                          "Not Found",
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
                            "No matching results were found. Please try again!",
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
                ))
          : const SizedBox(), // Ẩn danh sách sản phẩm khi chưa nhập từ khóa tìm kiếm
    );
  }
}
