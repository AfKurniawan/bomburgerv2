import 'package:flutter/material.dart';
class Constants{

  static const String baseUrl     = "http://outlet.bomburger.my/";
  //static const String baseUrl     = "http://192.168.43.143/bomburger.my/";

  static const String burgerUrl   = baseUrl + "api_ci/index.php/burgers";
  static const String drinkUrl    = baseUrl + "api_ci/index.php/drinks";


  static const String imgUrl      = baseUrl + "uploads/products/";


  //static const String imgUrl      = baseUrl + "management/uploads/products/";
  static const String loginUrl    = baseUrl + "api_ci/index.php/auth";
  static const String addSalesUrl = baseUrl + "api_ci/index.php/addsales";
  static const String addSalesItem = baseUrl + "api_ci/index.php/addsalesitem";


  static const String STORE_ID = 'store_id';
  static const String USER_ID = 'user_id';


  static String appName = "Flutter Travel";

  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor:  lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: lightAccent,
//      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}