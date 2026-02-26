// To parse this JSON data, do
//
//     final driverCommissionPaymentModel = driverCommissionPaymentModelFromJson(jsonString);

import 'dart:convert';

DriverCommissionPaymentModel driverCommissionPaymentModelFromJson(String str) => DriverCommissionPaymentModel.fromJson(json.decode(str));

String driverCommissionPaymentModelToJson(DriverCommissionPaymentModel data) => json.encode(data.toJson());

class DriverCommissionPaymentModel {
  bool? status;
  List<PaymentType>? paymentTypes;

  DriverCommissionPaymentModel({
    this.status,
    this.paymentTypes,
  });

  factory DriverCommissionPaymentModel.fromJson(Map<String, dynamic> json) => DriverCommissionPaymentModel(
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
