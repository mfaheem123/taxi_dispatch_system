// To parse this JSON data, do
//
//     final getAirPortChargesModel = getAirPortChargesModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

GetAirPortChargesModel getAirPortChargesModelFromJson(String str) => GetAirPortChargesModel.fromJson(json.decode(str));

String getAirPortChargesModelToJson(GetAirPortChargesModel data) => json.encode(data.toJson());

class GetAirPortChargesModel {
  bool? status;
  int? count;
  List<Location>? locations;

  GetAirPortChargesModel({
    this.status,
    this.count,
    this.locations,
  });

  factory GetAirPortChargesModel.fromJson(Map<String, dynamic> json) => GetAirPortChargesModel(
    status: json["status"],
    count: json["count"],
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}

class Location {
  int? id;
  String? name;
  int? locationTypeId;
  String? address;
  String? postcode;
  dynamic zoneId;
  String? shortcut;
  dynamic backgroundColor;
  dynamic foregroundColor;
  String? extraCharges;
  String? pickupCharges;
  String? dropoffCharges;
  bool? blacklist;
  String? latitude;
  String? longitude;
  LocationType? locationType;

  Location({
    this.id,
    this.name,
    this.locationTypeId,
    this.address,
    this.postcode,
    this.zoneId,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
    this.extraCharges,
    this.pickupCharges,
    this.dropoffCharges,
    this.blacklist,
    this.latitude,
    this.longitude,
    this.locationType,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    name: json["name"],
    locationTypeId: json["location_type_id"],
    address: json["address"],
    postcode: json["postcode"],
    zoneId: json["zone_id"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    extraCharges: json["extra_charges"],
    pickupCharges: json["pickup_charges"],
    dropoffCharges: json["dropoff_charges"],
    blacklist: json["blacklist"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    locationType: json["location_type"] == null ? null : LocationType.fromJson(json["location_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type_id": locationTypeId,
    "address": address,
    "postcode": postcode,
    "zone_id": zoneId,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "extra_charges": extraCharges,
    "pickup_charges": pickupCharges,
    "dropoff_charges": dropoffCharges,
    "blacklist": blacklist,
    "latitude": latitude,
    "longitude": longitude,
    "location_type": locationType?.toJson(),
  };
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;

  LocationType({
    this.id,
    this.name,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"],
    name: json["name"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}
