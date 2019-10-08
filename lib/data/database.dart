import 'dart:async';
import 'dart:io';

import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class KeranjangDatabaseProvider {
  KeranjangDatabaseProvider._();

  List<CartItem> items = [];

  List<CartItem> get cartItems => items;

  static final KeranjangDatabaseProvider db = KeranjangDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
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
  }


  void tambahItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.burg.name == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        return;
      }
    }
    items.add(cartItem);

  }

  addCartToDatabase(Keranjang krj) async {
    final db = await database;

    var raw = await db.insert(
      "Cart",
      krj.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (CartItem cart in cartItems) {
      if (krj.nama == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        return raw;
      }
    }
  }

  updateCart(Keranjang krj) async {
    final db = await database;
    var response = await db.update("Cart", krj.toMap(),
        where: "id = ?", whereArgs: [krj.id]);
    return response;
  }

  Future<Keranjang> getCartWithId(int id) async {
    final db = await database;
    var response = await db.query("Cart", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Keranjang.fromMap(response.first) : null;
  }

  Future<List<Keranjang>> getAllCarts() async {
    final db = await database;
    var response = await db.query("Cart");
    List<Keranjang> list = response.map((c) => Keranjang.fromMap(c)).toList();
    return list;
  }

  deleteCartWithId(int id) async {
    final db = await database;
    return db.delete("Cart", where: "id = ?", whereArgs: [id]);
  }

  deleteAllCarts() async {
    final db = await database;
    db.delete("Cart");
  }
}