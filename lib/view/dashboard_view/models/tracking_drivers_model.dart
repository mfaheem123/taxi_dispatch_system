import 'dart:convert';

GetAllLabelsFromWidowModel getAllLabelsFromWidowModelFromJson(String str) => GetAllLabelsFromWidowModel.fromJson(json.decode(str));

String getAllLabelsFromWidowModelToJson(GetAllLabelsFromWidowModel data) => json.encode(data.toJson());

class GetAllLabelsFromWidowModel {
  bool? status;
  List<TrackingDriverObject>? trackingDrivers;

  GetAllLabelsFromWidowModel({
    this.status,
    this.trackingDrivers,
  });

  factory GetAllLabelsFromWidowModel.fromJson(Map<String, dynamic> json) => GetAllLabelsFromWidowModel(
    status: json["status"],
    trackingDrivers: List<TrackingDriverObject>.from(json["tracking_drivers"].map((x) => TrackingDriverObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "tracking_drivers": List<dynamic>.from(trackingDrivers!.map((x) => x.toJson())),
  };
}

class TrackingDriverObject {
  int? id;
  String? name;
  String? username;
  dynamic zone;
  String? latitude;
  String? longitude;
  String? bookingStatus;
  String? sessionStatus;
  String? driverStatus;
  dynamic lastLoginAt;
  String? vehicleType;

  TrackingDriverObject({
    this.id,
    this.name,
    this.username,
    this.zone,
    this.latitude,
    this.longitude,
    this.bookingStatus,
    this.sessionStatus,
    this.driverStatus,
    this.lastLoginAt,
    this.vehicleType,
  });

  factory TrackingDriverObject.fromJson(Map<String, dynamic> json) => TrackingDriverObject(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    zone: json["zone"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    bookingStatus: json["booking_status"],
    sessionStatus: json["session_status"],
    driverStatus: json["driver_status"],
    lastLoginAt: json["last_login_at"],
    vehicleType: json["vehicle_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "zone": zone,
    "latitude": latitude,
    "longitude": longitude,
    "booking_status": bookingStatus,
    "session_status": sessionStatus,
    "driver_status": driverStatus,
    "last_login_at": lastLoginAt,
    "vehicle_type": vehicleType,
  };
}
