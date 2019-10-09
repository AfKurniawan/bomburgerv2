import 'package:bomburger/data/database_provider.dart';
import 'package:bomburger/model/new_cart_model.dart';
import 'package:flutter/material.dart';

class MyCartPage extends StatefulWidget {
  @override
  _MyCartPage createState() => _MyCartPage();
}

class _MyCartPage extends State<MyCartPage> {
  int count = 0;

  List<Keranjang> contactList;


  @override
  void didUpdateWidget(MyCartPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if (contactList == null) {
      contactList = List<Keranjang>();
    }

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

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.people),
            ),
            title: Text(this.contactList[index].nama, style: textStyle,),
            subtitle: Text(this.contactList[index].qty),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () {
                //deleteContact(contactList[index]);
              },
            ),
            onTap: () async {
             /* var contact = await navigateToEntryForm(context, this.contactList[index]);
              if (contact != null) editContact(contact);*/
            },
          ),
        );
      },
    );
  }
}