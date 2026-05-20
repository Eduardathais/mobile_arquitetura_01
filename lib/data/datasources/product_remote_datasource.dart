import 'dart:convert';
import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/core/network/client_http.dart';

class ProductRemoteDatasource {
  final HttpClient client;
  static const _baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(_baseUrl);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Failure(
        'Não foi possível buscar os produtos (HTTP ${response.statusCode}). '
        'O serviço dummyjson.com pode estar temporariamente indisponível; '
        'tente de novo em alguns minutos.',
      );
    }

    try {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List productsJson = data['products'] as List;
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Failure('Resposta inválida da API de produtos: $e');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get('$_baseUrl/$id');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Failure('Produto não encontrado (HTTP ${response.statusCode})');
    }

    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductModel.fromJson(data);
    } catch (e) {
      throw Failure('Resposta inválida da API de produto: $e');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await client.post(
      '$_baseUrl/add',
      body: product.toJson(),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Failure('Falha ao criar produto no serviço remoto');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ProductModel.fromJson(data);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      '$_baseUrl/${product.id}',
      body: product.toJson(),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Failure('Falha ao atualizar produto no serviço remoto');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ProductModel.fromJson(data);
  }

  Future<void> deleteProduct(int productId) async {
    final response = await client.delete('$_baseUrl/$productId');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Failure('Falha ao remover produto no serviço remoto');
    }
  }
}
