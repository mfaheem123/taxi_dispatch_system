// To parse this JSON data, do
//
//     final driverCommissionCheckboxModel = driverCommissionCheckboxModelFromJson(jsonString);

import 'dart:convert';

DriverCommissionCheckboxModel driverCommissionCheckboxModelFromJson(String str) => DriverCommissionCheckboxModel.fromJson(json.decode(str));

String driverCommissionCheckboxModelToJson(DriverCommissionCheckboxModel data) => json.encode(data.toJson());

class DriverCommissionCheckboxModel {
  bool? status;
  List<PaymentType>? paymentTypes;

  DriverCommissionCheckboxModel({
    this.status,
    this.paymentTypes,
  });

  factory DriverCommissionCheckboxModel.fromJson(Map<String, dynamic> json) => DriverCommissionCheckboxModel(
    status: json["status"],
    paymentTypes: json["payment_types"] == null ? [] : List<PaymentType>.from(json["payment_types"]!.map((x) => PaymentType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "payment_types": paymentTypes == null ? [] : List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
  };
}

class PaymentType {
  int? id;
  String? name;
  dynamic service;
  String? backgroundColor;
  String? foregroundColor;

  PaymentType({
    this.id,
    this.name,
    this.service,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
    id: json["id"],
    name: json["name"],
    service: json["service"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "service": service,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}
