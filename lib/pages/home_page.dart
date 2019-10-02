import 'package:flutter/material.dart';
import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/widgets/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 1;

  Future<List<Burger>> getData() async {
    List<Burger> list;
    var res = await http.get(Uri.encodeFull(Constants.burgerUrl),
        headers: {"Accept": "application/json"});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["burgers"] as List;
      print(rest);
      list = rest.map<Burger>((json) => Burger.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  showCart() {
    showModalBottomSheet(
      shape: roundedRectangle40,
      context: context,
      builder: (context) => CartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                      ? buildFoodList(snapshot.data)
                      : Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
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

  /*Widget buildFoodFilter() {
    return Container(
      height: 50,
      //color: Colors.red,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: List.generate(FoodTypes.values.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              selectedColor: mainColor,
              labelStyle: TextStyle(
                  color: value == index ? Colors.white : Colors.black),
              label: Text(FoodTypes.values[index].toString().split('.').last),
              selected: value == index,
              onSelected: (selected) {
                setState(() {
                  value = selected ? index : null;
                });
              },
            ),
          );
        }),
      ),
    );
  }*/

  Widget buildFoodList(List<Burger> burger) {

    return Expanded(
      child: GridView.builder(
          itemCount: burger == null ? 0 : burger.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, position) {
            return Container(
              child: Card(
                shape: roundedRectangle12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        Constants.imgUrl + '${burger[position].picture}',
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height / 6,
                        loadingBuilder:
                            (context, Widget child, ImageChunkEvent progress) {
                          if (progress == null) return child;
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes
                                      : null),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        '${burger[position].name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${burger[position].harga}',
                            style: titleStyle,
                          ),
                          Card(
                            margin: EdgeInsets.only(right: 0),
                            shape: roundedRectangle4,
                            color: mainColor,
                            child: InkWell(
                              onTap: () =>
                                  addItemToCard(context, burger[position]),
                              splashColor: Colors.white70,
                              customBorder: roundedRectangle4,
                              child: Icon(Icons.add),
                            ),
                          )
                        ],
                      ),
                    ),

                    //buildImage(),
                    //buildTitle(),
                    //buildRating(),
                    // buildPriceInfo(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  addItemToCard(BuildContext context, Burger burger) {
    final snackBar = SnackBar(
      content: Text('${burger.name} added to cart'),
      duration: Duration(milliseconds: 500),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    Provider.of<MyCart>(context).addItem(CartItem(burg: burger, quantity: 1));
  }
}
