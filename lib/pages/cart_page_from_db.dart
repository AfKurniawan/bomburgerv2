import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/data/database_helper.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:bomburger/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPage createState() => _MyCartPage();
}

class _MyCartPage extends State<MyCartPage> {
  int count = 0;

  //KeranjangDatabaseProvider database = new KeranjangDatabaseProvider();

  List<Keranjang> items = new List();
  DatabaseHelper db = new DatabaseHelper();

 // List<Keranjang> contactList;




  @override
  void initState() {
    super.initState();

    db.getAllNotes().then((notes) {
      setState(() {
        notes.forEach((note) {
          items.add(Keranjang.fromMap(note));
        });
      });
    });
  }


  @override
  void didUpdateWidget(MyCartPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {



    MyCart cart = Provider.of<MyCart>(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Container(
              width: 90,
              height: 8,
              decoration: ShapeDecoration(
                  shape: StadiumBorder(), color: Colors.black26),
            ),
          ),
          buildTitle(cart),
          Divider(),
          if (cart.cartItems.length <= 0)
            noItemWidget()
          else
            buildItemsList(cart),
          Divider(),
          buildPriceInfo(cart),
          SizedBox(height: 8),
          CheckoutButton(cart, context),
        ],
      ),
    );
    //});
  }

  Widget buildTitle(cart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Your Order', style: headerStyle),
        RaisedButton.icon(
          icon: Icon(Icons.delete_forever),
          color: Colors.red,
          shape: StadiumBorder(),
          splashColor: Colors.white60,
          onPressed: cart.clearCart,
          textColor: Colors.white,
          label: Text('Clear'),
        ),
      ],
    );
  }

  Widget buildItemsList(MyCart cart) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage:
                  NetworkImage(Constants.imgUrl + cart.cartItems[index].burg.picture)),
              title: Text('${cart.cartItems[index].burg.name}',
                  style: subtitleStyle),
              subtitle: Text('RM.  ${cart.cartItems[index].burg.harga} dg id: ${cart.cartItems[index].burg.id}'),
              trailing: Text('x ${cart.cartItems[index].quantity}',
                  style: subtitleStyle),

            ),

          );
        },
      ),
    );
  }

  Widget noItemWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('You don\'t have any order yet!!', style: titleStyleName),
            SizedBox(height: 16),
            Icon(Icons.remove_shopping_cart, size: 40),
          ],
        ),
      ),
    );
  }

  Widget buildPriceInfo(MyCart cart) {
    double total = 0;
    for (CartItem cartModel in cart.cartItems) {
      total += cartModel.burg.harga * cartModel.quantity;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total:', style: headerStyle),
        Text('RM.  ${total.toStringAsFixed(2)}', style: headerStyle),
      ],
    );
  }

  Widget CheckoutButton(cart, context) {
    return Center(
      child: RaisedButton(
        child: Text('Checkout', style: titleStyleName),
        onPressed: cart.cartItems.length == 0
            ? null
            : () {
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckOutPage()));
        },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }

 /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].nama}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${items[position].qty}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${items[position].id}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteNote(context, items[position], position)),
                        ],
                      ),
                      //onTap: () => _navigateToNote(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
         // onPressed: () => _createNewNote(context),
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
  }*/

  /*void _navigateToNote(BuildContext context, Keranjang note) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home(note)),
    );

    if (result == 'update') {
      db.getAllNotes().then((notes) {
        setState(() {
          items.clear();
          notes.forEach((note) {
            items.add(Note.fromMap(note));
          });
        });
      });
    }
  }

  void _createNewNote(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note('', ''))),
    );

    if (result == 'save') {
      db.getAllNotes().then((notes) {
        setState(() {
          items.clear();
          notes.forEach((note) {
            items.add(Note.fromMap(note));
          });
        });
      });
    }
  }*/
}