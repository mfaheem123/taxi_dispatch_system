// To parse this JSON data, do
//
//     final getManageExtentionModel = getManageExtentionModelFromJson(jsonString);

import 'dart:convert';

GetManageExtentionModel getManageExtentionModelFromJson(String str) => GetManageExtentionModel.fromJson(json.decode(str));

String getManageExtentionModelToJson(GetManageExtentionModel data) => json.encode(data.toJson());

class GetManageExtentionModel {
  bool? status;
  List<EmployeeExtension>? employeeExtensions;

  GetManageExtentionModel({
    this.status,
    this.employeeExtensions,
  });

  factory GetManageExtentionModel.fromJson(Map<String, dynamic> json) => GetManageExtentionModel(
    status: json["status"],
    employeeExtensions: json["employee_extensions"] == null ? [] : List<EmployeeExtension>.from(json["employee_extensions"]!.map((x) => EmployeeExtension.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "employee_extensions": employeeExtensions == null ? [] : List<dynamic>.from(employeeExtensions!.map((x) => x.toJson())),
  };
}

class EmployeeExtension {
  int? id;
  int? employeeId;
  String? extensionNumber;
  bool? permanentFlag;
  Employee? employee;

  EmployeeExtension({
    this.id,
    this.employeeId,
    this.extensionNumber,
    this.permanentFlag,
    this.employee,
  });

  factory EmployeeExtension.fromJson(Map<String, dynamic> json) => EmployeeExtension(
    id: json["id"],
    employeeId: json["employee_id"],
    extensionNumber: json["extension_number"],
    permanentFlag: json["permanent_flag"],
    employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "extension_number": extensionNumber,
    "permanent_flag": permanentFlag,
    "employee": employee?.toJson(),
  };
}

class Employee {
  int? id;
  String? username;

  Employee({
    this.id,
    this.username,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
