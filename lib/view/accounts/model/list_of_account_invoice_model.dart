// To parse this JSON data, do
//
//     final listOfAccountInvoiceModel = listOfAccountInvoiceModelFromJson(jsonString);

import 'dart:convert';

ListOfAccountInvoiceModel listOfAccountInvoiceModelFromJson(String str) => ListOfAccountInvoiceModel.fromJson(json.decode(str));

String listOfAccountInvoiceModelToJson(ListOfAccountInvoiceModel data) => json.encode(data.toJson());

class ListOfAccountInvoiceModel {
  bool? status;
  int? count;
  List<AccountInvoice>? accountInvoices;

  ListOfAccountInvoiceModel({
    this.status,
    this.count,
    this.accountInvoices,
  });

  factory ListOfAccountInvoiceModel.fromJson(Map<String, dynamic> json) => ListOfAccountInvoiceModel(
    status: json["status"],
    count: json["count"],
    accountInvoices: json["account_invoices"] == null ? [] : List<AccountInvoice>.from(json["account_invoices"]!.map((x) => AccountInvoice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
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
  dynamic departmentId;
  String? orderNumber;
  String? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic stripeCustomerId;
  dynamic stripePaymentId;
  AccountInvoiceList? account;
  dynamic departments;

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
    this.departments,
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
    account: json["account"] == null ? null : AccountInvoiceList.fromJson(json["account"]),
    departments: json["departments"],
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
    "departments": departments,
  };
}

class AccountInvoiceList {
  String? name;
  String? email;
  bool? hasVat;
  int? adminFees;
  String? adminFeesType;
  bool? adminFeesVat;
  bool? bankInformation;
  int? subsidiaryId;
  SubsidiaryInvoiceList? subsidiary;

  AccountInvoiceList({
    this.name,
    this.email,
    this.hasVat,
    this.adminFees,
    this.adminFeesType,
    this.adminFeesVat,
    this.bankInformation,
    this.subsidiaryId,
    this.subsidiary,
  });

  factory AccountInvoiceList.fromJson(Map<String, dynamic> json) => AccountInvoiceList(
    name: json["name"],
    email: json["email"],
    hasVat: json["has_vat"],
    adminFees: json["admin_fees"],
    adminFeesType: json["admin_fees_type"],
    adminFeesVat: json["admin_fees_vat"],
    bankInformation: json["bank_information"],
    subsidiaryId: json["subsidiary_id"],
    subsidiary: json["subsidiary"] == null ? null : SubsidiaryInvoiceList.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "has_vat": hasVat,
    "admin_fees": adminFees,
    "admin_fees_type": adminFeesType,
    "admin_fees_vat": adminFeesVat,
    "bank_information": bankInformation,
    "subsidiary_id": subsidiaryId,
    "subsidiary": subsidiary?.toJson(),
  };
}

class SubsidiaryInvoiceList {
  int? id;
  String? logo;
  String? backgroundColor;
  String? foregroundColor;
  String? name;
  String? telephoneNumber;
  String? emergencyContactNumber;
  String? email;
  String? fax;
  String? website;
  String? address;
  String? sortCode;
  String? accountNumber;
  String? accountTitle;
  String? bank;
  String? companyNumber;
  String? vatNumber;
  String? iban;
  int? balance;
  String? currency;
  String? webAccessToken;
  String? mobileAccessToken;
  int? maximumDrivers;
  int? activeDrivers;
  double? addressLatitude;
  double? addressLongitude;

  SubsidiaryInvoiceList({
    this.id,
    this.logo,
    this.backgroundColor,
    this.foregroundColor,
    this.name,
    this.telephoneNumber,
    this.emergencyContactNumber,
    this.email,
    this.fax,
    this.website,
    this.address,
    this.sortCode,
    this.accountNumber,
    this.accountTitle,
    this.bank,
    this.companyNumber,
    this.vatNumber,
    this.iban,
    this.balance,
    this.currency,
    this.webAccessToken,
    this.mobileAccessToken,
    this.maximumDrivers,
    this.activeDrivers,
    this.addressLatitude,
    this.addressLongitude,
  });

  factory SubsidiaryInvoiceList.fromJson(Map<String, dynamic> json) => SubsidiaryInvoiceList(
    id: json["id"],
    logo: json["logo"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    name: json["name"],
    telephoneNumber: json["telephone_number"],
    emergencyContactNumber: json["emergency_contact_number"],
    email: json["email"],
    fax: json["fax"],
    website: json["website"],
    address: json["address"],
    sortCode: json["sort_code"],
    accountNumber: json["account_number"],
    accountTitle: json["account_title"],
    bank: json["bank"],
    companyNumber: json["company_number"],
    vatNumber: json["vat_number"],
    iban: json["iban"],
    balance: json["balance"],
    currency: json["currency"],
    webAccessToken: json["web_access_token"],
    mobileAccessToken: json["mobile_access_token"],
    maximumDrivers: json["maximum_drivers"],
    activeDrivers: json["active_drivers"],
    addressLatitude: json["address_latitude"]?.toDouble(),
    addressLongitude: json["address_longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "name": name,
    "telephone_number": telephoneNumber,
    "emergency_contact_number": emergencyContactNumber,
    "email": email,
    "fax": fax,
    "website": website,
    "address": address,
    "sort_code": sortCode,
    "account_number": accountNumber,
    "account_title": accountTitle,
    "bank": bank,
    "company_number": companyNumber,
    "vat_number": vatNumber,
    "iban": iban,
    "balance": balance,
    "currency": currency,
    "web_access_token": webAccessToken,
    "mobile_access_token": mobileAccessToken,
    "maximum_drivers": maximumDrivers,
    "active_drivers": activeDrivers,
    "address_latitude": addressLatitude,
    "address_longitude": addressLongitude,
  };
}
