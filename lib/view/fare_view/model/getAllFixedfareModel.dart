// To parse this JSON data, do
//
//     final getAllFixedFareModel = getAllFixedFareModelFromJson(jsonString);

import 'dart:convert';

GetAllFixedFareModel getAllFixedFareModelFromJson(String str) => GetAllFixedFareModel.fromJson(json.decode(str));

String getAllFixedFareModelToJson(GetAllFixedFareModel data) => json.encode(data.toJson());

class GetAllFixedFareModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<FixedFare>? fixedFares;

  GetAllFixedFareModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.fixedFares,
  });

  factory GetAllFixedFareModel.fromJson(Map<String, dynamic> json) => GetAllFixedFareModel(
    status: json["status"],
    page: json["page"],
    limit: json['limit'],
    total: json['total'],
    totalPages: json['total_pages'],
    count: json["count"],
    fixedFares: json["fixed_fares"] == null ? [] : List<FixedFare>.from(json["fixed_fares"]!.map((x) => FixedFare.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "fixed_fares": fixedFares == null ? [] : List<dynamic>.from(fixedFares!.map((x) => x.toJson())),
  };
}

class FixedFare {
  int? id;
  int? vehicleTypeId;
  String? fares;
  String? area1;
  String? area2;
  int? fromLocationId;
  int? toLocationId;
  String? createdAt;
  String? updatedAt;
  String? vehicleTypeName;

  FixedFare({
    this.id,
    this.vehicleTypeId,
    this.fares,
    this.area1,
    this.area2,
    this.fromLocationId,
    this.toLocationId,
    this.createdAt,
    this.updatedAt,
    this.vehicleTypeName,
  });

  factory FixedFare.fromJson(Map<String, dynamic> json) => FixedFare(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    fares: json["fares"],
    area1: json["area1"],
    area2: json["area2"],
    fromLocationId: json["from_location_id"],
    toLocationId: json["to_location_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    vehicleTypeName: json["vehicle_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "fares": fares,
    "area1": area1,
    "area2": area2,
    "from_location_id": fromLocationId,
    "to_location_id": toLocationId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "vehicle_type_name": vehicleTypeName,
  };
}
