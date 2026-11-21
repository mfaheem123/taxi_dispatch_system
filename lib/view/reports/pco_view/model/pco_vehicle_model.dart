// To parse this JSON data, do
//
//     final pcoVehicleModel = pcoVehicleModelFromJson(jsonString);

import 'dart:convert';

PcoVehicleModel pcoVehicleModelFromJson(String str) => PcoVehicleModel.fromJson(json.decode(str));

String pcoVehicleModelToJson(PcoVehicleModel data) => json.encode(data.toJson());

class PcoVehicleModel {
  bool? status;
  List<Booking>? bookings;

  PcoVehicleModel({
    this.status,
    this.bookings,
  });

  factory PcoVehicleModel.fromJson(Map<String, dynamic> json) => PcoVehicleModel(
    status: json["status"],
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  int? vehicleId;
  String? vehicleNumber;
  String? vehicleMake;
  String? vehicleType;
  String? phcVehicleNumber;
  String? count;

  Booking({
    this.vehicleId,
    this.vehicleNumber,
    this.vehicleMake,
    this.vehicleType,
    this.phcVehicleNumber,
    this.count,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    vehicleId: json["vehicle_id"],
    vehicleNumber: json["vehicle_number"],
    vehicleMake: json["vehicle_make"],
    vehicleType: json["vehicle_type"],
    phcVehicleNumber: json["phc_vehicle_number"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "vehicle_id": vehicleId,
    "vehicle_number": vehicleNumber,
    "vehicle_make": vehicleMake,
    "vehicle_type": vehicleType,
    "phc_vehicle_number": phcVehicleNumber,
    "count": count,
  };
}
