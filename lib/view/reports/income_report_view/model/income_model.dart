// To parse this JSON data, do
//
//     final incomeModel = incomeModelFromJson(jsonString);

import 'dart:convert';

IncomeModel incomeModelFromJson(String str) => IncomeModel.fromJson(json.decode(str));

String incomeModelToJson(IncomeModel data) => json.encode(data.toJson());

class IncomeModel {
  bool? success;
  int? page;
  int? limit;
  int? totalPages;
  int? count;
  int? totalBookings;
  double? totalEarnings;
  List<IncomeBooking>? bookings;

  IncomeModel({
    this.success,
    this.page,
    this.limit,
    this.totalPages,
    this.count,
    this.totalBookings,
    this.totalEarnings,
    this.bookings,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
    success: json["success"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["total_pages"],
    count: json["count"],
    totalBookings: json["total_bookings"],
    totalEarnings: json["total_earnings"]?.toDouble(),
    bookings: json["bookings"] == null ? [] : List<IncomeBooking>.from(json["bookings"]!.map((x) => IncomeBooking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "page": page,
    "limit": limit,
    "total_pages": totalPages,
    "count": count,
    "total_bookings": totalBookings,
    "total_earnings": totalEarnings,
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class IncomeBooking {
  String? id;
  String? referenceNumber;
  DateTime? pickupDate;
  String? pickupTime;
  String? pickup;
  String? dropoff;
  String? vehicle;
  String? driverUsername;
  String? driverName;
  String? account;
  String? fares;
  String? parking;
  String? waiting;
  String? extraDrop;
  String? total;

  IncomeBooking({
    this.id,
    this.referenceNumber,
    this.pickupDate,
    this.pickupTime,
    this.pickup,
    this.dropoff,
    this.vehicle,
    this.driverUsername,
    this.driverName,
    this.account,
    this.fares,
    this.parking,
    this.waiting,
    this.extraDrop,
    this.total,
  });

  factory IncomeBooking.fromJson(Map<String, dynamic> json) => IncomeBooking(
    id: json["id"],
    referenceNumber: json["reference_number"],
    pickupDate: json["pickup_date"] == null
        ? null
        : DateTime.tryParse(json["pickup_date"].toString().replaceAllMapped(RegExp(r'-(\d)(?=-|$)'), (m) => '-0${m[1]}')),
    pickupTime: json["pickup_time"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    vehicle: json["vehicle"],
    driverUsername: json["driver_username"],
    driverName: json["driver_name"],
    account: json["account"],
    fares: json["fares"],
    parking: json["parking"],
    waiting: json["waiting"],
    extraDrop: json["extra_drop"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_number": referenceNumber,
    "pickup_date": pickupDate?.toIso8601String().split('T').first,
    "pickup_time": pickupTime,
    "pickup": pickup,
    "dropoff": dropoff,
    "vehicle": vehicle,
    "driver_username": driverUsername,
    "driver_name": driverName,
    "account": account,
    "fares": fares,
    "parking": parking,
    "waiting": waiting,
    "extra_drop": extraDrop,
    "total": total,
  };
}
