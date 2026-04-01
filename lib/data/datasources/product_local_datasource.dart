import 'package:product_app/data/models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<void> saveAll(List<ProductModel> products);

  /// Lista ordenada por id (produtos só locais com id negativo permanecem após sync parcial).
  Future<List<ProductModel>> getAll();

  Future<ProductModel> upsert(ProductModel product);

  Future<void> deleteById(int id);

  /// Atualiza apenas o favorito (persistência local).
  Future<void> setFavorite(int productId, bool isFavorite);
}

class ProductLocalDatasourceInMemory implements ProductLocalDatasource {
  final List<ProductModel> _products = [];

  @override
  Future<void> saveAll(List<ProductModel> products) async {
    _products
      ..clear()
      ..addAll(products);
  }

  @override
  Future<List<ProductModel>> getAll() async {
    return List<ProductModel>.from(_products);
  }

  @override
  Future<ProductModel> upsert(ProductModel product) async {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _products[index] = product;
      return product;
    }

    _products.insert(0, product);
    return product;
  }

  @override
  Future<void> deleteById(int id) async {
    _products.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> setFavorite(int productId, bool isFavorite) async {
    final index = _products.indexWhere((item) => item.id == productId);
    if (index < 0) return;
    final p = _products[index];
    _products[index] = ProductModel(
      id: p.id,
      title: p.title,
      price: p.price,
      description: p.description,
      category: p.category,
      image: p.image,
      isFavorite: isFavorite,
    );
  }
}
