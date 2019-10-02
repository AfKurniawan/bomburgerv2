import 'package:flutter/material.dart';

//color
Color mainColor = Color.fromRGBO(255, 204, 0, 1);

//Style
final headerStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
final titleStyleName = TextStyle(fontSize: 13,  color: Colors.black54, fontWeight: FontWeight.bold);
final titleStylePrice = TextStyle(fontSize: 12, color: Colors.red);
final subtitleStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

//Decoration
final roundedRectangle12 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(12),
);

final roundedRectangle4 = RoundedRectangleBorder(
  borderRadius: BorderRadiusDirectional.circular(4),
);

final roundedRectangle40 = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
);
