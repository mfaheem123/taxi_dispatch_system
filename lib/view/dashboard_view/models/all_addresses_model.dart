import 'dart:convert';

class AllAddressesModel {
  String? name;
  String? postcode;
  String? area;
  String? district;
  String? sector;
  String? unit;
  String? type;
  double? lat;
  double? lon;

  AllAddressesModel({
    this.name,
    this.postcode,
    this.area,
    this.district,
    this.sector,
    this.unit,
    this.type,
    this.lat,
    this.lon,
  });

  factory AllAddressesModel.fromRawJson(String str) => AllAddressesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllAddressesModel.fromJson(Map<String, dynamic> json) => AllAddressesModel(
    name: json["name"],
    postcode: json["postcode"],
    area: json["area"],
    district: json["district"],
    sector: json["sector"],
    unit: json["unit"],
    type: json["type"],
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "postcode": postcode,
    "area": area,
    "district": district,
    "sector": sector,
    "unit": unit,
    "type": type,
    "lat": lat,
    "lon": lon,
  };
}
