import 'package:flutter/material.dart';
import 'package:snackstore/ui/categories/categories_manager.dart';
import 'package:snackstore/ui/categories/category_list_tile.dart';
import 'package:snackstore/ui/screens.dart';
import 'package:provider/provider.dart';

import '../shared/app_drawer.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/user-categories';

  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoriesManager = CategoriesManager();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories Management'),
          centerTitle: true,
          actions: <Widget>[
            buildAddButton(context),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: context.read<CategoriesManager>().fetchCategories(false),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<CategoriesManager>().fetchCategories(false),
                child: buildCategorytListView(categoriesManager),
              );
            }));
  }

  Widget buildAddButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditCategoryScreen.routeName,
        );
      },
      icon: const Icon(Icons.add),
    );
  }

  Widget buildCategorytListView(CategoriesManager categoriesManager) {
    return Consumer<CategoriesManager>(
      builder: (ctx, categoriesManager, child) {
        //Kiểm tra sản phẩm rỗng bằng cách ghi chữ hoặc thêm hình
        if (categoriesManager.itemCount == 0) {
          return const Center(
            child: Text('Cửa hàng chưa có loại sản phẩm nào!!!'),
          );
        }
        return ListView.builder(
          itemCount: categoriesManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: CategoryListTile(
                  categoriesManager.items[i],
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
