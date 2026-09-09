// To parse this JSON data, do
//
//     final getDriverSinBin = getDriverSinBinFromJson(jsonString);

import 'dart:convert';

GetDriverSinBin getDriverSinBinFromJson(String str) => GetDriverSinBin.fromJson(json.decode(str));

String getDriverSinBinToJson(GetDriverSinBin data) => json.encode(data.toJson());

class GetDriverSinBin {
  bool? status;
  int? count;
  List<Driver>? drivers;

  GetDriverSinBin({
    this.status,
    this.count,
    this.drivers,
  });

  factory GetDriverSinBin.fromJson(Map<String, dynamic> json) => GetDriverSinBin(
    status: json["status"],
    count: json["count"],
    drivers: json["drivers"] == null ? [] : List<Driver>.from(json["drivers"]!.map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "drivers": drivers == null ? [] : List<dynamic>.from(drivers!.map((x) => x.toJson())),
  };
}

class Driver {
  int? id;
  String? username;
  String? name;
  String? mobile;
  Vehicle? vehicle;

  Driver({
    this.id,
    this.username,
    this.name,
    this.mobile,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    mobile: json["mobile"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "mobile": mobile,
    "vehicle": vehicle?.toJson(),
  };
}

class Vehicle {
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  VehicleType? vehicleType;

  Vehicle({
    this.vehicleNumber,
    this.make,
    this.model,
    this.color,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    vehicleNumber: json["vehicle_number"],
    make: json["make"],
    model: json["model"],
    color: json["color"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "vehicle_number": vehicleNumber,
    "make": make,
    "model": model,
    "color": color,
    "vehicle_type": vehicleType?.toJson(),
  };
}

class VehicleType {
  int? id;
  String? name;
  int? passengers;
  int? luggages;

  VehicleType({
    this.id,
    this.name,
    this.passengers,
    this.luggages,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    id: json["id"],
    name: json["name"],
    passengers: json["passengers"],
    luggages: json["luggages"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "passengers": passengers,
    "luggages": luggages,
  };
}
