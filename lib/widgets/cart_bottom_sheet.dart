import 'package:flutter/material.dart';
import 'package:bomburger/constants/constants.dart';
import 'package:bomburger/constants/values.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/pages/checkout_page.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatelessWidget {
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
        itemCount: cart.cartItems.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(Constants.imgUrl + cart.cartItems[index].burg.picture)),
              title: Text('${cart.cartItems[index].burg.name}',
                  style: subtitleStyle),
              subtitle: Text('RM.  ${cart.cartItems[index].burg.harga}'),
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
}
