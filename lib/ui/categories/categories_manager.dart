import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../models/product_category.dart';
import '../../services/categories_service.dart';

class CategoriesManager with ChangeNotifier {
  List<ProductCategory> _items = [];

  final CategoriesService _categoriesService;

  CategoriesManager([AuthToken? authToken])
      : _categoriesService = CategoriesService(authToken);

  set authToken(AuthToken? authToken) {
    _categoriesService.authToken = authToken;
  }

  Future<void> fetchCategories([bool filterByUser = false]) async {
    _items = await _categoriesService.fetchCategories(filterByUser);
    notifyListeners();
  }

  Future<void> addCategory(ProductCategory category) async {
    final newCategory = await _categoriesService.addCategory(category);
    if (newCategory != null) {
      _items.add(newCategory);
      notifyListeners();
    }
  }

  Future<void> updateCategory(ProductCategory category) async {
    final index = _items.indexWhere((item) => item.id == category.id);
    if (index >= 0) {
      if (await _categoriesService.updateCategory(category)) {
        _items[index] = category;
        notifyListeners();
      }
    }
  }

  Future<void> deleteCategory(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    ProductCategory? existingCategory = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _categoriesService.deleteCategory(id)) {
      _items.insert(index, existingCategory);
      notifyListeners();
    }
  }

  List<ProductCategory> searchCategories(String keyword) {
    return _items
        .where((category) =>
            category.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  int get itemCount {
    return _items.length;
  }

  List<ProductCategory> get items {
    return [..._items];
  }

  ProductCategory? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
}
