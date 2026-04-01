import 'package:product_app/domain/entities/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
