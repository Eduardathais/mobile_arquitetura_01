import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodels/product_list_viewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final Product? initialProduct;

  const ProductFormPage({
    super.key,
    this.initialProduct,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageController;
  bool _isSaving = false;

  bool get _isEdit => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    _titleController = TextEditingController(text: product?.title ?? '');
    _priceController = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _categoryController = TextEditingController(text: product?.category ?? '');
    _imageController = TextEditingController(text: product?.thumbnail ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);
    final viewModel = context.read<ProductListViewModel>();

    try {
      final product = Product(
        id: widget.initialProduct?.id ?? 0,
        title: _titleController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        thumbnail: _imageController.text.trim(),
        isFavorite: widget.initialProduct?.isFavorite ?? false,
      );

      if (_isEdit) {
        await viewModel.updateProduct(product);
      } else {
        await viewModel.createProduct(product);
      }

      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _isEdit ? 'Produto atualizado com sucesso' : 'Produto criado com sucesso',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit ? 'Erro ao atualizar produto' : 'Erro ao criar produto',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _requiredValidator(String? value, {String label = 'Campo'}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return '$label é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Editar produto' : 'Novo produto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) => _requiredValidator(value, label: 'Título'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Preço'),
              validator: (value) {
                final required = _requiredValidator(value, label: 'Preço');
                if (required != null) return required;
                final parsed = double.tryParse(value!.trim());
                if (parsed == null || parsed < 0) return 'Preço inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Categoria'),
              validator: (value) => _requiredValidator(value, label: 'Categoria'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'URL da imagem'),
              validator: (value) =>
                  _requiredValidator(value, label: 'URL da imagem'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 4,
              validator: (value) => _requiredValidator(value, label: 'Descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _submit,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isEdit ? 'Salvar alterações' : 'Cadastrar produto'),
            ),
          ],
        ),
      ),
    );
  }
}
