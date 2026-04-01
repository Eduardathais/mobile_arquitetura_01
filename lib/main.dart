import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/pages/initial_page.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/product_list_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final ProductRepository repository = await createDefaultProductRepository();

  runApp(
    ChangeNotifierProvider<ProductListViewModel>(
      create: (_) => ProductListViewModel(repository: repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialPage(),
        '/products': (context) => const ProductPage(),
      },
    );
  }
}
