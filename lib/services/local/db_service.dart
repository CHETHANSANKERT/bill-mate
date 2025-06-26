import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/general/key_value.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bill_mate.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {

    /// 1. Stores Table (main store entity)
    await db.execute('''
    CREATE TABLE stores (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      storeId TEXT,
      storeName TEXT,
      ownerName TEXT,
      location TEXT,
      gstNumber TEXT,
      area TEXT,
      beat TEXT,
      address TEXT,
      createdAt TEXT,
      mobileNum TEXT
    )
  ''');

    /// 2. Items Table (items that belong to a store)
    await db.execute('''
    CREATE TABLE item (
      id TEXT PRIMARY KEY,
      storeId INTEGER,
      itemName TEXT,
      rate REAL,
      FOREIGN KEY (storeId) REFERENCES stores (id) ON DELETE CASCADE
    )
  ''');

    /// 3. Sales Table (each sale belongs to a store)
    await db.execute('''
    CREATE TABLE sales (
      id TEXT PRIMARY KEY,
      storeName TEXT,
      storeId TEXT,
      saleTotal REAL,
      invoiceId INTEGER,
      createdAt TEXT,
      isPrinted INTEGER DEFAULT 0,
      FOREIGN KEY (storeId) REFERENCES stores (id) ON DELETE CASCADE
    )
  ''');

    /// 4. Sale Products Table (each sale-product links to sale and item)
    await db.execute('''
    CREATE TABLE sale_products (
      saleId TEXT,
      itemId TEXT,
      itemName TEXT,
      rate REAL,
      quantity REAL,
      productTotal REAL,
      FOREIGN KEY (saleId) REFERENCES sales (id) ON DELETE CASCADE,
      FOREIGN KEY (itemId) REFERENCES item (id) ON DELETE SET NULL
    )
  ''');
  }


  /// Store CRUD
  Future<int> insertStore(Map<String, dynamic> store) async {
    final db = await database;
    return await db.insert('stores', store);
  }

  Future<List<Map<String, dynamic>>> getAllStores() async {
    final db = await database;
    return await db.query('stores');
  }

  Future<Map<String, dynamic>> getStoresById(String id) async {
    final db = await database;
    final result = await db.query('stores', where: 'storeId = ?', whereArgs: [id]);
    return result.first;
  }

  Future<int> deleteStore(String id) async {
    final db = await database;
    return await db.delete('stores', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, Object?>> findStore(String name, String area, String beat) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
    SELECT * FROM stores 
    WHERE storeName = ? AND area = ? AND beat = ?
    ''',
      [name, area, beat],
    );
    // If no matching store, return true (not found)
    return result.first;
  }


  /// Product CRUD
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('sale_products', product);
  }

  /// Sale CRUD
  Future<int> insertSale(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('sales', product);
  }

  Future<List<Map<String, dynamic>>> getSalesById(String storeId) async {
    final db = await database;
    return await db.query('sales', where: 'storeId = ?', whereArgs: [storeId]);
  }

  Future<List<Map<String, dynamic>>> getAllSales() async {
    final db = await database;
    return await db.query('sales');
  }

  /// sales where the bill is not printed before and is ready fo being printed
  Future<List<Map<String, dynamic>>> getAllPrintableSales() async {
    final db = await database;
    return await db.query('sales', where: 'isPrinted = 0');
  }

  Future<int> deleteSale(String id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  ///get sale product
  Future<int> insertSaleProduct(Map<String, dynamic> saleProduct) async {
    final db = await database;
    return await db.insert('sale_products', saleProduct);
  }

  /// Get products for a given sale
  Future<List<Map<String, dynamic>>> getSaleProductsBySaleId(String saleId) async {
    final db = await database;
    return await db.query('sale_products', where: 'saleId = ?', whereArgs: [saleId]);
  }

  /// get the option of store value available in stores
  Future<List<String>> getDistinctFieldValues(String field, String query,{
    List<KeyValue>? keyValue,
  }) async {
    final db = await database;
    String sql = 'SELECT DISTINCT $field FROM stores WHERE $field LIKE ?';
    List<dynamic> args = ['%$query%'];
    if (keyValue != null && keyValue.isNotEmpty) {
      for (var kv in keyValue) {
        if (kv.key.isNotEmpty && kv.value.isNotEmpty) {
          sql += ' AND ${kv.key} = ?';
          args.add(kv.value);
        }
      }
    }

    final result = await db.rawQuery(sql, args);

    return result
        .map((row) => row[field]?.toString() ?? '')
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList();
  }
}
