// To parse this JSON data, do
//
//     final customerInvoiceModel = customerInvoiceModelFromJson(jsonString);

import 'dart:convert';

CustomerInvoiceModel customerInvoiceModelFromJson(String str) => CustomerInvoiceModel.fromJson(json.decode(str));

String customerInvoiceModelToJson(CustomerInvoiceModel data) => json.encode(data.toJson());

class CustomerInvoiceModel {
  bool? status;
  String? invoiceNumber;

  CustomerInvoiceModel({
    this.status,
    this.invoiceNumber,
  });

  factory CustomerInvoiceModel.fromJson(Map<String, dynamic> json) => CustomerInvoiceModel(
    status: json["status"],
    invoiceNumber: json["invoice_number"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "invoice_number": invoiceNumber,
  };
}
