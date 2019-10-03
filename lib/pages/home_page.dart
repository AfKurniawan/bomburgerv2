import 'package:bomburger/pages/product_detail_page.dart';
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

  //List list;

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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
                      ? _buildBurgerList(snapshot.data)
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

  Widget _buildBurgerList(List<Burger> burger) {
    return Expanded(
      child: ListView.builder(
          itemCount: burger == null ? 0 : burger.length,
          itemBuilder: (context, position) {
            return Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 150.0,
                      width: double.infinity,
                      child: InkWell(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                                Constants.imgUrl + list[position].picture,
                                   // '${burger[position].picture}',
                                fit: BoxFit.cover
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductDetailPage(
                                        list: list,
                                        index: position,
                                      )));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                visible: true,
                                child: Text(list[position].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .merge(TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700))),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Visibility(
                                visible: true,
                                child: Text(list[position].id,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .title
                                        .merge(TextStyle(fontSize: 14.0))),
                              ),
                              Visibility(
                                visible: true,
                                child: Text('RM.' + list[position].price,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .merge(TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.red))),
                              ),

                              /* Visibility(
                                visible: false,
                                child: Text(list[i]['id'],
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .title
                                        .merge(
                                        TextStyle(
                                            fontSize: 16.0, color: Colors.red))),
                              ),*/
                            ],
                          ),
                        ),

                        /* Row(
                  children: <Widget>[
                    Visibility(
                        visible: true,
                        child: Text("Available Stock: ",
                            style: Theme.of(context).textTheme.title.merge(
                                TextStyle(fontSize: 16.0, color: Colors.red)))),
                    Visibility(
                        visible: true,
                        child: Text(stock != null ? stock : '0',
                            style: Theme.of(context).textTheme.title.merge(
                                TextStyle(fontSize: 16.0, color: Colors.red)))),
                  ],
                ),*/

                        Card(
                          margin: EdgeInsets.only(right: 0),
                          shape: roundedRectangle4,
                          color: mainColor,
                          child: Container(
                            width: 38,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: InkWell(
                                onTap: () =>
                                    addItemToCard(context, burger[position]),
                                splashColor: Colors.white70,
                                customBorder: roundedRectangle4,
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                        // IconButton(
                        //   icon: Icon(Icons.add_shopping_cart),
                        //   onPressed: () {},
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildFoodList(List<Burger> burger) {
    return Expanded(
      child: GridView.builder(
          itemCount: burger == null ? 0 : burger.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, position) {
            return Container(
              height: 188,
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
                        fit: BoxFit.fitHeight,
                        height: MediaQuery.of(context).size.height / 6,
                        loadingBuilder:
                            (context, Widget child, ImageChunkEvent progress) {
                          if (progress == null) return child;
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(48),
                              child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes
                                      : null),
                            ),
                          );
                        },
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            '${burger[position].name}',
                            maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                            style: titleStyleName,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'RM. ${burger[position].harga}',
                            style: titleStylePrice,
                          ),
                          InkWell(
                            onTap: () =>
                                addItemToCard(context, burger[position]),
                            splashColor: Colors.white70,
                            customBorder: roundedRectangle4,
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 8,
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
      duration: Duration(milliseconds: 3000),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    Provider.of<MyCart>(context).addItem(CartItem(burg: burger, quantity: 1));
  }
}
