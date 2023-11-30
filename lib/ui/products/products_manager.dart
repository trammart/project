import 'package:flutter/foundation.dart';

import '../../models/auth_token.dart';
import '../../models/product.dart';
import '../../services/products_service.dart';

enum SortOrder { lowToHigh, highToLow }

class ProductsManager with ChangeNotifier {
  List<Product> _items = [];
  SortOrder? _currentSortOrder;
  List<Product> _originalItems = [];

  final ProductsService _productsService;

  ProductsManager([AuthToken? authToken])
      : _productsService = ProductsService(authToken);

  set authToken(AuthToken? authToken) {
    _productsService.authToken = authToken;
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    _items = await _productsService.fetchProducts(filterByUser);
    notifyListeners();
  }

  SortOrder? get currentSortOrder => _currentSortOrder;

  void setOriginalItems(List<Product> originalItems) {
    _originalItems = List.from(originalItems);
    print(_originalItems);
  }

  Future<void> setSortOrder(SortOrder? sortOrder) async {
    if (_currentSortOrder != sortOrder) {
      _currentSortOrder = sortOrder;
      await _sortProducts();
      notifyListeners();
    }
  }

  Future<void> _sortProducts() async {
    if (_currentSortOrder != null) {
      _items.sort((a, b) {
        if (_currentSortOrder == SortOrder.lowToHigh) {
          return a.price.compareTo(b.price);
        } else {
          return b.price.compareTo(a.price);
        }
      });
    } else {
      _items = List.from(_originalItems);
    }
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
      _items.add(newProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      if (await _productsService.updateProduct(product)) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Product? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _productsService.deleteProduct(id)) {
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  }

  Future<void> toggleFavoriteStatus(Product product) async {
    final savedStatus = product.isFavorite;
    product.isFavorite = !savedStatus;
    notifyListeners();

    if (!await _productsService.saveFavoriteStatus(product)) {
      product.isFavorite = savedStatus;
    }
  }

  List<Product> searchProducts(String keyword) {
    return _items
        .where((product) =>
            product.title.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (error) {
      return null;
    }
  }
}
