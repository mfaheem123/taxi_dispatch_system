

// To parse this JSON data, do
//
//     final getAllFareConfigurationModel = getAllFareConfigurationModelFromJson(jsonString);

import 'dart:convert';

GetAllFareConfigurationModel getAllFareConfigurationModelFromJson(String str) => GetAllFareConfigurationModel.fromJson(json.decode(str));

String getAllFareConfigurationModelToJson(GetAllFareConfigurationModel data) => json.encode(data.toJson());

class GetAllFareConfigurationModel {
  bool? status;
  int? count;
  List<FareConfiguration>? fareConfigurations;

  GetAllFareConfigurationModel({
    this.status,
    this.count,
    this.fareConfigurations,
  });

  factory GetAllFareConfigurationModel.fromJson(Map<String, dynamic> json) => GetAllFareConfigurationModel(
    status: json["status"],
    count: json["count"],
    fareConfigurations: List<FareConfiguration>.from(json["fare_configurations"].map((x) => FareConfiguration.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "fare_configurations": List<dynamic>.from(fareConfigurations!.map((x) => x.toJson())),
  };
}

class FareConfiguration {
  int? id;
  int? vehicleTypeId;
  int? accountId;
  String? fromDay;
  String? toDay;
  String? fromTime;
  String? toTime;
  num? minimumFares;
  num? minimumMiles;
  String? fromDate;
  String? toDate;
  String? title;
  GetFareConfigVehicleType? vehicleType;
  GetFareConfigAccount? account;

  FareConfiguration({
    this.id,
    this.vehicleTypeId,
    this.accountId,
    this.fromDay,
    this.toDay,
    this.fromTime,
    this.toTime,
    this.minimumFares,
    this.minimumMiles,
    this.fromDate,
    this.toDate,
    this.title,
    this.vehicleType,
    this.account,
  });

  factory FareConfiguration.fromJson(Map<String, dynamic> json) => FareConfiguration(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    accountId: json["account_id"],
    fromDay: json["from_day"],
    toDay: json["to_day"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    // double.parse ki jagah num.tryParse use karen safety ke liye
    minimumFares: json["minimum_fares"] != null ? num.tryParse(json["minimum_fares"].toString()) ?? 0.0 : 0.0,
    minimumMiles: json["minimum_miles"] != null ? num.tryParse(json["minimum_miles"].toString()) ?? 0.0 : 0.0,
    fromDate: json["from_date"],
    toDate: json["to_date"],
    title: json["title"],
    // Object null check lazmi hai
    vehicleType: json["vehicle_type"] == null ? null : GetFareConfigVehicleType.fromJson(json["vehicle_type"]),
    account: json["account"] == null ? null : GetFareConfigAccount.fromJson(json["account"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "account_id": accountId,
    "from_day": fromDay,
    "to_day": toDay,
    "from_time": fromTime,
    "to_time": toTime,
    "minimum_fares": minimumFares,
    "minimum_miles": minimumMiles,
    "from_date": fromDate,
    "to_date": toDate,
    "title": title,
    "vehicle_type": vehicleType!.toJson(),
    "account": account!.toJson(),
  };
}

class GetFareConfigAccount {
  String? name;

  GetFareConfigAccount({
    this.name,
  });

  factory GetFareConfigAccount.fromJson(Map<String, dynamic> json) => GetFareConfigAccount(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class GetFareConfigVehicleType {
  num? minimumFares;
  String? name;

  GetFareConfigVehicleType({
    this.minimumFares,
    this.name,
  });

  factory GetFareConfigVehicleType.fromJson(Map<String, dynamic> json) => GetFareConfigVehicleType(
    minimumFares: json["minimum_fares"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "minimum_fares": minimumFares,
    "name": name,
  };
}
