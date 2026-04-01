import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/presentation/pages/product_form_page.dart';
import 'package:product_app/presentation/viewmodels/product_list_viewmodel.dart';
import 'package:product_app/presentation/pages/product_details_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductListViewModel>().loadProducts(forceRefresh: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();
    final state = viewModel.state;
    final favCount = viewModel.favoriteCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Products${favCount > 0 ? ' ($favCount fav${favCount > 1 ? 's' : ''})' : ''}'),
        actions: [
          IconButton(
            tooltip: 'Atualizar da API',
            onPressed: () => viewModel.loadProducts(forceRefresh: true),
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.products.isEmpty
              ? const SizedBox.expand()
              : ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsPage(product: product),
                          ),
                        );
                      },
                      tileColor: product.isFavorite
                          ? Colors.pink.withAlpha((0.2 * 255).round())
                          : null,
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        ),
                      ),
                      title: Text(product.title),
                      subtitle:
                          Text('\$${product.price} • ${product.category}'),
                      trailing: SizedBox(
                        width: 144,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar produto',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductFormPage(
                                      initialProduct: product,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              tooltip: 'Excluir produto',
                              onPressed: () async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) {
                                    return AlertDialog(
                                      title: const Text('Excluir produto'),
                                      content: Text(
                                        'Deseja excluir "${product.title}"?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        FilledButton(
                                          onPressed: () =>
                                              Navigator.pop(dialogContext, true),
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (shouldDelete == true) {
                                  try {
                                    await viewModel.removeProduct(product.id);
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Produto removido com sucesso'),
                                      ),
                                    );
                                  } catch (_) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Erro ao remover produto'),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                            IconButton(
                              icon: Icon(
                                product.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: product.isFavorite ? Colors.red : null,
                              ),
                              onPressed: () =>
                                  viewModel.toggleFavorite(product.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Novo produto',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProductFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
