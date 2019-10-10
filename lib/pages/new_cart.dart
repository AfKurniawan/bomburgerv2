import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/data/database_helper.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:bomburger/widgets/quantityindicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<CartScreen> {
  int count = 0;
  int _quantity = 0;

  //KeranjangDatabaseProvider database = new KeranjangDatabaseProvider();

  List<Keranjang> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  void _calcTotal() async{
    var total = (await db.calculateTotal())[0]['total'];
    print(total);
    setState(() => count == total);
  }

  @override
  void initState() {
    super.initState();

    db.getAllNotes().then((carts) {
      setState(() {
        carts.forEach((carts) {
          items.add(Keranjang.fromMap(carts));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MyCart cart = Provider.of<MyCart>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Shopping Cart",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                    height: MediaQuery.of(context).size.height / 5,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          right: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 3.0,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: Image.network(
                                        Constants.imgUrl + items[i].img),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              items[i].nama,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title
                                                  .apply(fontWeightDelta: 2),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Visibility(
                                                visible: false,
                                                child: Text(
                                                  items[i].id.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                      alignment: Alignment.bottomRight,
                                      height: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            customBorder: roundedRectangle4,
                                            onTap: () {
                                              _quantity -- ;
                                             /* cart.decreaseItem(items);*/
                                           // animationController.reset();
                                           // animationController.forward();
                                            },
                                            child: Icon(Icons.remove_circle),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 2),
                                            child: Text(items[i].qty.toString(),
                                                style: titleStylePrice),
                                          ),
                                          InkWell(
                                            customBorder: roundedRectangle4,
                                            onTap: () {
                                              _quantity ++;
                                              /*cart.increaseItem(cartModel);
                                            animationController.reset();
                                            animationController.forward();*/
                                            },
                                            child: Icon(Icons.add_circle),
                                          ),
                                        ],
                                      ) /*Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Icon(Icons.add),
                                          onTap: () {
                                            setState(() {
                                              _quantity += 1;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(items[i].qty),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        GestureDetector(
                                          child: Icon(Icons.remove),
                                          onTap: () {
                                            setState(() {
                                              _quantity -= 1;
                                            });
                                          },
                                        ),
                                      ],
                                    ),*/
                                      ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 17,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _calcTotal();
                              _deleteNote(context, items[i], i);

                            },
                            child: Container(
                              padding: EdgeInsets.all(3.0),
                              color: Colors.cyan,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 9.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Total Price: ",
                  style: TextStyle(fontSize: 19, color: Colors.grey),
                ),
                Text(
                  "\$1921",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                )
              ],
            ),
            FractionallySizedBox(
              widthFactor: 2 / 3,
              child: RaisedButton(
                child: Text(
                  "Confirm Payment",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.cyan,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteNote(BuildContext context, Keranjang note, int position) async {
    db.deleteNote(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }
}
