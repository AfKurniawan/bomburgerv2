import 'dart:ui';
import 'package:bomburger/model/post_response.dart';
import 'package:bomburger/widgets/dialog_failed.dart';
import 'package:bomburger/widgets/dialog_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


ProgressDialog pd;

class CheckOutPage extends StatefulWidget {
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> with SingleTickerProviderStateMixin {
  var now = DateTime.now();
  get weekDay => DateFormat('EEEE').format(now);
  get day => DateFormat('dd').format(now);
  get month => DateFormat('MMMM').format(now);
  double oldTotal = 0;
  double total = 0;



  List<CartItem> list;


  TextEditingController controllerProductQty = new TextEditingController();
  TextEditingController controllerProductId = new TextEditingController();



  ScrollController scrollController = ScrollController();
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200))..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  Future<PostResponse> post(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }

      return PostResponse.fromJson(json.decode(response.body));
    });
  }


  void _postSalesAction() {


    var cart = Provider.of<MyCart>(context);

    print('cart model id');

    print('opo iki  ${lerpDouble(oldTotal, total, animationController.value).toStringAsFixed(2)}');

    print('quantity: ' + controllerProductQty.text);





    post(Constants.addSalesUrl, {
      "amount": '${lerpDouble(oldTotal, total, animationController.value).toStringAsFixed(2)}',
      "receive_amount": '${lerpDouble(oldTotal, total, animationController.value).toStringAsFixed(2)}',
//      "change_amount": controllerChangeAmount.text,
     "payment_type": "Cash",
//      "customer_id": controllerCustomerId.text,
      "product_id": '${cart.cartItems}',
      "qnt": controllerProductQty.text,
      "price": '3.8',
      "seller_id": '1',
      "store_id": '1'
    }).then((response) async {
      pd.hide();

      if (response.status == "success") {
        pd.hide();
        //cartModel.clearCart();
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

  @override
  Widget build(BuildContext context) {




    pd = new ProgressDialog(context,type: ProgressDialogType.Normal);

    pd.style(message: 'Please wait...');

    //Optional
    pd.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );


    var cart = Provider.of<MyCart>(context);
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ...buildHeader(),
              //cart items list
              ListView.builder(
                itemCount: cart.cartItems.length,
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  print(cart.cartItems[index].burg.id);

                  return buildCartItemList(cart, cart.cartItems[index]);

                },
              ),
              SizedBox(height: 16),
              Divider(),
              buildPriceInfo(cart),
              checkoutButton(cart, context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildHeader() {


    return [
      SafeArea(
        child: InkWell(
          customBorder: StadiumBorder(),
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.arrow_back_ios),
                SizedBox(width: 8),
                Text('Back', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Text('Cart', style: headerStyle),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 0),
        child: Text('$weekDay, ${day}th of $month ', style: headerStyle),
      ),
      FlatButton(
        child: Text('+ Add to order'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }

  Widget buildPriceInfo(MyCart cart) {



    oldTotal = total;
    total = 0;
    for (CartItem cart in cart.cartItems) {
      total += cart.burg.harga * cart.quantity;
    }
    oldTotal = total;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total:', style: headerStyle),
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Text('\$ ${lerpDouble(oldTotal, total, animationController.value).toStringAsFixed(2)}', style: headerStyle);
          },
        ),
      ],
    );
  }

  Widget checkoutButton(MyCart cart, context ) {
    return Container(
      margin: EdgeInsets.only(top: 24, bottom: 64),
      width: double.infinity,
      child: RaisedButton(
        child: Text('Checkout', style: titleStyleName),
        onPressed: () {
         // cart.clearCart();
          _postSalesAction();
          //Navigator.of(context).pop();
        },
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
        color: mainColor,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget buildCartItemList(MyCart cart, CartItem cartModel) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Image.network(Constants.imgUrl+cartModel.burg.picture),
              ),
            ),
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    child: Text(
                      cartModel.burg.name,
                      style: subtitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          cart.decreaseItem(cartModel);
                          animationController.reset();
                          animationController.forward();
                        },
                        child: Icon(Icons.remove_circle),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
                        child: Text('${cartModel.quantity}', style: titleStylePrice),
                      ),
                      InkWell(
                        customBorder: roundedRectangle4,
                        onTap: () {
                          cart.increaseItem(cartModel);
                          animationController.reset();
                          animationController.forward();
                        },
                        child: Icon(Icons.add_circle),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 70,
                    child: Text(
                      'RM. ${cartModel.burg.harga}',
                      style: titleStylePrice,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cart.removeAllInCart(cartModel.burg);
                      animationController.reset();
                      animationController.forward();
                    },
                    customBorder: roundedRectangle12,
                    child: Icon(Icons.delete_sweep, color: Colors.red),
                  )
                ],
              ),
            ),
          ],
        ),
      ),


    );


  }
}
