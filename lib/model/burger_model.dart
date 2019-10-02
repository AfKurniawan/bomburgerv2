class Burger {
  String id;
  String name;
  String picture;
  String price;
  double harga;
  String stock_quantity;

  Burger({this.id, this.name, this.picture, this.price, this.stock_quantity, this.harga});


  factory Burger.fromJson(Map<String, dynamic> json){


    return Burger(

      id:json['id'],
      name:json['name'],
      picture: json['picture'],
      price: json['price'],
      harga: double.parse(json['price']),
      stock_quantity: json['stock_quantity']
    );
  }
}
