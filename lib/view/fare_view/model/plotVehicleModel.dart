// To parse this JSON data, do
//
//     final plotVehicleTypeModel = plotVehicleTypeModelFromJson(jsonString);

import 'dart:convert';

PlotVehicleTypeModel plotVehicleTypeModelFromJson(String str) => PlotVehicleTypeModel.fromJson(json.decode(str));

String plotVehicleTypeModelToJson(PlotVehicleTypeModel data) => json.encode(data.toJson());

class PlotVehicleTypeModel {
  bool? status;
  String? message;
  int? vehicleTypesCount;
  int? zonesCount;
  List<VehicleTypee>? vehicleTypes;
  List<Zonee>? zones;

  PlotVehicleTypeModel({
    this.status,
    this.message,
    this.vehicleTypesCount,
    this.zonesCount,
    this.vehicleTypes,
    this.zones,
  });

  factory PlotVehicleTypeModel.fromJson(Map<String, dynamic> json) => PlotVehicleTypeModel(
    status: json["status"],
    message: json["message"],
    vehicleTypesCount: json["vehicle_types_count"],
    zonesCount: json["zones_count"],
    vehicleTypes: json["vehicle_types"] == null ? [] : List<VehicleTypee>.from(json["vehicle_types"]!.map((x) => VehicleTypee.fromJson(x))),
    zones: json["zones"] == null ? [] : List<Zonee>.from(json["zones"]!.map((x) => Zonee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "vehicle_types_count": vehicleTypesCount,
    "zones_count": zonesCount,
    "vehicle_types": vehicleTypes == null ? [] : List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x.toJson())),
  };
}

class VehicleTypee {
  int? id;
  String? name;

  VehicleTypee({
    this.id,
    this.name,
  });

  factory VehicleTypee.fromJson(Map<String, dynamic> json) => VehicleTypee(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Zonee {
  int? id;
  String? name;
  String? secondaryName;

  Zonee({
    this.id,
    this.name,
    this.secondaryName,
  });

  factory Zonee.fromJson(Map<String, dynamic> json) => Zonee(
    id: json["id"],
    name: json["name"],
    secondaryName: json["secondary_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "secondary_name": secondaryName,
  };

}