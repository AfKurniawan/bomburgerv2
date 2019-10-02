import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:localstorage/localstorage.dart';

import '../constants/constants.dart';

class Burger {
  String id;
  String name;
  String picture;
  String price;
  double harga;
  String stock_quantity;
  int bid;
  int shopid;


  Burger({this.id, this.name, this.picture, this.price, this.stock_quantity, this.harga, this.bid, this.shopid});





  factory Burger.fromJson(Map<String, dynamic> json){



    return Burger(

      id:json['id'],
      bid: int.parse(json['id']),
      name:json['name'],
      picture: json['picture'],
      price: json['price'],
      harga: double.parse(json['price']),
      stock_quantity: json['stock_quantity']
    );
  }
}

class AppModel extends Model{

  List listburg;

  Future<List<Burger>> getData() async {
    List<Burger> list;
    var res = await http.get(Uri.encodeFull(Constants.burgerUrl),
        headers: {"Accept": "application/json"});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      listburg = data["burgers"] as List;
      print(listburg);
      list = listburg.map<Burger>((json) => Burger.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  List<Burger> _data = [];
  List<Burger> _cart = [];
  String cartMsg = "";
  bool success = false;
  Database _db;
  Directory tempDir;
  String tempPath;
  final LocalStorage storage = new LocalStorage('app_data');

  AppModel(){
    createDB();
  }

  createDB() async {

    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'cart.db');

      print(path);
//      await storage.deleteItem("isFirst");
//      await this.deleteDB();

      var database =
      await openDatabase(path, version: 1, onOpen: (Database db) {
        this._db = db;
        print("OPEN DBV");
        this.createTable();
      }, onCreate: (Database db, int version) async {
        this._db = db;
        print("DB Crated");
      });
    } catch (e) {
      print("ERRR >>>>");
      print(e);
    }
  }

  createTable() async {

    try {
      var qry = "CREATE TABLE IF NOT EXISTS shopping ( "
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "datetime DATETIME)";
      await this._db.execute(qry);
      qry = "CREATE TABLE IF NOT EXISTS cart_list ( "
          "id INTEGER PRIMARY KEY,"
          "shop_id INTEGER,"
          "name TEXT,"
          "image Text,"
          "price REAL,"
          "datetime DATETIME)";

      await this._db.execute(qry);

      var _flag = storage.getItem("isFirst");
      print("FLAG IS FIRST $_flag");
      if (_flag == "true") {
        this.FetchLocalData();
        this.FetchCartList();
      } else {
        this.InsertInLocal();
      }
    } catch (e) {
      print("ERRR ^^^");
      print(e);
    }
  }

  FetchLocalData() async {
    try {
      // Get the records
      List<Map> list = await this._db.rawQuery('SELECT * FROM shopping');
      list.map((dd) {
        Burger d = new Burger();
        d.id = dd["id"];
        d.name = dd["name"];
        d.picture = dd["image"];
        d.price = dd["price"];
        _data.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR %%%");
      print(e);
    }
  }

  InsertInLocal() async {

    try {
      await this._db.transaction((tx) async {
        for (var i = 0; i < listburg.length; i++) {
          print("Called insert ${i}");
          Burger d = new Burger();
          d.bid = i + 1;
          d.name = listburg[i]["name"];
          d.picture = listburg[i]["image"];
          d.price = listburg[i]["price"];

          try {
            var qry =
                'INSERT INTO shopping(name, price, image,rating,fav) VALUES("${d.name}",${d.price}, "${d.picture}")';
            var _res = await tx.rawInsert(qry);
          } catch (e) {
            print("ERRR >>>");
            print(e);
          }
          _data.add(d);
          notifyListeners();
        }

        storage.setItem("isFirst", "true");
      });
    } catch (e) {
      print("ERRR ## > ");
      print(e);
    }
  }

  InsertInCart(Burger d) async {

    await this._db.transaction((tx) async {
      try {
        var qry =
            'INSERT INTO cart_list(name, price, image) VALUES(${d.id},"${d.name}",${d.price}, "${d.picture}")';
        var _res = await tx.execute(qry);
        this.FetchCartList();
      } catch (e) {
        print("ERRR @@ @@");
        print(e);
      }
    });
  }

  FetchCartList() async {
    try {
      // Get the records
      _cart = [];
      List<Map> list = await this._db.rawQuery('SELECT * FROM cart_list');
      print("Cart len ${list.length.toString()}");
      list.map((dd) {
        Burger d = new Burger();
        d.id = dd["id"];
        d.name = dd["name"];
        d.picture = dd["image"];
        d.price = dd["price"];
        _cart.add(d);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("ERRR @##@");
      print(e);
    }
  }

  void addItem(Burger dd) {
    Burger d = new Burger();
    d.bid = _data.length + 1;
    d.name = "New";
    d.picture =
    "";
    d.harga = 154.0;
    _data.add(d);
    notifyListeners();
  }

  // Cart Listing
  List<Burger> get cartListing => _cart;

  // Add Cart
  void addCart(Burger dd) {
    print(dd);
    print(_cart);
    int _index = _cart.indexWhere((d) => d.shopid == dd.bid);
    if (_index > -1) {
      success = false;
      cartMsg = "${dd.name.toUpperCase()} already added in Cart list.";
    } else {
      this.InsertInCart(dd);
      success = true;
      cartMsg = "${dd.name.toUpperCase()} successfully added in cart list.";
    }
  }

  RemoveCartDB(Burger d) async {
    try {
      var qry = "DELETE FROM cart_list where id = ${d.id}";
      this._db.rawDelete(qry).then((data) {
        print(data);
        int _index = _cart.indexWhere((dd) => dd.id == d.id);
        _cart.removeAt(_index);
        notifyListeners();
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print("ERR rm cart $e");
    }
  }

  // Remove Cart
  void removeCart(Burger dd) {
    this.RemoveCartDB(dd);
  }
}

class Item {
  final String name;

  Item(this.name);
}





