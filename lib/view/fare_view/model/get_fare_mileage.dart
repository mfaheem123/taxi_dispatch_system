// To parse this JSON data, do
//
//     final getFareMileageModel = getFareMileageModelFromJson(jsonString);

import 'dart:convert';

GetFareMileageModel getFareMileageModelFromJson(String str) => GetFareMileageModel.fromJson(json.decode(str));

String getFareMileageModelToJson(GetFareMileageModel data) => json.encode(data.toJson());

class GetFareMileageModel {
  bool? status;
  List<FareConfigurationsMileage>? fareConfigurationsMileage;

  GetFareMileageModel({
    this.status,
    this.fareConfigurationsMileage,
  });

  factory GetFareMileageModel.fromJson(Map<String, dynamic> json) => GetFareMileageModel(
    status: json["status"],
    fareConfigurationsMileage: json["fareConfigurationsMileage"] == null ? [] : List<FareConfigurationsMileage>.from(json["fareConfigurationsMileage"]!.map((x) => FareConfigurationsMileage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "fareConfigurationsMileage": fareConfigurationsMileage == null ? [] : List<dynamic>.from(fareConfigurationsMileage!.map((x) => x.toJson())),
  };
}

class FareConfigurationsMileage {
  int? id;
  int? companyId;
  String? maximumMiles;
  String? minimumMiles;
  String? fares;
  DateTime? createdAt;
  DateTime? updatedAt;

  FareConfigurationsMileage({
    this.id,
    this.companyId,
    this.maximumMiles,
    this.minimumMiles,
    this.fares,
    this.createdAt,
    this.updatedAt,
  });

  factory FareConfigurationsMileage.fromJson(Map<String, dynamic> json) => FareConfigurationsMileage(
    id: json["id"],
    companyId: json["company_id"],
    maximumMiles: json["maximum_miles"],
    minimumMiles: json["minimum_miles"],
    fares: json["fares"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "maximum_miles": maximumMiles,
    "minimum_miles": minimumMiles,
    "fares": fares,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
