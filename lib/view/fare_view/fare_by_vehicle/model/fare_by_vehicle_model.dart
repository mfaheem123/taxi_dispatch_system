// To parse this JSON data, do
//
//     final fareByVehicleSetting = fareByVehicleSettingFromJson(jsonString);

import 'dart:convert';

FareByVehicleSetting fareByVehicleSettingFromJson(String str) => FareByVehicleSetting.fromJson(json.decode(str));

String fareByVehicleSettingToJson(FareByVehicleSetting data) => json.encode(data.toJson());

class FareByVehicleSetting {
  bool? status;
  int? count;
  List<FareByVehicle>? fareByVehicles;

  FareByVehicleSetting({
    this.status,
    this.count,
    this.fareByVehicles,
  });

  factory FareByVehicleSetting.fromJson(Map<String, dynamic> json) => FareByVehicleSetting(
    status: json["status"],
    count: json["count"],
    fareByVehicles: json["fare_by_vehicles"] == null ? [] : List<FareByVehicle>.from(json["fare_by_vehicles"]!.map((x) => FareByVehicle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "fare_by_vehicles": fareByVehicles == null ? [] : List<dynamic>.from(fareByVehicles!.map((x) => x.toJson())),
  };
}

class FareByVehicle {
  int? id;
  int? vehicleTypeId;
  String? fareByVehicleOperator;
  String? value;
  String? createdAt;
  dynamic updatedAt;
  VehicleType? vehicleType;

  FareByVehicle({
    this.id,
    this.vehicleTypeId,
    this.fareByVehicleOperator,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.vehicleType,
  });

  factory FareByVehicle.fromJson(Map<String, dynamic> json) => FareByVehicle(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    fareByVehicleOperator: json["operator"],
    value: json["value"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "operator": fareByVehicleOperator,
    "value": value,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "vehicle_type": vehicleType?.toJson(),
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
