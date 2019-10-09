import 'dart:async';

import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

 /* final String tableName = 'cart';
  final String columnId = 'id';
  final String columnName = 'nama';
  final String columnQty = 'qty';
  final String columnProdId = 'prodid';*/

  static final _databaseName = "cart.db";
  static final _databaseVersion = 1;
  static final tableName = 'cart';
  static final columnId = 'id';
  static final columnName = 'nama';
  static final columnQty = 'qty';
  static final columnProdId = 'prodid';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'carts.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnQty TEXT, $columnProdId TEXT)');
  }

  Future<int> saveNote(CartItem note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableName, note.toMap());
   // var result = await dbClient.rawInsert(
   //     'INSERT INTO $tableName ($columnName, $columnQty, $columnProdId) VALUES (\'${note.burg.name}\', \'${note.quantity}\', \'${note.burg.id})\'');

    return result;
  }

  insertToDb(CartItem cartItem) async {
    var dbClient = await db;
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: cartItem.burg.name,
      DatabaseHelper.columnQty: cartItem.quantity,
      DatabaseHelper.columnProdId: cartItem.burg.id,

    };

    await dbClient.insert(DatabaseHelper.tableName, row);
    print(await dbClient.query(DatabaseHelper.tableName));

  }
  Future<List> getAllNotes() async {
    var dbClient = await db;
    var result = await dbClient.query(tableName, columns: [columnId, columnName, columnQty, columnProdId]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<Keranjang> getNote(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableName,
        columns: [columnId, columnName, columnQty, columnProdId],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Keranjang.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateNote(Keranjang krj) async {
    var dbClient = await db;
    return await dbClient.update(tableName, krj.toMap(), where: "$columnId = ?", whereArgs: [krj.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}