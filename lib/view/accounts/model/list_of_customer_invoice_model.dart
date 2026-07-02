// To parse this JSON data, do
//
//     final listOfCustomerInvoiceModel = listOfCustomerInvoiceModelFromJson(jsonString);

import 'dart:convert';

ListOfCustomerInvoiceModel listOfCustomerInvoiceModelFromJson(String str) => ListOfCustomerInvoiceModel.fromJson(json.decode(str));

String listOfCustomerInvoiceModelToJson(ListOfCustomerInvoiceModel data) => json.encode(data.toJson());

class ListOfCustomerInvoiceModel {
  bool? status;
  int? count;
  List<CustomerInvoice>? customerInvoices;

  ListOfCustomerInvoiceModel({
    this.status,
    this.count,
    this.customerInvoices,
  });

  factory ListOfCustomerInvoiceModel.fromJson(Map<String, dynamic> json) => ListOfCustomerInvoiceModel(
    status: json["status"],
    count: json["count"],
    customerInvoices: json["customer_invoices"] == null ? [] : List<CustomerInvoice>.from(json["customer_invoices"]!.map((x) => CustomerInvoice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "customer_invoices": customerInvoices == null ? [] : List<dynamic>.from(customerInvoices!.map((x) => x.toJson())),
  };
}

class CustomerInvoice {
  int? id;
  String? invoiceNumber;
  int? customerId;
  String? invoiceDate;
  String? invoiceDueDate;
  DateTime? fromDate;
  DateTime? toDate;
  String? invoiceType;
  String? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  Customer? customer;

  CustomerInvoice({
    this.id,
    this.invoiceNumber,
    this.customerId,
    this.invoiceDate,
    this.invoiceDueDate,
    this.fromDate,
    this.toDate,
    this.invoiceType,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  factory CustomerInvoice.fromJson(Map<String, dynamic> json) => CustomerInvoice(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    customerId: json["customer_id"],
    invoiceDate: json["invoice_date"],
    invoiceDueDate: json["invoice_due_date"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    invoiceType: json["invoice_type"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "customer_id": customerId,
    "invoice_date": invoiceDate,
    "invoice_due_date": invoiceDueDate,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "invoice_type": invoiceType,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "customer": customer?.toJson(),
  };
}

class Customer {
  String? name;
  String? email;

  Customer({
    this.name,
    this.email,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
  };
}
