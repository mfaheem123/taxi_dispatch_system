



// To parse this JSON data, do
//
//     final airPortChargesModel = airPortChargesModelFromJson(jsonString);

import 'dart:convert';

import '../model/getAirPortChargesModel.dart';

AirPortChargesModel airPortChargesModelFromJson(String str) => AirPortChargesModel.fromJson(json.decode(str));

String airPortChargesModelToJson(AirPortChargesModel data) => json.encode(data.toJson());

class AirPortChargesModel {
  bool? status;
  int? count;
  List<Location>? locations;

  AirPortChargesModel({
    this.status,
    this.count,
    this.locations,
  });

  factory AirPortChargesModel.fromJson(Map<String, dynamic> json) => AirPortChargesModel(
    status: json["status"],
    count: json["count"],
    locations: List<Location>.from(json["locations"].map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "locations": List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}
