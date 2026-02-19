// To parse this JSON data, do
//
//     final listOfAccountInvoiceModel = listOfAccountInvoiceModelFromJson(jsonString);

import 'dart:convert';

ListOfAccountInvoiceModel listOfAccountInvoiceModelFromJson(String str) => ListOfAccountInvoiceModel.fromJson(json.decode(str));

String listOfAccountInvoiceModelToJson(ListOfAccountInvoiceModel data) => json.encode(data.toJson());

class ListOfAccountInvoiceModel {
  bool? status;
  int? count;
  int? page;
  int? totalPages;
  int? limit;
  List<AccountInvoice>? accountInvoices;

  ListOfAccountInvoiceModel({
    this.status,
    this.count,
    this.page,
    this.totalPages,
    this.limit,
    this.accountInvoices,
  });

  factory ListOfAccountInvoiceModel.fromJson(Map<String, dynamic> json) => ListOfAccountInvoiceModel(
    status: json["status"],
    count: json["count"],
    page: json["page"],
    totalPages: json["total_pages"],
    limit: json["limit"],
    accountInvoices: json["account_invoices"] == null ? [] : List<AccountInvoice>.from(json["account_invoices"]!.map((x) => AccountInvoice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "page": page,
    "total_pages": totalPages,
    "limit": limit,
    "account_invoices": accountInvoices == null ? [] : List<dynamic>.from(accountInvoices!.map((x) => x.toJson())),
  };
}

class AccountInvoice {
  int? id;
  int? subsidiaryId;
  int? accountId;
  String? invoiceNumber;
  DateTime? invoiceDate;
  DateTime? invoiceDueDate;
  DateTime? fromDate;
  DateTime? toDate;
  String? invoiceType;
  int? departmentId;
  String? orderNumber;
  String? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic stripeCustomerId;
  dynamic stripePaymentId;
  Account? account;
  Department? department;

  AccountInvoice({
    this.id,
    this.subsidiaryId,
    this.accountId,
    this.invoiceNumber,
    this.invoiceDate,
    this.invoiceDueDate,
    this.fromDate,
    this.toDate,
    this.invoiceType,
    this.departmentId,
    this.orderNumber,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.stripeCustomerId,
    this.stripePaymentId,
    this.account,
    this.department,
  });

  factory AccountInvoice.fromJson(Map<String, dynamic> json) => AccountInvoice(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    accountId: json["account_id"],
    invoiceNumber: json["invoice_number"],
    invoiceDate: json["invoice_date"] == null ? null : DateTime.parse(json["invoice_date"]),
    invoiceDueDate: json["invoice_due_date"] == null ? null : DateTime.parse(json["invoice_due_date"]),
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    invoiceType: json["invoice_type"],
    departmentId: json["department_id"],
    orderNumber: json["order_number"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    stripeCustomerId: json["stripe_customer_id"],
    stripePaymentId: json["stripe_payment_id"],
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    department: json["department"] == null ? null : Department.fromJson(json["department"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "account_id": accountId,
    "invoice_number": invoiceNumber,
    "invoice_date": "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
    "invoice_due_date": "${invoiceDueDate!.year.toString().padLeft(4, '0')}-${invoiceDueDate!.month.toString().padLeft(2, '0')}-${invoiceDueDate!.day.toString().padLeft(2, '0')}",
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "invoice_type": invoiceType,
    "department_id": departmentId,
    "order_number": orderNumber,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "stripe_customer_id": stripeCustomerId,
    "stripe_payment_id": stripePaymentId,
    "account": account?.toJson(),
    "department": department?.toJson(),
  };
}

class Account {
  String? name;
  String? email;
  int? subsidiaryId;
  Department? subsidiary;

  Account({
    this.name,
    this.email,
    this.subsidiaryId,
    this.subsidiary,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    name: json["name"],
    email: json["email"],
    subsidiaryId: json["subsidiary_id"],
    subsidiary: json["subsidiary"] == null ? null : Department.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "subsidiary_id": subsidiaryId,
    "subsidiary": subsidiary?.toJson(),
  };
}

class Department {
  int? id;
  String? name;

  Department({
    this.id,
    this.name,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
