import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/widgets/cart_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => new _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  List<Burger> list;

  Future<List<Burger>> getData() async {
    var res = await http.get(Uri.encodeFull(Constants.burgerUrl),
        headers: {"Accept": "application/json"});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["burgers"] as List;
      print(rest);

      list = rest.map<Burger>((j) => Burger.fromJson(j)).toList();

      //list = rest.map<Burger>((json) => Burger.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  Widget buildAppBar() {
    int items = 0;
    Provider.of<MyCart>(context).cartItems.forEach((cart) {
      items += cart.quantity;
    });
    return SafeArea(
      child: Row(
        children: <Widget>[
          Text('MENU', style: headerStyle),
          Spacer(),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          Stack(
            children: <Widget>[
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: showCart),
              Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: mainColor),
                  child: Text(
                    '$items',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  addItemToCard(BuildContext context, Burger burger) {
    final snackBar = SnackBar(
      content: Text('${burger.name} added to cart'),
      duration: Duration(milliseconds: 3000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    Provider.of<MyCart>(context).addItem(CartItem(burg: burger, quantity: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: <Widget>[
            buildAppBar(),
            //buildFoodFilter(),
            Divider(),
            //buildFoodList(),
            FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? _buildGridView(snapshot.data)
                      : Center(
                          child: new SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: const CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                              )),
                        );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Burger> list) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: GridView.builder(
          itemCount: list == null ? 0 : list.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
              mainAxisSpacing: 10.0),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, position) {
            return Padding(
              padding: EdgeInsets.all(2.0),
              child: Container(
                height: 400.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        style: BorderStyle.solid,
                        width: 1.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 125.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: NetworkImage(Constants.imgUrl +
                                      list[position].picture),
                                  fit: BoxFit.fitHeight)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                          child: Text(
                            list[position].name,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Divider(),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            "RM. " + list[position].price,
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        child: Positioned(
                      left: 128.0,
                      top: 160.0,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.amber),
                        child: Center(
                          child: Icon(Icons.shopping_cart, color: Colors.white),
                        ),
                      ),
                    ),
                      onTap: () => addItemToCard(context, list[position]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFoodCard() {}
}
