// To parse this JSON data, do
//
//     final driverFormModel = driverFormModelFromJson(jsonString);

import 'dart:convert';

DriverFormModel driverFormModelFromJson(String str) => DriverFormModel.fromJson(json.decode(str));

String driverFormModelToJson(DriverFormModel data) => json.encode(data.toJson());

class DriverFormModel {
  bool? status;
  String? message;
  int? vehicleTypesCount;
  int? companyVehiclesCount;
  int? subsidiariesCount;
  List<SubsidiaryObject>? vehicleTypes;
  List<CompanyVehicleObject>? companyVehicles;
  List<SubsidiaryObject>? subsidiaries;

  DriverFormModel({
    this.status,
    this.message,
    this.vehicleTypesCount,
    this.companyVehiclesCount,
    this.subsidiariesCount,
    this.vehicleTypes,
    this.companyVehicles,
    this.subsidiaries,
  });

  factory DriverFormModel.fromJson(Map<String, dynamic> json) => DriverFormModel(
    status: json["status"],
    message: json["message"],
    vehicleTypesCount: json["vehicle_types_count"],
    companyVehiclesCount: json["company_vehicles_count"],
    subsidiariesCount: json["subsidiaries_count"],
    vehicleTypes: List<SubsidiaryObject>.from(json["vehicle_types"].map((x) => SubsidiaryObject.fromJson(x))),
    companyVehicles: List<CompanyVehicleObject>.from(json["company_vehicles"].map((x) => CompanyVehicleObject.fromJson(x))),
    subsidiaries: List<SubsidiaryObject>.from(json["subsidiaries"].map((x) => SubsidiaryObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "vehicle_types_count": vehicleTypesCount,
    "company_vehicles_count": companyVehiclesCount,
    "subsidiaries_count": subsidiariesCount,
    "vehicle_types": List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "company_vehicles": List<dynamic>.from(companyVehicles!.map((x) => x.toJson())),
    "subsidiaries": List<dynamic>.from(subsidiaries!.map((x) => x.toJson())),
  };
}

class CompanyVehicleObject {
  int? id;
  String? vehicleTypeName;

  CompanyVehicleObject({
    this.id,
    this.vehicleTypeName,
  });

  factory CompanyVehicleObject.fromJson(Map<String, dynamic> json) => CompanyVehicleObject(
    id: json["id"],
    vehicleTypeName: json["vehicle_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_name": vehicleTypeName,
  };
}

class SubsidiaryObject {
  int? id;
  String? name;

  SubsidiaryObject({
    this.id,
    this.name,
  });

  factory SubsidiaryObject.fromJson(Map<String, dynamic> json) => SubsidiaryObject(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
