import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/core/network/client_http.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/states/product_state.dart';

final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient();
});

final productRemoteDatasourceProvider = Provider<ProductRemoteDatasource>((ref) {
  final client = ref.watch(httpClientProvider);
  return ProductRemoteDatasource(client);
});

final productCacheDatasourceProvider = Provider<ProductCacheDatasource>((ref) {
  return ProductCacheDatasourceImpl();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remote = ref.watch(productRemoteDatasourceProvider);
  final cache = ref.watch(productCacheDatasourceProvider);
  return ProductRepositoryImpl(remote, cache);
});

class ProductListNotifier extends StateNotifier<ProductState> {
  final ProductRepository repository;

  ProductListNotifier(this.repository) : super(const ProductState());

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await repository.getProducts();
      state = state.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void toggleFavorite(int productId) {
    final updated = state.products
        .map((p) => p.id == productId
            ? p.copyWith(isFavorite: !p.isFavorite)
            : p)
        .toList();
    state = state.copyWith(products: updated);
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductState>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductListNotifier(repo);
});

extension ProductStateX on ProductState {
  int get favoriteCount =>
      products.where((p) => p.isFavorite).length;
}
