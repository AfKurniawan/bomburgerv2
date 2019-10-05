import 'package:bomburger/pages/new_home_page.dart';
import 'package:bomburger/pages/read_write_data_page_example.dart';
import 'package:flutter/material.dart';
import 'package:bomburger/model/cart_model.dart';
import 'package:bomburger/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => MyCart(),
      child: MaterialApp(
        title: 'Flutter Food Ordering',
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NewHomePage(),
      ),
    );
  }
}
