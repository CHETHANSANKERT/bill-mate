import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/general/key_value.dart';
import '../../model/store/store.dart';

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
      version: 4, // bumped for customers
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// the upgrade to handle the new store address and beat and area required
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Adding new columns in version 2
      await db.execute("ALTER TABLE sales ADD COLUMN address TEXT;");
      await db.execute("ALTER TABLE sales ADD COLUMN area TEXT;");
      await db.execute("ALTER TABLE sales ADD COLUMN beat TEXT;");
      await db.execute("ALTER TABLE sales ADD COLUMN mobileNum TEXT;");
    }
  }

  Future _onCreate(Database db, int version) async {
    await _createStoresTable(db);
    await _createCustomersTable(db);
    await _createItemsTable(db);
    await _createSalesTable(db);
    await _createSaleProductsTable(db);
  }

  Future<void> _createCustomersTable(Database db) async {
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createStoresTable(Database db) async {
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
  }

  Future<void> _createItemsTable(Database db) async {
    await db.execute('''
    CREATE TABLE item (
      id TEXT PRIMARY KEY,
      itemName TEXT,
      rate REAL
    )
  ''');
  }

  Future<void> _createSalesTable(Database db) async {
    await db.execute('''
  CREATE TABLE sales (
    billingId INTEGER PRIMARY KEY AUTOINCREMENT,
    id TEXT UNIQUE,
    storeName TEXT,
    storeId TEXT,
    saleTotal REAL,
    invoiceId INTEGER,
    createdAt TEXT,
    isPrinted INTEGER DEFAULT 0,
    FOREIGN KEY (storeId) REFERENCES stores (id) ON DELETE CASCADE
  )
''');
  }

  Future<void> _createSaleProductsTable(Database db) async {
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
  Future<void> insertStore(StoreModel store) async {
    final db = await database;
    if ((await db.query(
      'stores',
      where: 'storeName = ? AND area = ? AND beat = ? AND address = ? AND mobileNum = ?',
      whereArgs: [store.storeName, store.area, store.beat, store.address, store.mobileNum],
    ))
        .isEmpty) {
      await db.insert('stores', store.toJson());
    }
  }

  /// fins all stores to be displayed in all stores
  Future<List<Map<String, dynamic>>> getAllStores() async {
    final db = await database;
    return await db.query('stores');
  }

  Future<Map<String, dynamic>?>? getStoresById(String id) async {
    final db = await database;
    final result = await db.query('stores', where: 'storeId = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> deleteStore(String id) async {
    final db = await database;
    return await db.delete('stores', where: 'id = ?', whereArgs: [id]);
  }

  /// find all stores for the drop down values
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

  /// find if the stores are present in the database with the values and if not add to the db
  Future<int> addStore(Map<String, dynamic> store) async {
    final db = await database;
    return await db.insert('stores', store);
  }

  /// Product CRUD operations
  /// insert a new product to the database
  Future<int> insertSaleProducts(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('sale_products', product);
  }

  /// Sale CRUD
  Future<int> insertSale(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('sales', product);
  }

  Future<int> updateSale(
    String saleId,
    Map<String, dynamic> sale,
  ) async {
    final db = await database;

    return await db.update(
      'sales',
      sale,
      where: 'id = ?',
      whereArgs: [saleId],
    );
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

  /// Get products for a given sale
  Future<List<Map<String, dynamic>>> getSaleProductsBySaleId(String saleId) async {
    final db = await database;
    return await db.query('sale_products', where: 'saleId = ?', whereArgs: [saleId]);
  }

  /// get the option of store value available in stores
  Future<List<String>> getDistinctFieldValuesFromStore(
    String field,
    String query, {
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

    return result.map((row) => row[field]?.toString() ?? '').where((v) => v.isNotEmpty).toSet().toList();
  }

  /// mark the sale as already printed
  Future<void> markSaleAsPrinted(String saleId) async {
    final db = await database;
    await db.update(
      'sales',
      {'isPrinted': 1},
      where: 'id = ?',
      whereArgs: [saleId],
    );
  }

  /// for the current month sales
  Future<List<Map<String, dynamic>>> getCurrentMonthSales() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT id, storeName, saleTotal, createdAt
    FROM sales
    WHERE strftime('%Y-%m', createdAt) = strftime('%Y-%m', 'now')
  ''');
    return result;
  }

  Future<List<Map<String, dynamic>>> getLastMonthSales() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT id, storeName, saleTotal, createdAt
    FROM sales WHERE strftime('%Y-%m', createdAt) = strftime('%Y-%m', 'now', '-1 month')
  ''');
    return result;
  }

  /// all -store

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await database;
    return await db.query('customers');
  }

  Future<void> insertCustomer(Map<String, dynamic> customerData) async {
    final db = await database;
    await db.insert('customers', customerData);
  }

  Future<int> deleteCustomer(String id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  /// items CRUD functionality
  /// add item to table
  Future<void> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('item', {
      ...item,
    });
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query('item');
  }

  Future<int> updateItem({
    required String id,
    required double rate,
  }) async {
    final db = await database;

    return await db.update(
      'item',
      {
        'rate': rate,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  /// delete functionality in teh item
  Future<int> deleteItem(String id) async {
    final db = await database;
    return await db.delete('item', where: 'id = ?', whereArgs: [id]);
  }

  /// find item  in the table
  Future<bool> isNewItem(String itemName) async {
    final db = await database;
    final result = await db.rawQuery(
      '''SELECT * FROM item WHERE itemName = ?''',
      [itemName],
    );
    return result.isEmpty;
  }

  /// get the option of items value available
  Future<List<Map<String, Object?>>> getDistinctFieldValuesInItem(String query) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT * FROM item WHERE itemName LIKE ?',
      ['%$query%'],
    );
    return result;
  }
}
