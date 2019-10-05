import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



final String tableCart = 'cart';
final String columnId = '_id';
final String columnBurg = 'burger';
final String columnQty = 'qty';

class MyCart extends ChangeNotifier {
  List<CartItem> items = [];
  List<CartItem> get cartItems => items;

  void addItem(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.burg.name == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        notifyListeners();
        return;
      }
    }
    items.add(cartItem);
    notifyListeners();
  }

  void clearCart() {
    items.clear();
    notifyListeners();
  }

  void decreaseItem(CartItem cartModel) {
    if (cartItems[cartItems.indexOf(cartModel)].quantity <= 1) {
      return;
    }
    cartItems[cartItems.indexOf(cartModel)].quantity--;
    notifyListeners();
  }

  void increaseItem(CartItem cartModel) {
    cartItems[cartItems.indexOf(cartModel)].quantity++;
    notifyListeners();
  }

  void removeAllInCart(Burger burg) {
    cartItems.removeWhere((f) {
      return f.burg.name == burg.name;
    });
    notifyListeners();
  }
}

class CartItem {
  Burger burg;
  int quantity;

  CartItem({this.burg, this.quantity});
}






class DbCart{

  int id;
  String name;
  int qty;

  DbCart();

  DbCart.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    name = map[columnBurg];
    qty = map[columnQty];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnBurg: name,
      columnQty: qty
    };
    if(id != null){

      map[columnId] = id;
    }
    return map;
  }

}

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "cart.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableCart (
                $columnId INTEGER PRIMARY KEY,
                $columnBurg TEXT NOT NULL,
                $columnQty INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(DbCart dbcart) async {
    Database db = await database;
    int id = await db.insert(tableCart, dbcart.toMap());
    return id;
  }

  Future<DbCart> queryCart(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCart,
        columns: [columnId, columnBurg, columnQty],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return DbCart.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}