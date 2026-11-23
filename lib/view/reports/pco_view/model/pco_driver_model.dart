// To parse this JSON data, do
//
//     final pcoDriverModel = pcoDriverModelFromJson(jsonString);

import 'dart:convert';

PcoDriverModel pcoDriverModelFromJson(String str) => PcoDriverModel.fromJson(json.decode(str));

String pcoDriverModelToJson(PcoDriverModel data) => json.encode(data.toJson());

class PcoDriverModel {
  bool? status;
  List<Booking>? bookings;

  PcoDriverModel({
    this.status,
    this.bookings,
  });

  factory PcoDriverModel.fromJson(Map<String, dynamic> json) => PcoDriverModel(
    status: json["status"],
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  int? driverId;
  String? username;
  String? phcDriverNumber;
  String? firstName;
  String? lastName;
  String? driverName;
  String? vehicleNumber;
  String? vehicleType;
  String? count;

  Booking({
    this.driverId,
    this.username,
    this.phcDriverNumber,
    this.firstName,
    this.lastName,
    this.driverName,
    this.vehicleNumber,
    this.vehicleType,
    this.count,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    driverId: json["driver_id"],
    username: json["username"],
    phcDriverNumber: json["phc_driver_number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    driverName: json["driver_name"],
    vehicleNumber: json["vehicle_number"],
    vehicleType: json["vehicle_type"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "username": username,
    "phc_driver_number": phcDriverNumber,
    "first_name": firstName,
    "last_name": lastName,
    "driver_name": driverName,
    "vehicle_number": vehicleNumber,
    "vehicle_type": vehicleType,
    "count": count,
  };
}
