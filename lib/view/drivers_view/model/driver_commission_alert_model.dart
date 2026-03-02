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
    this.driver, required old_balance,
  });

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

  factory DriverCommissionAlert.fromJson(Map<String, dynamic> json) => DriverCommissionAlert(
    id: json["id"],
    transactionNumber: json["transaction_number"],
    transactionDate: _parseDate(json["transaction_date"]),
    driverId: json["driver_id"],
    jobsTotal: json["jobs_total"],
    commissionTotal: json["commission_total"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    owed: json["owed"],
    old_balance: json["old_balance"],
    currentBalance: json["current_balance"],
    fromDate: _parseDate(json["from_date"]),
    toDate: _parseDate(json["to_date"]),
    paymentType: json["payment_type"],
    lastModified: _parseDate(json["last_modified"]),
    driver: json["driver"] == null ? null : DriverAlert.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_number": transactionNumber,
    "transaction_date": transactionDate?.toIso8601String(),
    "driver_id": driverId,
    "jobs_total": jobsTotal,
    "commission_total": commissionTotal,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "owed": owed,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "from_date": fromDate?.toIso8601String(),
    "to_date": toDate?.toIso8601String(),
    "payment_type": paymentType,
    "last_modified": lastModified?.toIso8601String(),
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