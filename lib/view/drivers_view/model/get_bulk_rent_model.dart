// To parse this JSON data, do
//
//     final getBulkRentModel = getBulkRentModelFromJson(jsonString);

import 'dart:convert';

GetBulkRentModel getBulkRentModelFromJson(String str) => GetBulkRentModel.fromJson(json.decode(str));

String getBulkRentModelToJson(GetBulkRentModel data) => json.encode(data.toJson());

class GetBulkRentModel {
  bool? status;
  int? count;
  List<Datum>? data;

  GetBulkRentModel({
    this.status,
    this.count,
    this.data,
  });

  factory GetBulkRentModel.fromJson(Map<String, dynamic> json) => GetBulkRentModel(
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
  BulkDriverRent? driver;
  String? bookingsCount;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? jobsTotal;
  String? rentTotal;
  String? oldBalance;
  String? currentBalance;
  String? owed;
  List<BulkDriverRentLineitem>? driverRentLineitems;

  Datum({
    this.driverId,
    this.driver,
    this.bookingsCount,
    this.cashJobsTotal,
    this.accountJobsTotal,
    this.jobsTotal,
    this.rentTotal,
    this.oldBalance,
    this.currentBalance,
    this.owed,
    this.driverRentLineitems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    driverId: json["driver_id"],
    driver: json["driver"] == null ? null : BulkDriverRent.fromJson(json["driver"]),
    bookingsCount: json["bookings_count"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    jobsTotal: json["jobs_total"],
    rentTotal: json["rent_total"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    owed: json["owed"],
    driverRentLineitems: json["driver_rent_lineitems"] == null ? [] : List<BulkDriverRentLineitem>.from(json["driver_rent_lineitems"]!.map((x) => BulkDriverRentLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "driver_id": driverId,
    "driver": driver?.toJson(),
    "bookings_count": bookingsCount,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "jobs_total": jobsTotal,
    "rent_total": rentTotal,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "owed": owed,
    "driver_rent_lineitems": driverRentLineitems == null ? [] : List<dynamic>.from(driverRentLineitems!.map((x) => x.toJson())),
  };
}

class BulkDriverRent {
  int? id;
  String? username;
  String? name;
  int? driverRent;

  BulkDriverRent({
    this.id,
    this.username,
    this.name,
    this.driverRent,
  });

  factory BulkDriverRent.fromJson(Map<String, dynamic> json) => BulkDriverRent(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    driverRent: json["driver_rent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "driver_rent": driverRent,
  };
}

class BulkDriverRentLineitem {
  int? bookingId;
  double? fares;
  int? parkingCharges;
  int? waitingCharges;
  int? extraDropCharges;
  int? congestionCharges;
  double? totalCharges;
  String? paymentType;

  BulkDriverRentLineitem({
    this.bookingId,
    this.fares,
    this.parkingCharges,
    this.waitingCharges,
    this.extraDropCharges,
    this.congestionCharges,
    this.totalCharges,
    this.paymentType,
  });

  factory BulkDriverRentLineitem.fromJson(Map<String, dynamic> json) => BulkDriverRentLineitem(
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
