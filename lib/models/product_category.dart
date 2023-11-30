class ProductCategory {
  final String? id;
  final String name;
  final String imageUrl;

  ProductCategory({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  ProductCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  static ProductCategory fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }
}
