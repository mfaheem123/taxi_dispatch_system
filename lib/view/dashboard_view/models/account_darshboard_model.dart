

// To parse this JSON data, do
//
//     final dashboardAccountModel = dashboardAccountModelFromJson(jsonString);

import 'dart:convert';

DashboardAccountModel dashboardAccountModelFromJson(String str) => DashboardAccountModel.fromJson(json.decode(str));

String dashboardAccountModelToJson(DashboardAccountModel data) => json.encode(data.toJson());

class DashboardAccountModel {
  bool? status;
  int? count;
  List<DashboardAccountObject>? accounts;

  DashboardAccountModel({
    this.status,
    this.count,
    this.accounts,
  });

  factory DashboardAccountModel.fromJson(Map<String, dynamic> json) => DashboardAccountModel(
    status: json["status"],
    count: json["count"],
    accounts: List<DashboardAccountObject>.from(json["accounts"].map((x) => DashboardAccountObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "accounts": List<dynamic>.from(accounts!.map((x) => x.toJson())),
  };
}

class DashboardAccountObject {
  int? id;
  int? subsidiaryId;
  int? subsidiaryBankAccountId;
  String? accountType;
  bool? closed;
  String? name;
  String? code;
  String? email;
  String? password;
  String? mobile;
  String? telephone;
  String? fax;
  String? website;
  String? accountNumber;
  String? creditCard;
  String? address;
  String? paymentTypes;
  String? information;
  String? contactName;
  String? backgroundColor;
  String? foregroundColor;
  String? agentCommissionType;
  String? agentCommission;
  String? adminFeesType;
  String? adminFees;
  String? accountFeesType;
  String? accountFees;
  bool? hasBookedBy;
  bool? fareController;
  bool? hasEscort;
  bool? hasVat;
  bool? adminFeesVat;
  bool? accountFeesVat;
  bool? hasOrderNumber;
  bool? dispatchCustomerText;
  bool? confirmationText;
  bool? arrivalText;
  bool? clearJobText;
  bool? bankInformation;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Department>? departments;
  Subsidiary? subsidiary;

  DashboardAccountObject({
    this.id,
    this.subsidiaryId,
    this.subsidiaryBankAccountId,
    this.accountType,
    this.closed,
    this.name,
    this.code,
    this.email,
    this.password,
    this.mobile,
    this.telephone,
    this.fax,
    this.website,
    this.accountNumber,
    this.creditCard,
    this.address,
    this.paymentTypes,
    this.information,
    this.contactName,
    this.backgroundColor,
    this.foregroundColor,
    this.agentCommissionType,
    this.agentCommission,
    this.adminFeesType,
    this.adminFees,
    this.accountFeesType,
    this.accountFees,
    this.hasBookedBy,
    this.fareController,
    this.hasEscort,
    this.hasVat,
    this.adminFeesVat,
    this.accountFeesVat,
    this.hasOrderNumber,
    this.dispatchCustomerText,
    this.confirmationText,
    this.arrivalText,
    this.clearJobText,
    this.bankInformation,
    this.createdAt,
    this.updatedAt,
    this.departments,
    this.subsidiary,
  });

  factory DashboardAccountObject.fromJson(Map<String, dynamic> json) => DashboardAccountObject(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    subsidiaryBankAccountId: json["subsidiary_bank_account_id"],
    accountType: json["account_type"],
    closed: json["closed"],
    name: json["name"],
    code: json["code"],
    email: json["email"],
    password: json["password"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    fax: json["fax"],
    website: json["website"],
    accountNumber: json["account_number"],
    creditCard: json["credit_card"],
    address: json["address"],
    paymentTypes: json["payment_types"],
    information: json["information"],
    contactName: json["contact_name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    agentCommissionType: json["agent_commission_type"],
    agentCommission: json["agent_commission"],
    adminFeesType: json["admin_fees_type"],
    adminFees: json["admin_fees"],
    accountFeesType: json["account_fees_type"],
    accountFees: json["account_fees"],
    hasBookedBy: json["has_booked_by"],
    fareController: json["fare_controller"],
    hasEscort: json["has_escort"],
    hasVat: json["has_vat"],
    adminFeesVat: json["admin_fees_vat"],
    accountFeesVat: json["account_fees_vat"],
    hasOrderNumber: json["has_order_number"],
    dispatchCustomerText: json["dispatch_customer_text"],
    confirmationText: json["confirmation_text"],
    arrivalText: json["arrival_text"],
    clearJobText: json["clear_job_text"],
    bankInformation: json["bank_information"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    departments: List<Department>.from(json["departments"].map((x) => Department.fromJson(x))),
    subsidiary: Subsidiary.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "subsidiary_bank_account_id": subsidiaryBankAccountId,
    "account_type": accountType,
    "closed": closed,
    "name": name,
    "code": code,
    "email": email,
    "password": password,
    "mobile": mobile,
    "telephone": telephone,
    "fax": fax,
    "website": website,
    "account_number": accountNumber,
    "credit_card": creditCard,
    "address": address,
    "payment_types": paymentTypes,
    "information": information,
    "contact_name": contactName,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "agent_commission_type": agentCommissionType,
    "agent_commission": agentCommission,
    "admin_fees_type": adminFeesType,
    "admin_fees": adminFees,
    "account_fees_type": accountFeesType,
    "account_fees": accountFees,
    "has_booked_by": hasBookedBy,
    "fare_controller": fareController,
    "has_escort": hasEscort,
    "has_vat": hasVat,
    "admin_fees_vat": adminFeesVat,
    "account_fees_vat": accountFeesVat,
    "has_order_number": hasOrderNumber,
    "dispatch_customer_text": dispatchCustomerText,
    "confirmation_text": confirmationText,
    "arrival_text": arrivalText,
    "clear_job_text": clearJobText,
    "bank_information": bankInformation,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "departments": List<dynamic>.from(departments!.map((x) => x.toJson())),
    "subsidiary": subsidiary!.toJson(),
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
