import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/datasources/product_local_datasource.dart';
import 'package:product_app/domain/entities/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductLocalDatasource local;

  ProductRepositoryImpl(this.remote, this.local);

  ProductModel _modelWithFavorite(ProductModel m, bool isFavorite) {
    return ProductModel(
      id: m.id,
      title: m.title,
      price: m.price,
      description: m.description,
      category: m.category,
      image: m.image,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await local.getAll();
      if (cached.isNotEmpty) {
        return cached.map((m) => m.toEntity()).toList();
      }
    }

    try {
      final models = await remote.getProducts();
      await local.saveAll(models);
    } catch (_) {
      final fallback = await local.getAll();
      if (fallback.isNotEmpty) {
        return fallback.map((m) => m.toEntity()).toList();
      }
      return [];
    }

    final all = await local.getAll();
    return all.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final payload = ProductModel.fromEntity(product);
    try {
      final remoteCreated = await remote.createProduct(payload);
      final toSave = _modelWithFavorite(remoteCreated, product.isFavorite);
      await local.upsert(toSave);
      return toSave.toEntity();
    } catch (_) {
      final localId = -DateTime.now().millisecondsSinceEpoch;
      final offline = ProductModel(
        id: localId,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        isFavorite: product.isFavorite,
      );
      await local.upsert(offline);
      return offline.toEntity();
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final payload = ProductModel.fromEntity(product);
    try {
      if (product.id < 0) {
        await local.upsert(payload);
        return product;
      }
      final remoteUpdated = await remote.updateProduct(payload);
      final toSave = _modelWithFavorite(remoteUpdated, product.isFavorite);
      await local.upsert(toSave);
      return toSave.toEntity();
    } catch (_) {
      await local.upsert(payload);
      return product;
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      if (productId >= 0) {
        await remote.deleteProduct(productId);
      }
    } catch (_) {}
    await local.deleteById(productId);
  }

  @override
  Future<void> setProductFavorite(int productId, bool isFavorite) async {
    await local.setFavorite(productId, isFavorite);
  }
}
