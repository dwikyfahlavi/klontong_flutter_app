import 'dart:async';
import 'package:klontong_flutter_app/data/models/product/product_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'klontong_cache.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            categoryId TEXT,
            categoryName TEXT,
            sku TEXT,
            name TEXT,
            description TEXT,
            weight REAL,
            width REAL,
            length REAL,
            height REAL,
            image TEXT,
            harga INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertProducts(List<Product> products) async {
    final db = await database;
    final batch = db.batch();
    for (var product in products) {
      batch.insert('products', product.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Product>> getCachedProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromJson(map)).toList();
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update('products', product.toJson(),
        where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCache() async {
    final db = await database;
    await db.delete('products');
  }
}
