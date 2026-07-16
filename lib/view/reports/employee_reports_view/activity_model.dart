// To parse this JSON data, do
//
//     final employeeReportModel = employeeReportModelFromJson(jsonString);

import 'dart:convert';

EmployeeReportModel employeeReportModelFromJson(String str) => EmployeeReportModel.fromJson(json.decode(str));

String employeeReportModelToJson(EmployeeReportModel data) => json.encode(data.toJson());

class EmployeeReportModel {
  bool? status;
  List<EmployeeShiftHistory>? employeeShiftHistory;

  EmployeeReportModel({
    this.status,
    this.employeeShiftHistory,
  });

  factory EmployeeReportModel.fromJson(Map<String, dynamic> json) => EmployeeReportModel(
    status: json["status"],
    employeeShiftHistory: json["employee_shift_history"] == null ? [] : List<EmployeeShiftHistory>.from(json["employee_shift_history"]!.map((x) => EmployeeShiftHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "employee_shift_history": employeeShiftHistory == null ? [] : List<dynamic>.from(employeeShiftHistory!.map((x) => x.toJson())),
  };
}

class EmployeeShiftHistory {
  int? id;
  int? employeeId;
  String? loginDatetime;
  String? logoutDatetime;
  int? bookingsCreated;
  int? bookingsDispatched;
  int? bookingsCancelled;
  int? callsAnswered;
  String? workingHours;

  EmployeeShiftHistory({
    this.id,
    this.employeeId,
    this.loginDatetime,
    this.logoutDatetime,
    this.bookingsCreated,
    this.bookingsDispatched,
    this.bookingsCancelled,
    this.callsAnswered,
    this.workingHours,
  });

  factory EmployeeShiftHistory.fromJson(Map<String, dynamic> json) => EmployeeShiftHistory(
    id: json["id"],
    employeeId: json["employee_id"],
    loginDatetime: json["login_datetime"],
    logoutDatetime: json["logout_datetime"],
    bookingsCreated: json["bookings_created"],
    bookingsDispatched: json["bookings_dispatched"],
    bookingsCancelled: json["bookings_cancelled"],
    callsAnswered: json["calls_answered"],
    workingHours: json["working_hours"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "login_datetime": loginDatetime,
    "logout_datetime": logoutDatetime,
    "bookings_created": bookingsCreated,
    "bookings_dispatched": bookingsDispatched,
    "bookings_cancelled": bookingsCancelled,
    "calls_answered": callsAnswered,
    "working_hours": workingHours,
  };
}