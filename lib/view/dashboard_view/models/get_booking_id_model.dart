// To parse this JSON data, do
//
//     final getBookingIdModel = getBookingIdModelFromJson(jsonString);

import 'dart:convert';

GetBookingIdModel getBookingIdModelFromJson(String str) => GetBookingIdModel.fromJson(json.decode(str));

String getBookingIdModelToJson(GetBookingIdModel data) => json.encode(data.toJson());

class GetBookingIdModel {
  bool? status;
  String? driverId;
  String? bookingId;
  bool? hasActiveBooking;

  GetBookingIdModel({
    this.status,
    this.driverId,
    this.bookingId,
    this.hasActiveBooking,
  });

  factory GetBookingIdModel.fromJson(Map<String, dynamic> json) => GetBookingIdModel(
    status: json["status"],
    driverId: json["driver_id"],
    bookingId: json["booking_id"],
    hasActiveBooking: json["has_active_booking"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "driver_id": driverId,
    "booking_id": bookingId,
    "has_active_booking": hasActiveBooking,
  };
}
