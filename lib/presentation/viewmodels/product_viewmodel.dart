import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:product_app/domain/entities/product.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<List<Product>> products = ValueNotifier([]);

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    final result = await repository.getProducts();
    products.value = result;
  }
}