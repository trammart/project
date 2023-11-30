import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_category.dart';
import '../models/auth_token.dart';

import 'firebase_service.dart';

class CategoriesService extends FirebaseService {
  CategoriesService([AuthToken? authToken]) : super(authToken);

  Future<List<ProductCategory>> fetchCategories([bool filterByUser = false]) async {
    final List<ProductCategory> categories = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final categoriesUrl =
          Uri.parse('$databaseUrl/categories.json?auth=$token&$filters');
      final response = await http.get(categoriesUrl);
      final categoriesMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(categoriesMap['error']);
        return categories;
      }

      categoriesMap.forEach((categoryId, category) {
        categories.add(
          ProductCategory.fromJson({
            'id': categoryId,
            ...category,
          }),
        );
      });

      return categories;
    } catch (error) {
      print(error);
      return categories;
    }
  }

  Future<ProductCategory?> addCategory(ProductCategory category) async {
    try {
      final url = Uri.parse('$databaseUrl/categories.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          category.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return category.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateCategory(ProductCategory category) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/categories/${category.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(
          category.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/categories/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
