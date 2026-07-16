// To parse this JSON data, do
//
//     final bookingGraph = bookingGraphFromJson(jsonString);

import 'dart:convert';

BookingGraph bookingGraphFromJson(String str) => BookingGraph.fromJson(json.decode(str));

String bookingGraphToJson(BookingGraph data) => json.encode(data.toJson());

class BookingGraph {
  bool? success;
  List<Datum>? data;

  BookingGraph({
    this.success,
    this.data,
  });

  factory BookingGraph.fromJson(Map<String, dynamic> json) => BookingGraph(
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  DateTime? date;
  List<Payment>? payments;

  Datum({
    this.date,
    this.payments,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
  };
}

class Payment {
  String? paymentType;
  int? totalBookings;
  double? totalFares;

  Payment({
    this.paymentType,
    this.totalBookings,
    this.totalFares,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    paymentType: json["payment_type"],
    totalBookings: json["total_bookings"],
    totalFares: json["total_fares"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "payment_type": paymentType,
    "total_bookings": totalBookings,
    "total_fares": totalFares,
  };
}