// To parse this JSON data, do
//
//     final locationShortCutModel = locationShortCutModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

LocationShortCutModel locationShortCutModelFromJson(String str) => LocationShortCutModel.fromJson(json.decode(str));

String locationShortCutModelToJson(LocationShortCutModel data) => json.encode(data.toJson());

class LocationShortCutModel {
  String? message;
  bool? status;
  int? count;
  List<LocationType>? locationTypes;

  LocationShortCutModel({
    this.message,
    this.status,
    this.count,
    this.locationTypes,
  });

  factory LocationShortCutModel.fromJson(Map<String, dynamic> json) => LocationShortCutModel(
    message: json["message"],
    status: json["status"],
    count: json["count"],
    locationTypes: List<LocationType>.from(json["location_types"].map((x) => LocationType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "count": count,
    "location_types": List<dynamic>.from(locationTypes!.map((x) => x.toJson())),
  };
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;
  Color? backgroundColor;
  Color? foregroundColor;
  TextEditingController? controller = TextEditingController();

  LocationType({
    this.id,
    this.name,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
    this.controller,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"],
    name: json["name"],
    shortcut: json ["shortcut"],
    // backgroundColor: Color(0xff0537ff),
    backgroundColor: Color(
      int.parse("0xff${json["background_color"].toString()}"),),

    foregroundColor: Color(
  int.parse("0xff${json["foreground_color"].toString().replaceAll('#',"")}"),),
    controller: TextEditingController(text: json["shortcut"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "controller": controller,
  };
}
