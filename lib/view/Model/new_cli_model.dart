// To parse this JSON data, do
//
//     final cliCustomerModel = cliCustomerModelFromJson(jsonString);

import 'dart:convert';

import '../dashboard_view/models/dashboard_table_model.dart';

CliCustomerModel cliCustomerModelFromJson(String str) => CliCustomerModel.fromJson(json.decode(str));

String cliCustomerModelToJson(CliCustomerModel data) => json.encode(data.toJson());

class CliCustomerModel {
  bool? success;
  bool? isNew;
  CliCustomerModelCustomer? customer;
  Bookings? bookings;
  Stats? stats;

  CliCustomerModel({
    this.success,
    this.isNew,
    this.customer,
    this.bookings,
    this.stats,
  });

  factory CliCustomerModel.fromJson(Map<String, dynamic> json) => CliCustomerModel(
    success: json["success"],
    isNew: json["is_new"],
    customer: json["customer"] == null ? null : CliCustomerModelCustomer.fromJson(json["customer"]),
    bookings: json["bookings"] == null ? null : Bookings.fromJson(json["bookings"]),
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "is_new": isNew,
    "customer": customer?.toJson(),
    "bookings": bookings?.toJson(),
    "stats": stats?.toJson(),
  };
}

class Bookings {
  List<BookingObjectData>? current;
  List<BookingObjectData>? past;
  List<BookingObjectData>? quoted;

  Bookings({
    this.current,
    this.past,
    this.quoted,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
    current: json["current"] == null ? [] : List<BookingObjectData>.from(json["current"]!.map((x) => BookingObjectData.fromJson(x))),
    past: json["past"] == null ? [] : List<BookingObjectData>.from(json["past"]!.map((x) => BookingObjectData.fromJson(x))),
    quoted: json["quoted"] == null ? [] : List<BookingObjectData>.from(json["quoted"]!.map((x) => BookingObjectData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "current": current == null ? [] : List<dynamic>.from(current!.map((x) => x.toJson())),
    "past": past == null ? [] : List<dynamic>.from(past!.map((x) => x.toJson())),
    "quoted": quoted == null ? [] : List<dynamic>.from(quoted!.map((x) => x.toJson())),
  };
}


class CliCustomerModelCustomer {
  int? id;
  bool? smsFlag;
  String? name;
  String? mobile;
  String? email;
  String? telephone;

  CliCustomerModelCustomer({
    this.id,
    this.smsFlag,
    this.name,
    this.mobile,
    this.email,
    this.telephone,
  });

  factory CliCustomerModelCustomer.fromJson(Map<String, dynamic> json) => CliCustomerModelCustomer(
    id: json["id"],
    smsFlag: json["sms_flag"],
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
    telephone: json["telephone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sms_flag": smsFlag,
    "name": name,
    "mobile": mobile,
    "email": email,
    "telephone": telephone,
  };
}

class Stats {
  int? total;
  int? current;
  int? completed;
  int? cancelled;
  int? quoted;

  Stats({
    this.total,
    this.current,
    this.completed,
    this.cancelled,
    this.quoted,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    total: json["total"],
    current: json["current"],
    completed: json["completed"],
    cancelled: json["cancelled"],
    quoted: json["quoted"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "current": current,
    "completed": completed,
    "cancelled": cancelled,
    "quoted": quoted,
  };
}