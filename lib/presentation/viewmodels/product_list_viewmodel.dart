import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:product_app/core/network/client_http.dart';
import 'package:product_app/data/datasources/product_local_datasource.dart';
import 'package:product_app/data/datasources/product_local_sqlite_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/states/product_state.dart';

class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel({required ProductRepository repository})
      : _repository = repository;

  final ProductRepository _repository;

  ProductState _state = const ProductState();
  ProductState get state => _state;

  int get favoriteCount =>
      _state.products.where((p) => p.isFavorite).length;

  void _emit(ProductState next) {
    _state = next;
    notifyListeners();
  }

  Future<void> loadProducts({bool forceRefresh = false}) async {
    _emit(_state.copyWith(isLoading: true));
    final products =
        await _repository.getProducts(forceRefresh: forceRefresh);
    _emit(_state.copyWith(isLoading: false, products: products));
  }

  Future<void> createProduct(Product product) async {
    final createdProduct = await _repository.createProduct(product);
    _emit(_state.copyWith(
      products: [createdProduct, ..._state.products],
    ));
  }

  Future<void> updateProduct(Product product) async {
    final updatedProduct = await _repository.updateProduct(product);
    _emit(_state.copyWith(
      products: _state.products
          .map((item) => item.id == updatedProduct.id ? updatedProduct : item)
          .toList(),
    ));
  }

  Future<void> removeProduct(int productId) async {
    await _repository.deleteProduct(productId);
    _emit(_state.copyWith(
      products: _state.products.where((item) => item.id != productId).toList(),
    ));
  }

  void toggleFavorite(int productId) {
    final updated = _state.products
        .map((p) =>
            p.id == productId ? p.copyWith(isFavorite: !p.isFavorite) : p)
        .toList();
    _emit(_state.copyWith(products: updated));
    final p = updated.firstWhere((x) => x.id == productId);
    unawaited(_repository.setProductFavorite(productId, p.isFavorite));
  }
}

Future<ProductRepository> createDefaultProductRepository() async {
  final client = HttpClient();
  final remote = ProductRemoteDatasource(client);
  late final ProductLocalDatasource local;
  if (kIsWeb) {
    local = ProductLocalDatasourceInMemory();
  } else {
    try {
      local = await ProductLocalSqliteDatasource.open();
    } catch (_) {
      local = ProductLocalDatasourceInMemory();
    }
  }
  return ProductRepositoryImpl(remote, local);
}
