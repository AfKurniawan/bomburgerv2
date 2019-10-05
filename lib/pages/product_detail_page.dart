
import 'dart:async';

import 'package:bomburger/model/login_response.dart';
import 'package:bomburger/widgets/dialog_failed.dart';
import 'package:bomburger/widgets/dialog_success.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../model/burger_model.dart';



ProgressDialog pd;

class ProductDetailPage extends StatefulWidget {

  List<Burger> list;
  int index;
  Burger detail;

  //ProductDetailPage({this.detail});

  ProductDetailPage({this.index, this.list, this.detail});

  @override
  _productDetailBurgerState createState() => new _productDetailBurgerState();
}

class _productDetailBurgerState extends State<ProductDetailPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  TextEditingController controllerProductId = new TextEditingController();
  TextEditingController controllerProductQty = new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerTotal = new TextEditingController();

  TextEditingController controllerAmount = new TextEditingController();
  TextEditingController controllerReceiveAmount = new TextEditingController();
  TextEditingController controllerChangeAmount = new TextEditingController();
  TextEditingController controllerPaymentType = new TextEditingController();
  TextEditingController controllerCustomerId = new TextEditingController();

  TextEditingController controllerUserId = new TextEditingController();
  TextEditingController controllerStoreId = new TextEditingController();

  int intValue = 1;

  String userId;
  String storeId;

  String newValue;

  String _value;


  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id");
    storeId = prefs.getString("store_id");
    setState(() {
      controllerUserId = new TextEditingController(text: userId);
      controllerStoreId = new TextEditingController(text: storeId);
    });
  }

  @override
  void initState() {
    controllerProductId =
        new TextEditingController(text: widget.list[widget.index].id);
    controllerProductQty =
        new TextEditingController(text: "");
    controllerPrice =
        new TextEditingController(text: widget.list[widget.index].price);
    controllerTotal =
        new TextEditingController(text: widget.list[widget.index].price);

    userId = "";
    storeId = "";

    getSharedPrefs();

    super.initState();
  }

  getSharedPreferences(String userId, String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString('user_id');
    storeId = prefs.getString('store_id');
  }




  Future<UserResponse> post(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;

//      setState(() {
//
//      });

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return UserResponse.fromJson(json.decode(response.body));
    });
  }

  void insertSales() {
    post(Constants.addSalesUrl, {
      "amount": controllerAmount.text,
      "receive_amount": controllerReceiveAmount.text,
      "change_amount": controllerChangeAmount.text,
      "payment_type": _value,
      "customer_id": controllerCustomerId.text,
      "product_id": controllerProductId.text,
      "qnt": controllerProductQty.text,
      "price": controllerPrice.text,
      "seller_id": controllerUserId.text,
      "store_id": controllerStoreId.text
    }).then((response) async {
      pd.hide();

      if (response.status == "success") {
        pd.hide();

        _successDialog(context);
      } else {
        _failedDialog(context);
        pd.hide();
      }
    }, onError: (error) {
      _failedDialog(context);
      pd.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        centerTitle: true,
        elevation: 3,
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.orange,
        title: Text("${widget.list[widget.index].name}"),
      ),
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(context) {

    String dataName = "${widget.list[widget.index].name}";
    String dataPrice = "${widget.list[widget.index].price}";
    String dataPicture = "${widget.list[widget.index].picture}";

    String sValue = intValue.toString();

    var jumlah = (Decimal.parse(sValue) * Decimal.parse(dataPrice));

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              _buildItemCard(context),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: new Row(
                        children: <Widget>[
                          Visibility(
                              visible: true,
                              child: Text("Quantity: ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .merge(TextStyle(
                                          fontSize: 16.0, color: Colors.red)))),
                          Visibility(
                            visible: true,
                            child: IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                minus();
                              },
                            ),
                          ),
                          SizedBox(width: 30),
                          Text(intValue.toString()),
                          Visibility(
                            visible: false,
                            child: Container(
                              width: 100,
                              child: TextFormField(
                                controller: controllerProductQty
                                  ..text = intValue.toString(),
                                decoration: InputDecoration(
                                  hintText: "1",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Visibility(
                            visible: true,
                            child: IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                add();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30),
                //child: AddSales(),
                child: Column(
                  children: <Widget>[
                    //_buildTextfieldBayar(),

                    SizedBox(height: 30),

                    SizedBox(height: 10),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Visibility(
                                  visible: true,
                                  child: Text("Total Price: RM.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .title
                                          .merge(TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red)))),
                              Visibility(
                                visible: true,
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    jumlah.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .merge(TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.deepOrange)),
                                    //TextStyle(color: Colors.deepOrange, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),

                    _buildButtonSale(context), //widget button sale

                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextfieldBayar() {


    String productId = "${widget.list[widget.index].id}";
    String dataPrice = "${widget.list[widget.index].price}";

    String sValue = intValue.toString();

    var jumlah = (Decimal.parse(sValue) * Decimal.parse(dataPrice));

    return Container(
      child: Column(
        children: <Widget>[
          Visibility(
            visible: false,
            child: TextField(
              enabled: false,
              controller: controllerAmount..text =  jumlah.toString(),
              decoration:
                  new InputDecoration(hintText: "Amount", labelText: "Amount"),
            ),
          ),

          new TextField(
            controller: controllerReceiveAmount,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                hintText: "Receive", labelText: "Receive Amount"),
          ),
          Visibility(
            visible: false,
            child: TextField(
              controller: controllerChangeAmount,
              decoration: new InputDecoration(
                  hintText: "Change Amount", labelText: "Change Amount"),
            ),
          ),

          Visibility(
            visible: false,
            child: TextField(
              controller: controllerProductId..text = productId,
              decoration: new InputDecoration(
                  hintText: "Change Amount", labelText: "id"),
            ),
          ),


          SizedBox(height: 10),

          DropdownButton<String>(
            items: [
              DropdownMenuItem<String>(
                child: Text('Cash'),
                value: 'Cash',
              ),
              DropdownMenuItem<String>(
                child: Text('Bank Tranfer'),
                value: 'Bank Tranfer',
              ),
            ],
            onChanged: (String value) {
              setState(() {
                _value = value;
              });
            },
            hint: Text('Payment Method'),
            value: _value,
            isExpanded: true,
          ),





          new TextField(
            controller: controllerCustomerId,
            decoration: new InputDecoration(
                hintText: "Customer", labelText: "Customer"),
          ),

          Visibility(
            visible: false,
            child: Container(
              width: 100,
              child: TextField(
                controller: controllerUserId,
                onChanged: (String str) {
                  setState(() {
                    userId = str;
                  });
                },
                decoration: InputDecoration(
                  hintText: "",
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              width: 100,
              child: TextField(
                controller: controllerStoreId,
                onChanged: (String str) {
                  setState(() {
                    storeId = str;
                  });
                },
                decoration: InputDecoration(
                  hintText: "",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void add() {
    setState(() {
      intValue++;
    });
  }

  void minus() {
    setState(() {
      if (intValue != 1) intValue--;
    });
  }

  Widget _buildButtonSale(context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                child: Text("Total Amount",style: TextStyle(fontSize: 12.0,color: Colors.grey),),
              ),
              //Text("\$${widget.list[widget.index].price.toString()}",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        ScopedModelDescendant<AppModel>(
          builder: (context,child,model){
            return RaisedButton(
              color: Colors.deepOrange,
              onPressed: (){
                model.addCart(widget.detail);
                Timer(Duration(milliseconds: 500), (){
                  showCartSnak(model.cartMsg,model.success);
                });
              },
              child: Text("ADD TO CART",style: TextStyle(color: Colors.white),),
            );
          },
        )
      ],
    );

    /*return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        *//*InkWell(
          child: Container(
            width: ScreenUtil.getInstance().setWidth(330),
            height: ScreenUtil.getInstance().setHeight(100),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  (Colors.deepOrange),
                  (Colors.orange),
                  (Colors.yellow)
                ]),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      color: (Colors.grey).withOpacity(.3),
                      offset: Offset(0.0, 8.0),
                      blurRadius: 8.0)
                ]),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //successDialog();
                  pd.show();
                  insertSales();
                  // Navigator.pop(context);
                },
                child: Center(
                  child: Text("Checkout",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontSize: 18,
                          letterSpacing: 1.0)),
                ),
              ),
            ),
          ),
        )*//*
      ],
    );*/
  }

  showCartSnak(String msg,bool flag){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg,style: TextStyle(color: Colors.white),),
          backgroundColor: (flag) ? Colors.green : Colors.red[500] ,
          duration: Duration(seconds: 2),
        ));
  }



  Widget _buildItemCard(context) {
    String dataName = "${widget.list[widget.index].name}";
    String dataPrice = "${widget.list[widget.index].price}";
    String dataPicture = "${widget.list[widget.index].picture}";
    String dataStock = "${widget.list[widget.index].stock_quantity}";

    return Stack(
      children: <Widget>[
        Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(Constants.imgUrl + dataPicture,
                        height: 200, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  dataName,
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "RM. " + dataPrice,
                  style: TextStyle(color: Colors.deepOrange),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _failedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogFailed();
        });
  }

  _successDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogSuccess();
        });
  }

  void successDialog() {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
            onlyOkButton: true,
            image: Image.asset(
              'assets/7efy.gif',
              height: 30,
              width: 30,
            ),
            title: Text(
              "Sales successfully added",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            ),
            description: Text(
              "You can check your sales history",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onOkButtonPressed: () {
              //removeValues();
              Navigator.of(context).pop();
            }));
  }

//  removeValues() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Remove String
//    prefs.remove("store_id");
//    //Remove bool
//    prefs.remove("user_id");
//    //Remove int
//    prefs.remove("intValue");
//    //Remove double
//    prefs.remove("doubleValue");
//  }

  void errorDialog() {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              onlyOkButton: true,
              image: Image.asset('assets/icon_failed.png'),
              title: Text(
                "Sales Added Failed",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                "Please check your internet connection",
                textAlign: TextAlign.center,
                style: TextStyle(),
              ),
              onOkButtonPressed: () => Navigator.of(context).pop(),
            ));
  }
}
