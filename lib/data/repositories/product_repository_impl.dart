import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    final models = await datasource.getProducts();
    return models
        .map((m) => Product(
              id: m.id,
              title: m.title,
              price: m.price,
              image: m.image,
            ))
        .toList();
  }
}