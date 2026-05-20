import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/data/datasources/product_local_datasource.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalSqliteDatasource implements ProductLocalDatasource {
  ProductLocalSqliteDatasource._(this._db);

  final Database _db;

  static const _dbName = 'product_app.db';
  static const _version = 2;

  static Future<ProductLocalSqliteDatasource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    final db = await openDatabase(
      path,
      version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            price REAL NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            image TEXT NOT NULL,
            rating REAL NOT NULL DEFAULT 0,
            stock INTEGER NOT NULL DEFAULT 0,
            is_favorite INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE products ADD COLUMN rating REAL NOT NULL DEFAULT 0');
          await db.execute(
              'ALTER TABLE products ADD COLUMN stock INTEGER NOT NULL DEFAULT 0');
        }
      },
    );
    return ProductLocalSqliteDatasource._(db);
  }

  @override
  Future<void> saveAll(List<ProductModel> products) async {
    await _db.transaction((txn) async {
      await txn.delete('products', where: 'id >= 0');
      for (final product in products) {
        await txn.insert(
          'products',
          _toRow(product),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<List<ProductModel>> getAll() async {
    final rows = await _db.query('products', orderBy: 'id ASC');
    return rows.map(ProductModel.fromMap).toList();
  }

  @override
  Future<ProductModel> upsert(ProductModel product) async {
    await _db.insert(
      'products',
      _toRow(product),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return product;
  }

  @override
  Future<void> deleteById(int id) async {
    await _db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> setFavorite(int productId, bool isFavorite) async {
    await _db.update(
      'products',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Map<String, Object?> _toRow(ProductModel product) {
    return {
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.thumbnail,
      'rating': product.rating,
      'stock': product.stock,
      'is_favorite': product.isFavorite ? 1 : 0,
    };
  }
}
