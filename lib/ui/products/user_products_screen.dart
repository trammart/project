import 'package:flutter/material.dart';
import 'package:snackstore/ui/screens.dart';
import 'package:provider/provider.dart';

import 'user_product_list_tile.dart';
import 'products_manager.dart';
import '../shared/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsManager = ProductsManager();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Products Management'),
          centerTitle: true,
          actions: <Widget>[
            buildAddButton(context),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: context.read<ProductsManager>().fetchProducts(false),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ProductsManager>().fetchProducts(false),
                child: buildUserProductListView(productsManager),
              );
            }));
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
      icon: const Icon(Icons.add),
    );
  }

  Widget buildUserProductListView(ProductsManager productsManager) {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        //Kiểm tra sản phẩm rỗng bằng cách ghi chữ hoặc thêm hình
        if (productsManager.itemCount == 0) {
          return const Center(
            child: Text('Cửa hàng chưa có sản phẩm nào!!!'),
          );
        }
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 10.0),
                child: UserProductListTile(
                  productsManager.items[i],
                ),
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
