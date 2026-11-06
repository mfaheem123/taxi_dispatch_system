// To parse this JSON data, do
//
//     final getAllDriverPayModel = getAllDriverPayModelFromJson(jsonString);

import 'dart:convert';

GetAllDriverPayModel getAllDriverPayModelFromJson(String str) => GetAllDriverPayModel.fromJson(json.decode(str));

String getAllDriverPayModelToJson(GetAllDriverPayModel data) => json.encode(data.toJson());

class GetAllDriverPayModel {
  bool? status;
  int? count;
  List<DriverCommissionLedger>? driverCommissionLedgers;

  GetAllDriverPayModel({
    this.status,
    this.count,
    this.driverCommissionLedgers,
  });

  factory GetAllDriverPayModel.fromJson(Map<String, dynamic> json) => GetAllDriverPayModel(
    status: json["status"],
    count: json["count"],
    driverCommissionLedgers: json["driver_commission_ledgers"] == null ? [] : List<DriverCommissionLedger>.from(json["driver_commission_ledgers"]!.map((x) => DriverCommissionLedger.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "driver_commission_ledgers": driverCommissionLedgers == null ? [] : List<dynamic>.from(driverCommissionLedgers!.map((x) => x.toJson())),
  };
}

class DriverCommissionLedger {
  int? id;
  int? driverId;
  String? date;
  String? amount;
  String? currentBalance;
  String? type;
  String? invoiceType;
  String? description;
  int? companyId;
  String? createdAt;
  String? updatedAt;

  DriverCommissionLedger({
    this.id,
    this.driverId,
    this.date,
    this.amount,
    this.currentBalance,
    this.type,
    this.invoiceType,
    this.description,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverCommissionLedger.fromJson(Map<String, dynamic> json) => DriverCommissionLedger(
    id: json["id"],
    driverId: json["driver_id"],
    date: json["date"],
    amount: json["amount"],
    currentBalance: json["current_balance"],
    type: json["type"],
    invoiceType: json["invoice_type"],
    description: json["description"],
    companyId: json["company_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "date": date,
    "amount": amount,
    "current_balance": currentBalance,
    "type": type,
    "invoice_type": invoiceType,
    "description": description,
    "company_id": companyId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
