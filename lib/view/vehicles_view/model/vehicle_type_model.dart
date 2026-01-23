// To parse this JSON data, do
//
//     final vehicleTypeModel = vehicleTypeModelFromJson(jsonString);

import 'dart:convert';

VehicleTypeModel vehicleTypeModelFromJson(String str) => VehicleTypeModel.fromJson(json.decode(str));

String vehicleTypeModelToJson(VehicleTypeModel data) => json.encode(data.toJson());

class VehicleTypeModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<VehicleType>? vehicleTypes;

  VehicleTypeModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.vehicleTypes,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
    status: json["status"],
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["total_pages"],
    count: json["count"],
    vehicleTypes: json["vehicle_types"] == null ? [] : List<VehicleType>.from(json["vehicle_types"]!.map((x) => VehicleType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "vehicle_types": vehicleTypes == null ? [] : List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
  };
}

class VehicleType {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? handLuggages;
  double? minimumFares;
  int? minimumMiles;
  int? waitingTime;
  int? waitingTimeDuration;
  bool? defaultVehicle;
  bool? vehicleTypeMinimumFares;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? backgroundColor;
  String? foregroundColor;
  int? driverWaitingCharges;
  int? accountWaitingCharges;

  VehicleType({
    this.id,
    this.name,
    this.passengers,
    this.luggages,
    this.handLuggages,
    this.minimumFares,
    this.minimumMiles,
    this.waitingTime,
    this.waitingTimeDuration,
    this.defaultVehicle,
    this.vehicleTypeMinimumFares,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.backgroundColor,
    this.foregroundColor,
    this.driverWaitingCharges,
    this.accountWaitingCharges,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    id: json["id"],
    name: json["name"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    handLuggages: json["hand_luggages"],
    minimumFares: json["minimum_fares"]?.toDouble(),
    minimumMiles: json["minimum_miles"],
    waitingTime: json["waiting_time"],
    waitingTimeDuration: json["waiting_time_duration"],
    defaultVehicle: json["default_vehicle"],
    vehicleTypeMinimumFares: json["vehicle_type_minimum_fares"],
    image: json["image"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    driverWaitingCharges: json["driver_waiting_charges"],
    accountWaitingCharges: json["account_waiting_charges"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "passengers": passengers,
    "luggages": luggages,
    "hand_luggages": handLuggages,
    "minimum_fares": minimumFares,
    "minimum_miles": minimumMiles,
    "waiting_time": waitingTime,
    "waiting_time_duration": waitingTimeDuration,
    "default_vehicle": defaultVehicle,
    "vehicle_type_minimum_fares": vehicleTypeMinimumFares,
    "image": image,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "driver_waiting_charges": driverWaitingCharges,
    "account_waiting_charges": accountWaitingCharges,
  };
}
