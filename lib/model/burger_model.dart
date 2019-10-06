
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class Burger {

  String id;
  String name;
  String picture;
  String price;
  double harga;
  String stock_quantity;
  int bid;
  int shopid;
  int quantity;
  Burger burg;


  Burger({this.burg, this.id, this.name,this.picture, this.price, this.stock_quantity, this.harga, this.bid, this.shopid, this.quantity});


  Burger.fromMap(Map map) :
        this.name = map['name'];
        //quantity = map['quantity'];

  Map toMap() {
    return {
      'name': this.name,
      'quantity': this.quantity,
    };
  }

  factory Burger.fromJson(Map<String, dynamic> json){
    return Burger(
        id:json['id'],
        bid: int.parse(json['id']),
        name:json['name'],
        picture: json['picture'],
        price: json['price'],
        quantity: json['quantity'],
        harga: double.parse(json['price']),
        stock_quantity: json['stock_quantity']
    );


  }









}





