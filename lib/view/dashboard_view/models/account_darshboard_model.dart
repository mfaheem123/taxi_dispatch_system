

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
  String? accountType;
  String? name;
  String? email;
  String? mobile;
  String? paymentTypes;
  String? information;
  String? backgroundColor;
  String? foregroundColor;
  List<DepartmentObject>? departments;
  Subsidiary? subsidiary;

  DashboardAccountObject({
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

  factory DashboardAccountObject.fromJson(Map<String, dynamic> json) => DashboardAccountObject(
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
    departments: List<DepartmentObject>.from(json["departments"].map((x) => DepartmentObject.fromJson(x))),
    subsidiary: Subsidiary.fromJson(json["subsidiary"]),
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
    "departments": List<dynamic>.from(departments!.map((x) => x.toJson())),
    "subsidiary": subsidiary!.toJson(),
  };
}

class DepartmentObject {
  int? id;
  String? name;

  DepartmentObject({
    this.id,
    this.name,
  });

  factory DepartmentObject.fromJson(Map<String, dynamic> json) => DepartmentObject(
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
