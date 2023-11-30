import 'package:flutter/material.dart';
import 'package:snackstore/models/product_category.dart';
import 'package:snackstore/ui/categories/categories_manager.dart';
import 'package:snackstore/ui/categories/edit_category_screen.dart';
import 'package:provider/provider.dart';


class CategoryListTile extends StatelessWidget {
  final ProductCategory category;

  const CategoryListTile(
    this.category,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(category.imageUrl),
        backgroundColor: Colors.yellow[300],
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            buildEditButton(context),
            buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildEditButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditCategoryScreen.routeName,
          arguments: category.id,
        );
      }, 
      icon: const Icon(Icons.edit),
      color: Theme.of(context).primaryColor,
    );
  }

  Widget buildDeleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<CategoriesManager>().deleteCategory(category.id!);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'Category deleted',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.green,
            ),
          );
      }, 
      icon: const Icon(Icons.delete),
      color: Theme.of(context).colorScheme.error,
    );
  }
}