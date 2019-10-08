import 'package:bomburger/data/database.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:flutter/material.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPage createState() => _MyCartPage();
}

class _MyCartPage extends State<MyCartPage> {
  @override
  void didUpdateWidget(MyCartPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              KeranjangDatabaseProvider.db.deleteAllCarts();
              setState(() {});
            },
            child: Text(
              "Delete all",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body:
      FutureBuilder<List<Keranjang>>(
        future: KeranjangDatabaseProvider.db.getAllCarts(),
        builder: (BuildContext context, AsyncSnapshot<List<Keranjang>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Keranjang item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    KeranjangDatabaseProvider.db.deleteCartWithId(item.id);
                  },
                  child: ListTile(
                    title: Text(item.nama),
                    subtitle: Text(item.qty.toString()),
                    leading: CircleAvatar(child: Text(item.id.toString())),
                    onTap: () {
                     /* Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditCart(
                            true,
                            krj: item,
                          )));*/
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
           /* Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditPerson(false)));*/
          }
          ),
    );
  }
}