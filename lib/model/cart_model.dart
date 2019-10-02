import 'package:flutter/material.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:bomburger/model/food_model.dart';

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
