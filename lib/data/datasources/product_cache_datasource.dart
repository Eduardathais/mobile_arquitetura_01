import 'package:product_app/data/models/product_model.dart';

abstract class ProductCacheDatasource {
  Future<void> save(List<ProductModel> products);
  List<ProductModel>? get();
}

class ProductCacheDatasourceImpl implements ProductCacheDatasource {
  List<ProductModel>? _cachedProducts;

  @override
  Future<void> save(List<ProductModel> products) async {
    _cachedProducts = products;
  }

  @override
  List<ProductModel>? get() {
    return _cachedProducts;
  }
}