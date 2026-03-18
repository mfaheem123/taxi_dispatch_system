// To parse this JSON data, do
//
//     final listDriverRentModel = listDriverRentModelFromJson(jsonString);

import 'dart:convert';

ListDriverRentModel listDriverRentModelFromJson(String str) => ListDriverRentModel.fromJson(json.decode(str));

String listDriverRentModelToJson(ListDriverRentModel data) => json.encode(data.toJson());

class ListDriverRentModel {
  bool? status;
  List<Count>? count;
  List<DriverRent>? driverRents;

  ListDriverRentModel({
    this.status,
    this.count,
    this.driverRents,
  });

  factory ListDriverRentModel.fromJson(Map<String, dynamic> json) => ListDriverRentModel(
    status: json["status"],
    count: json["count"] == null ? [] : List<Count>.from(json["count"]!.map((x) => Count.fromJson(x))),
    driverRents: json["driver_rents"] == null ? [] : List<DriverRent>.from(json["driver_rents"]!.map((x) => DriverRent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count == null ? [] : List<dynamic>.from(count!.map((x) => x.toJson())),
    "driver_rents": driverRents == null ? [] : List<dynamic>.from(driverRents!.map((x) => x.toJson())),
  };
}

class Count {
  int? driverId;
  int? id;
  String? count;
  String? lastModified;

  Count({
    this.driverId,
    this.id,
    this.count,
    this.lastModified,
  });

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    driverId: json["driver_id"],
    id: json["id"],
    count: json["count"],
    lastModified: json["last_modified"],
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "id": id,
    "count": count,
    "last_modified": lastModified,
  };
}

class DriverRent {
  int? driverId;
  DriverInfo? driver;

  DriverRent({
    this.driverId,
    this.driver,
  });

  factory DriverRent.fromJson(Map<String, dynamic> json) => DriverRent(
    driverId: json["driver_id"],
    driver: json["driver"] == null ? null : DriverInfo.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "driver": driver?.toJson(),
  };
}

class DriverInfo {
  String? name;
  String? username;
  String? driverType;
  int? driverRent;
  int? pdaRent;
  int? balance;
  bool? active;
  int? subsidiaryId;

  DriverInfo({
    this.name,
    this.username,
    this.driverType,
    this.driverRent,
    this.pdaRent,
    this.balance,
    this.active,
    this.subsidiaryId,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
    name: json["name"],
    username: json["username"],
    driverType: json["driver_type"],
    driverRent: json["driver_rent"],
    pdaRent: json["pda_rent"],
    balance: json["balance"],
    active: json["active"],
    subsidiaryId: json["subsidiary_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "driver_type": driverType,
    "driver_rent": driverRent,
    "pda_rent": pdaRent,
    "balance": balance,
    "active": active,
    "subsidiary_id": subsidiaryId,
  };
}
