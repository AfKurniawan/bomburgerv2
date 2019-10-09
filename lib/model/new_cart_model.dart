/*class Keranjang {
  int id;
  String nama;
  String qty;
  String prodid;

  Keranjang({this.id, this.nama, this.qty, this.prodid});

  factory Keranjang.fromMap(Map<String, dynamic> json) =>
      new Keranjang(id: json["id"], nama: json["nama"], qty: json["qty"], prodid: json['prodid']);

  Map<String, dynamic> toMap() => {"id": id, "nama": nama, "qty": qty, "prodid": prodid};


}*/
class Keranjang {
  int _id;
  String _nama;
  int _qty;
  String _img;
  String _prodid;

  Keranjang(this._id, this._nama, this._qty, this._prodid);

  Keranjang.map(dynamic obj) {
    this._id = obj['id'];
    this._nama = obj['nama'];
    this._qty = obj['qty'];
    this._img = obj['img'];
    this._prodid = obj['prodid'];

  }

  int get id => _id;
  String get nama => _nama;
  int get qty => _qty;
  String get img => _img;
  String get proidid => _prodid;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nama'] = _nama;
    map['qty'] = _qty;
    map['img'] = _img;
    map['prodid'] = _prodid;

    return map;
  }

  Keranjang.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nama = map['nama'];
    this._qty = map['qty'];
    this._img = map['img'];
    this._prodid = map['prodid'];
  }
}

