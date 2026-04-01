import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:product_app/core/network/client_http.dart';
import 'package:product_app/data/datasources/product_local_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/main.dart';
import 'package:product_app/presentation/viewmodels/product_list_viewmodel.dart';

void main() {
  testWidgets('Tela inicial exibe ação para produtos', (WidgetTester tester) async {
    final repository = ProductRepositoryImpl(
      ProductRemoteDatasource(HttpClient()),
      ProductLocalDatasourceInMemory(),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<ProductListViewModel>(
        create: (_) => ProductListViewModel(repository: repository),
        child: const MyApp(),
      ),
    );

    expect(find.text('Ver produtos'), findsOneWidget);
  });
}
