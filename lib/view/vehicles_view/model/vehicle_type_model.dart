// To parse this JSON data, do
//
//     final vehicleTypeModel = vehicleTypeModelFromJson(jsonString);

import 'dart:convert';

VehicleTypeModel vehicleTypeModelFromJson(String str) => VehicleTypeModel.fromJson(json.decode(str));

String vehicleTypeModelToJson(VehicleTypeModel data) => json.encode(data.toJson());

class VehicleTypeModel {
    bool? status;
    int? count;
    List<VehicleType>? vehicleTypes;

    VehicleTypeModel({
        this.status,
        this.count,
        this.vehicleTypes,
    });

    factory VehicleTypeModel.fromJson(Map<String, dynamic> json) => VehicleTypeModel(
        status: json["status"],
        count: json["count"],
        vehicleTypes: json["vehicle_types"] == null ? [] : List<VehicleType>.from(json["vehicle_types"]!.map((x) => VehicleType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
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
    String? minimumFares;
    String? minimumMiles;
    String? waitingTime;
    String? waitingTimeDuration;
    bool? defaultVehicle;
    bool? vehicleTypeMinimumFares;
    String? image;
    DateTime? createdAt;
    DateTime? updatedAt;

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
    });

    factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json["id"],
        name: json["name"],
        passengers: json["passengers"],
        luggages: json["luggages"],
        handLuggages: json["hand_luggages"],
        minimumFares: json["minimum_fares"],
        minimumMiles: json["minimum_miles"],
        waitingTime: json["waiting_time"],
        waitingTimeDuration: json["waiting_time_duration"],
        defaultVehicle: json["default_vehicle"],
        vehicleTypeMinimumFares: json["vehicle_type_minimum_fares"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
