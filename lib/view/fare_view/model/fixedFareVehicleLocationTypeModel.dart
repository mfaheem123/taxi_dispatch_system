// To parse this JSON data, do
//
//     final fixedFareVehicleLocationTypeModel = fixedFareVehicleLocationTypeModelFromJson(jsonString);

import 'dart:convert';

FixedFareVehicleLocationTypeModel fixedFareVehicleLocationTypeModelFromJson(String str) => FixedFareVehicleLocationTypeModel.fromJson(json.decode(str));

String fixedFareVehicleLocationTypeModelToJson(FixedFareVehicleLocationTypeModel data) => json.encode(data.toJson());

class FixedFareVehicleLocationTypeModel {
  bool? status;
  String? message;
  int? vehicleTypesCount;
  int? locationTypesCount;
  List<VehicleTypeFixed>? vehicleTypesFixed;
  List<LocationType>? locationTypes;

  FixedFareVehicleLocationTypeModel({
    this.status,
    this.message,
    this.vehicleTypesCount,
    this.locationTypesCount,
    this.vehicleTypesFixed,
    this.locationTypes,
  });

  factory FixedFareVehicleLocationTypeModel.fromJson(Map<String, dynamic> json) => FixedFareVehicleLocationTypeModel(
    status: json["status"],
    message: json["message"],
    vehicleTypesCount: json["vehicle_types_count"],
    locationTypesCount: json["location_types_count"],
    vehicleTypesFixed: json["vehicle_types"] == null ? [] : List<VehicleTypeFixed>.from(json["vehicle_types"]!.map((x) => VehicleTypeFixed.fromJson(x))),
    locationTypes: json["location_types"] == null ? [] : List<LocationType>.from(json["location_types"]!.map((x) => LocationType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "vehicle_types_count": vehicleTypesCount,
    "location_types_count": locationTypesCount,
    "vehicle_types": vehicleTypesFixed == null ? [] : List<dynamic>.from(vehicleTypesFixed!.map((x) => x.toJson())),
    "location_types": locationTypes == null ? [] : List<dynamic>.from(locationTypes!.map((x) => x.toJson())),
  };
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;

  LocationType({this.id, this.name, this.shortcut});

  // Ye do functions add karein:
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"],
    name: json["name"],
    shortcut: json["shortcut"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "shortcut": shortcut};
}

class  VehicleTypeFixed {
  int? id;
  String? name;

  VehicleTypeFixed({
    this.id,
    this.name,
  });

  factory VehicleTypeFixed.fromJson(Map<String, dynamic> json) => VehicleTypeFixed(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
