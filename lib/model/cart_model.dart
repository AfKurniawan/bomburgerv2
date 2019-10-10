import 'dart:convert';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:flutter/material.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyCart extends ChangeNotifier {


  List<CartItem> items = [];

  List<Keranjang> cmItems = [];

  List<CartItem> get cartItems => items;

  List<Keranjang> get mItems => cmItems;


  List<Burger> bitems = [];

  List<Burger> lst = new List<Burger>();

  List<Burger> get cartBitems => bitems;

  SharedPreferences sharedPreferences;






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

  void addItemsSf(CartItem cartItem) {
    for (CartItem cart in cartItems) {
      if (cartItem.burg.name == cart.burg.name) {
        cartItems[cartItems.indexOf(cart)].quantity++;
        notifyListeners();
        return;
      }
    }

    items.add(cartItem);
    //setSharedPrefs(cartItem.burg);
    notifyListeners();




  }





  void setSharedPrefs(Burger burg) async {


    int qty=1;
    lst.insert(qty++, burg);


    List<String> stringList = lst.map(
            (item) => json.encode(item.toMap()
        )).toList();

    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('list', stringList);

  }

  void getSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();

    List<String> paiman = sharedPreferences.getStringList('list');

    if(paiman != null){
      lst = paiman.map(
              (item) => Burger.fromMap(json.decode(item))
      ).toList();

      print('ini ' + paiman.toString());

    }
  }



  void clearCart() {
    items.clear();
    notifyListeners();
  }

  void decreaseItem(CartItem cartModel) {

    if (cartItems[cartItems.indexOf(cartModel)].quantity <= 1) {
      return;
    }
    cartItems[cartItems.indexOf(cartModel)].quantity --;
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

  CartItem.fromMap(Map map) :
        this.burg = map['burg'],
        this.quantity = map['quantity'];

  Map toMap() {
    return {
      'burg': this.burg,
      'quantity': this.quantity,
    };
  }

}
