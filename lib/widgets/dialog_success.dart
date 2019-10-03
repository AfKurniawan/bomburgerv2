
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../pages/home_page.dart';

ProgressDialog pd;

class DialogSuccess extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              )
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              CircleAvatar(radius: 55, backgroundColor: Colors.white,
                child: Image.asset('assets/checked.png', width: 60,),),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("Success!", style: Theme.of(context).textTheme.title,),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text(
                          "Transaction successfully added"),
                    ),
                    SizedBox(height: 10.0),
                    Row(children: <Widget>[

                      SizedBox(width: 10.0),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Oke"),
                          color: Colors.green,
                          colorBrightness: Brightness.dark,
                          onPressed: (){
                            //Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                            pd.hide();
                            },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ],)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}