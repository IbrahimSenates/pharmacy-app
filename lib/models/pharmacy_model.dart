class PharmacyModel {
  final String isim;
  final String ilce;
  final String adres;
  final String telefon;

  PharmacyModel(this.isim, this.ilce, this.adres, this.telefon);

  PharmacyModel.fromJson(Map<String, dynamic> json)
    : isim = json['name'],
      ilce = json['dist'],
      adres = json['address'],
      telefon = json['phone'];
}
