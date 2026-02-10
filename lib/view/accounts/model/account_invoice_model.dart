// To parse this JSON data, do
//
//     final accountInvoiceModel = accountInvoiceModelFromJson(jsonString);

import 'dart:convert';

AccountInvoiceModel accountInvoiceModelFromJson(String str) => AccountInvoiceModel.fromJson(json.decode(str));

String accountInvoiceModelToJson(AccountInvoiceModel data) => json.encode(data.toJson());

class AccountInvoiceModel {
  bool? status;
  int? count;
  List<Account>? accounts;

  AccountInvoiceModel({
    this.status,
    this.count,
    this.accounts,
  });

  factory AccountInvoiceModel.fromJson(Map<String, dynamic> json) => AccountInvoiceModel(
    status: json["status"],
    count: json["count"],
    accounts: json["accounts"] == null ? [] : List<Account>.from(json["accounts"]!.map((x) => Account.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "accounts": accounts == null ? [] : List<dynamic>.from(accounts!.map((x) => x.toJson())),
  };
}

class Account {
  int? id;
  int? subsidiaryId;
  String? accountType;
  String? name;
  String? email;
  String? mobile;
  String? paymentTypes;
  String? information;
  String? backgroundColor;
  String? foregroundColor;
  List<Department>? departments;
  Subsidiary? subsidiary;

  Account({
    this.id,
    this.subsidiaryId,
    this.accountType,
    this.name,
    this.email,
    this.mobile,
    this.paymentTypes,
    this.information,
    this.backgroundColor,
    this.foregroundColor,
    this.departments,
    this.subsidiary,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    accountType: json["account_type"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    paymentTypes: json["payment_types"],
    information: json["information"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    departments: json["departments"] == null ? [] : List<Department>.from(json["departments"]!.map((x) => Department.fromJson(x))),
    subsidiary: json["subsidiary"] == null ? null : Subsidiary.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "account_type": accountType,
    "name": name,
    "email": email,
    "mobile": mobile,
    "payment_types": paymentTypes,
    "information": information,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "departments": departments == null ? [] : List<dynamic>.from(departments!.map((x) => x.toJson())),
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

class Subsidiary {
  int? id;
  String? name;
  String? email;
  String? telephoneNumber;

  Subsidiary({
    this.id,
    this.name,
    this.email,
    this.telephoneNumber,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    telephoneNumber: json["telephone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "telephone_number": telephoneNumber,
  };
}
