import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/model/burger_model.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadWrite extends StatefulWidget {
  @override
  _readWriteState createState() => _readWriteState();
}

class _readWriteState extends State<ReadWrite> {
  //String valu="nollll";

  /*Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    valu = prefs.getString(key) ?? 0;
    print('read: '+ valu);

  }*/

  Future<Null> _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    DbCart cart = await helper.queryCart(rowId);
    if (cart == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${cart.name} ${cart.qty}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _read();
  }


  Widget buildAppBar() {
    int items = 0;

    return SafeArea(
      child: Row(
        children: <Widget>[
          Text('MENU', style: headerStyle),

        ],
      ),
    );
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
                future: _read(),
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

  Widget _buildGridView(List<DbCart> list) {
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

                      ],
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

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = 42;
    prefs.setInt(key, value);
    print('saved $value');
  }

}


