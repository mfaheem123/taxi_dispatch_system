// To parse this JSON data, do
//
//     final driverCommissionAlertModel = driverCommissionAlertModelFromJson(jsonString);

import 'dart:convert';

DriverCommissionAlertModel driverCommissionAlertModelFromJson(String str) => DriverCommissionAlertModel.fromJson(json.decode(str));

String driverCommissionAlertModelToJson(DriverCommissionAlertModel data) => json.encode(data.toJson());

class DriverCommissionAlertModel {
  bool? status;
  int? count;
  List<DriverCommissionAlert>? driverCommissions;

  DriverCommissionAlertModel({
    this.status,
    this.count,
    this.driverCommissions,
  });

  factory DriverCommissionAlertModel.fromJson(Map<String, dynamic> json) => DriverCommissionAlertModel(
    status: json["status"],
    count: json["count"],
    driverCommissions: json["driver_commissions"] == null ? [] : List<DriverCommissionAlert>.from(json["driver_commissions"]!.map((x) => DriverCommissionAlert.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "driver_commissions": driverCommissions == null ? [] : List<dynamic>.from(driverCommissions!.map((x) => x.toJson())),
  };
}

class DriverCommissionAlert {
  int? id;
  String? transactionNumber;
  DateTime? transactionDate;
  int? driverId;
  String? jobsTotal;
  String? commissionTotal;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? owed;
  String? oldBalance;
  String? currentBalance;
  DateTime? fromDate;
  DateTime? toDate;
  dynamic paymentType;
  DateTime? lastModified;
  DriverAlert? driver;

  DriverCommissionAlert({
    this.id,
    this.transactionNumber,
    this.transactionDate,
    this.driverId,
    this.jobsTotal,
    this.commissionTotal,
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

  factory DriverCommissionAlert.fromJson(Map<String, dynamic> json) => DriverCommissionAlert(
    id: json["id"],
    transactionNumber: json["transaction_number"],
    transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
    driverId: json["driver_id"],
    jobsTotal: json["jobs_total"],
    commissionTotal: json["commission_total"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    owed: json["owed"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    paymentType: json["payment_type"],
    lastModified: json["last_modified"] == null ? null : DateTime.parse(json["last_modified"]),
    driver: json["driver"] == null ? null : DriverAlert.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_number": transactionNumber,
    "transaction_date": "${transactionDate!.year.toString().padLeft(4, '0')}-${transactionDate!.month.toString().padLeft(2, '0')}-${transactionDate!.day.toString().padLeft(2, '0')}",
    "driver_id": driverId,
    "jobs_total": jobsTotal,
    "commission_total": commissionTotal,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "owed": owed,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "payment_type": paymentType,
    "last_modified": "${lastModified!.year.toString().padLeft(4, '0')}-${lastModified!.month.toString().padLeft(2, '0')}-${lastModified!.day.toString().padLeft(2, '0')}",
    "driver": driver?.toJson(),
  };
}

class DriverAlert {
  String? username;
  String? email;
  int? subsidiaryId;

  DriverAlert({
    this.username,
    this.email,
    this.subsidiaryId,
  });

  factory DriverAlert.fromJson(Map<String, dynamic> json) => DriverAlert(
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
