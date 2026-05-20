import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodels/product_list_viewmodel.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do produto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Product>(
        future: viewModel.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Produto não encontrado'));
          }

          final product = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 260),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.thumbnail,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            width: double.infinity,
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            alignment: Alignment.center,
                            child:
                                const Icon(Icons.image_not_supported, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Preço: \$${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Categoria: ${product.category}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Avaliação: ${product.rating}  •  Estoque: ${product.stock}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
        },
      ),
    );
  }
}
