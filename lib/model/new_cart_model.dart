class Keranjang {
  int id;
  String nama;
  String qty;
  String prodid;

  Keranjang({this.id, this.nama, this.qty, this.prodid});

  factory Keranjang.fromMap(Map<String, dynamic> json) =>
      new Keranjang(id: json["id"], nama: json["nama"], qty: json["qty"], prodid: json['prodid']);

  Map<String, dynamic> toMap() => {"id": id, "nama": nama, "qty": qty, "prodid": prodid};


}


