import 'package:product_app/domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;
  final double rating;
  final int stock;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.thumbnail,
    this.rating = 0,
    this.stock = 0,
    this.isFavorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'Sem categoria',
      thumbnail: json['thumbnail'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as int?) ?? 0,
      isFavorite: false,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? 'Sem categoria',
      thumbnail: map['image'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      stock: (map['stock'] as int?) ?? 0,
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      thumbnail: thumbnail,
      rating: rating,
      stock: stock,
      isFavorite: isFavorite,
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      category: product.category,
      thumbnail: product.thumbnail,
      rating: product.rating,
      stock: product.stock,
      isFavorite: product.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'thumbnail': thumbnail,
    };
  }
}
