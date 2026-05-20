import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'package:product_app/presentation/pages/login_page.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
