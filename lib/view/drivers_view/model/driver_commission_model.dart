// To parse this JSON data, do
//
//     final driverCommissionModel = driverCommissionModelFromJson(jsonString);

import 'dart:convert';

DriverCommissionModel driverCommissionModelFromJson(String str) => DriverCommissionModel.fromJson(json.decode(str));

String driverCommissionModelToJson(DriverCommissionModel data) => json.encode(data.toJson());

class DriverCommissionModel {
  bool? status;
  List<Count>? count;
  List<DriverCommission>? driverCommissions;

  DriverCommissionModel({
    this.status,
    this.count,
    this.driverCommissions,
  });

  factory DriverCommissionModel.fromJson(Map<String, dynamic> json) => DriverCommissionModel(
    status: json["status"],
    count: json["count"] == null ? [] : List<Count>.from(json["count"]!.map((x) => Count.fromJson(x))),
    driverCommissions: json["driver_commissions"] == null ? [] : List<DriverCommission>.from(json["driver_commissions"]!.map((x) => DriverCommission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count == null ? [] : List<dynamic>.from(count!.map((x) => x.toJson())),
    "driver_commissions": driverCommissions == null ? [] : List<dynamic>.from(driverCommissions!.map((x) => x.toJson())),
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

class DriverCommission {
  int? driverId;
  DriverCommissionList? driver;

  DriverCommission({
    this.driverId,
    this.driver,
  });

  factory DriverCommission.fromJson(Map<String, dynamic> json) => DriverCommission(
    driverId: json["driver_id"],
    driver: json["driver"] == null ? null : DriverCommissionList.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "driver": driver?.toJson(),
  };
}

class DriverCommissionList {
  String? name;
  String? username;
  String? driverType;
  int? driverCommission;
  dynamic pdaRent;
  double? balance;
  bool? active;
  int? subsidiaryId;

  DriverCommissionList({
    this.name,
    this.username,
    this.driverType,
    this.driverCommission,
    this.pdaRent,
    this.balance,
    this.active,
    this.subsidiaryId,
  });

  factory DriverCommissionList.fromJson(Map<String, dynamic> json) => DriverCommissionList(
    name: json["name"],
    username: json["username"],
    driverType: json["driver_type"],
    driverCommission: json["driver_commission"],
    pdaRent: json["pda_rent"],
    balance: json["balance"]?.toDouble(),
    active: json["active"],
    subsidiaryId: json["subsidiary_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "username": username,
    "driver_type": driverType,
    "driver_commission": driverCommission,
    "pda_rent": pdaRent,
    "balance": balance,
    "active": active,
    "subsidiary_id": subsidiaryId,
  };
}
