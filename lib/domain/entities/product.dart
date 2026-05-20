class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String thumbnail;
  final double rating;
  final int stock;
  final bool isFavorite;

  const Product({
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

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? thumbnail,
    double? rating,
    int? stock,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}