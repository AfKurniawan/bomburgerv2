class Keranjang {
  int id;
  String nama;
  String qty;

  Keranjang({this.id, this.nama, this.qty});

  factory Keranjang.fromMap(Map<String, dynamic> json) =>
      new Keranjang(id: json["id"], nama: json["nama"], qty: json["qty"]);

  Map<String, dynamic> toMap() => {"id": id, "nama": nama, "qty": qty};


}
