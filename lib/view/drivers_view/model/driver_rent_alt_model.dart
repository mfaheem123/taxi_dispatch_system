// To parse this JSON data, do
//
//     final driverRentAltModel = driverRentAltModelFromJson(jsonString);

import 'dart:convert';

DriverRentAltModel driverRentAltModelFromJson(String str) => DriverRentAltModel.fromJson(json.decode(str));

String driverRentAltModelToJson(DriverRentAltModel data) => json.encode(data.toJson());

class DriverRentAltModel {
  bool? status;
  int? count;
  List<DriverRent>? driverRents;

  DriverRentAltModel({
    this.status,
    this.count,
    this.driverRents,
  });

  factory DriverRentAltModel.fromJson(Map<String, dynamic> json) => DriverRentAltModel(
    status: json["status"],
    count: json["count"],
    driverRents: json["driver_rents"] == null ? [] : List<DriverRent>.from(json["driver_rents"]!.map((x) => DriverRent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "driver_rents": driverRents == null ? [] : List<dynamic>.from(driverRents!.map((x) => x.toJson())),
  };
}

class DriverRent {
  int? id;
  String? transactionNumber;
  DateTime? transactionDate;
  int? driverId;
  String? jobsTotal;
  String? rentTotal;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? owed;
  String? oldBalance;
  String? currentBalance;
  DateTime? fromDate;
  DateTime? toDate;
  dynamic paymentType;
  String? lastModified;
  RentAltDriver? driver;

  DriverRent({
    this.id,
    this.transactionNumber,
    this.transactionDate,
    this.driverId,
    this.jobsTotal,
    this.rentTotal,
    this.cashJobsTotal,
    this.accountJobsTotal,
    this.owed,
    this.oldBalance,
    this.currentBalance,
    this.fromDate,
    this.toDate,
    this.paymentType,
    this.lastModified,
    this.driver,
  });

  factory DriverRent.fromJson(Map<String, dynamic> json) => DriverRent(
    id: json["id"],
    transactionNumber: json["transaction_number"],
    transactionDate: _parseDate(json["transaction_date"]),
    driverId: json["driver_id"],
    jobsTotal: json["jobs_total"],
    rentTotal: json["rent_total"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    owed: json["owed"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    paymentType: json["payment_type"],
    lastModified: json["last_modified"],
    driver: json["driver"] == null ? null : RentAltDriver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_number": transactionNumber,
    "transaction_date": transactionDate?.toIso8601String(),
    "driver_id": driverId,
    "jobs_total": jobsTotal,
    "rent_total": rentTotal,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "owed": owed,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "payment_type": paymentType,
    "last_modified": lastModified,
    "driver": driver?.toJson(),
  };

  // Helper function to handle flexible date formats
  static DateTime? _parseDate(dynamic date) {
    if (date == null || date == "") return null;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      // If 2026-2-20 fails, we try to split and pad it manually
      try {
        List<String> parts = date.toString().split('-');
        if (parts.length == 3) {
          int year = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int day = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } catch (_) {}
      return null;
    }
  }
}

class RentAltDriver {
  String? username;
  String? email;
  int? subsidiaryId;

  RentAltDriver({
    this.username,
    this.email,
    this.subsidiaryId,
  });

  factory RentAltDriver.fromJson(Map<String, dynamic> json) => RentAltDriver(
    username: json["username"],
    email: json["email"],
    subsidiaryId: json["subsidiary_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "subsidiary_id": subsidiaryId,
  };
}
