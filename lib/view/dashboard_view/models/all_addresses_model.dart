import 'dart:convert';

class AllAddressesModel {
  String? name;
  String? postcode;
  double? lat;
  double? lon;

  AllAddressesModel({
    this.name,
    this.postcode,
    this.lat,
    this.lon,
  });

  factory AllAddressesModel.fromRawJson(String str) => AllAddressesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllAddressesModel.fromJson(Map<String, dynamic> json) => AllAddressesModel(
    name: json["name"],
    postcode: json["postcode"],
    lat: double.parse(json["lat"].toString()),
    lon: double.parse(json["lon"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "postcode": postcode,
    "lat": lat,
    "lon": lon,
  };
}
