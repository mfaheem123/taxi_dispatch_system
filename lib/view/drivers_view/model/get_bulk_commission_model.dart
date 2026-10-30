// To parse this JSON data, do
//
//     final getBulkCommissionModel = getBulkCommissionModelFromJson(jsonString);

import 'dart:convert';

GetBulkCommissionModel getBulkCommissionModelFromJson(String str) => GetBulkCommissionModel.fromJson(json.decode(str));

String getBulkCommissionModelToJson(GetBulkCommissionModel data) => json.encode(data.toJson());

class GetBulkCommissionModel {
  bool? status;
  int? count;
  List<Datum>? data;

  GetBulkCommissionModel({
    this.status,
    this.count,
    this.data,
  });

  factory GetBulkCommissionModel.fromJson(Map<String, dynamic> json) => GetBulkCommissionModel(
    status: json["status"],
    count: json["count"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? driverId;
  BulkDriverCommission? driver;
  String? bookingsCount;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? jobsTotal;
  String? commissionTotal;
  String? oldBalance;
  String? currentBalance;
  String? owed;
  List<DriverCommissionLineitem>? driverCommissionLineitems;

  Datum({
    this.driverId,
    this.driver,
    this.bookingsCount,
    this.cashJobsTotal,
    this.accountJobsTotal,
    this.jobsTotal,
    this.commissionTotal,
    this.oldBalance,
    this.currentBalance,
    this.owed,
    this.driverCommissionLineitems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    driverId: json["driver_id"],
    driver: json["driver"] == null ? null : BulkDriverCommission.fromJson(json["driver"]),
    bookingsCount: json["bookings_count"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    jobsTotal: json["jobs_total"],
    commissionTotal: json["commission_total"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    owed: json["owed"],
    driverCommissionLineitems: json["driver_commission_lineitems"] == null ? [] : List<DriverCommissionLineitem>.from(json["driver_commission_lineitems"]!.map((x) => DriverCommissionLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "driver": driver?.toJson(),
    "bookings_count": bookingsCount,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "jobs_total": jobsTotal,
    "commission_total": commissionTotal,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "owed": owed,
    "driver_commission_lineitems": driverCommissionLineitems == null ? [] : List<dynamic>.from(driverCommissionLineitems!.map((x) => x.toJson())),
  };
}

class BulkDriverCommission {
  int? id;
  String? username;
  String? name;
  int? driverCommission;

  BulkDriverCommission({
    this.id,
    this.username,
    this.name,
    this.driverCommission,
  });

  factory BulkDriverCommission.fromJson(Map<String, dynamic> json) => BulkDriverCommission(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    driverCommission: json["driver_commission"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "driver_commission": driverCommission,
  };
}

class DriverCommissionLineitem {
  int? bookingId;
  double? fares;
  int? parkingCharges;
  int? waitingCharges;
  int? extraDropCharges;
  int? congestionCharges;
  double? totalCharges;
  String? paymentType;

  DriverCommissionLineitem({
    this.bookingId,
    this.fares,
    this.parkingCharges,
    this.waitingCharges,
    this.extraDropCharges,
    this.congestionCharges,
    this.totalCharges,
    this.paymentType,
  });

  factory DriverCommissionLineitem.fromJson(Map<String, dynamic> json) => DriverCommissionLineitem(
    bookingId: json["booking_id"],
    fares: json["fares"]?.toDouble(),
    parkingCharges: json["parking_charges"],
    waitingCharges: json["waiting_charges"],
    extraDropCharges: json["extra_drop_charges"],
    congestionCharges: json["congestion_charges"],
    totalCharges: json["total_charges"]?.toDouble(),
    paymentType: json["payment_type"],
  );

  Map<String, dynamic> toJson() => {
    "booking_id": bookingId,
    "fares": fares,
    "parking_charges": parkingCharges,
    "waiting_charges": waitingCharges,
    "extra_drop_charges": extraDropCharges,
    "congestion_charges": congestionCharges,
    "total_charges": totalCharges,
    "payment_type": paymentType,
  };
}
