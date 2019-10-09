import 'dart:async';
import 'dart:io';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class KeranjangDatabaseProvider extends ChangeNotifier {
  KeranjangDatabaseProvider._();

  List<CartItem> items = [];

  List<CartItem> get cartItems => items;
  static final KeranjangDatabaseProvider db = KeranjangDatabaseProvider._();
  static Database _database;

  KeranjangDatabaseProvider._privateConstructor();
  static final KeranjangDatabaseProvider instance =
      KeranjangDatabaseProvider._privateConstructor();

  /*Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }*/

  static final _databaseName = "cart.db";
  static final _databaseVersion = 1;

  static final table = 'cart';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnQty = 'qty';
  static final columnProdId = 'prodid';

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnQty INTEGER NOT NULL,
            $columnProdId INTEGER NOT NULL
            
          )
          ''');
  }

  /*Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "cart.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Cart ("
              "id integer primary key AUTOINCREMENT,"
              "nama TEXT,"
              "qty TEXT"
              ")");
        });
  }*/

/*  void tambahItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.burg.name == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        return;
      }
    }
    items.add(cartItem);
    notifyListeners();
  }*/

/*  addCartToDatabase(CartItem cartItem) async {
    final db = await database;

    var raw = await db.insert(
      "Cart",
      cartItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
    return raw;
  }*/

  insertToDb(CartItem cartItem) async {
    Database db = await database;
    Map<String, dynamic> row = {
      KeranjangDatabaseProvider.columnName: cartItem.burg.name,
      KeranjangDatabaseProvider.columnQty: cartItem.quantity,
      KeranjangDatabaseProvider.columnProdId: cartItem.burg.id,

    };

    await db.insert(KeranjangDatabaseProvider.table, row);
    print(await db.query(KeranjangDatabaseProvider.table));

    for (CartItem cart in cartItems) {
      if (cartItem.burg.name == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        items.add(cartItem);
        notifyListeners();
      }
    }
  }

  updateCart(Keranjang krj) async {
    final db = await database;
    var response = await db
        .update("cart", krj.toMap(), where: "id = ?", whereArgs: [krj.id]);
    return response;
  }

  Future<Keranjang> getCartWithId(int id) async {
    final db = await database;
    var response = await db.query("cart", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Keranjang.fromMap(response.first) : null;
  }

/*  Future<List<Keranjang>> getAllCarts() async {
    final db = await database;
    var response = await db.query(KeranjangDatabaseProvider.table);
    print(response);
    list = response.map((c) => Keranjang.fromMap(c)).toList();
    return list;
  }*/

 /* Future<List<Map<String, dynamic>>> getAllCarts() async {
    Database db = await this.database;
    var mapList = await db.query('contact', orderBy: 'name');
    return mapList;
  }*/

  Future<List<Keranjang>> getAllCarts() async {
    final db = await database;
    var response = await db.query("cart");
    List<Keranjang> list = response.map((c) => Keranjang.fromMap(c)).toList();
    return list;
  }

  deleteCartWithId(int id) async {
    final db = await database;
    return db.delete("cart", where: "id = ?", whereArgs: [id]);
  }

  deleteAllCarts() async {
    final db = await database;
    db.delete("cart");
  }
}
