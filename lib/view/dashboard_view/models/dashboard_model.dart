// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'dart:convert';

DashboardDataModel dashboardDataModelFromJson(String str) => DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) => json.encode(data.toJson());

class DashboardDataModel {
  bool? status;
  List<BookingStatus>? bookingStatuses;
  List<BookingType>? bookingTypes;
  List<JourneyType>? journeyTypes;
  List<PaymentStatus>? paymentStatuses;
  List<PaymentType>? paymentTypes;
  List<VehicleType>? vehicleTypes;
  List<DashboardSubsidiaryObject>? subsidiaries;
  List<DashboardDriverObject>? drivers;

  DashboardDataModel({
    this.status,
    this.bookingStatuses,
    this.bookingTypes,
    this.journeyTypes,
    this.paymentStatuses,
    this.paymentTypes,
    this.vehicleTypes,
    this.subsidiaries,
    this.drivers,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) => DashboardDataModel(
    status: json["status"],
    bookingStatuses: List<BookingStatus>.from(json["booking_statuses"].map((x) => BookingStatus.fromJson(x))),
    bookingTypes: List<BookingType>.from(json["booking_types"].map((x) => BookingType.fromJson(x))),
    journeyTypes: List<JourneyType>.from(json["journey_types"].map((x) => JourneyType.fromJson(x))),
    paymentStatuses: List<PaymentStatus>.from(json["payment_statuses"].map((x) => PaymentStatus.fromJson(x))),
    paymentTypes: List<PaymentType>.from(json["payment_types"].map((x) => PaymentType.fromJson(x))),
    vehicleTypes: List<VehicleType>.from(json["vehicle_types"].map((x) => VehicleType.fromJson(x))),
    subsidiaries: List<DashboardSubsidiaryObject>.from(json["subsidiaries"].map((x) => DashboardSubsidiaryObject.fromJson(x))),
    drivers: List<DashboardDriverObject>.from(json["drivers"].map((x) => DashboardDriverObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "booking_statuses": List<dynamic>.from(bookingStatuses!.map((x) => x.toJson())),
    "booking_types": List<dynamic>.from(bookingTypes!.map((x) => x.toJson())),
    "journey_types": List<dynamic>.from(journeyTypes!.map((x) => x.toJson())),
    "payment_statuses": List<dynamic>.from(paymentStatuses!.map((x) => x.toJson())),
    "payment_types": List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
    "vehicle_types": List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "subsidiaries": List<dynamic>.from(subsidiaries!.map((x) => x!.toJson())),
    "drivers": List<dynamic>.from(drivers!.map((x) => x.toJson())),
  };
}

class BookingStatus {
  int? id;
  String? bookingStatus;

  BookingStatus({
    this.id,
    this.bookingStatus,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
    id: json["id"],
    bookingStatus: json["booking_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_status": bookingStatus,
  };
}

class BookingType {
  int? id;
  String? bookingType;

  BookingType({
    this.id,
    this.bookingType,
  });

  factory BookingType.fromJson(Map<String, dynamic> json) => BookingType(
    id: json["id"],
    bookingType: json["booking_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_type": bookingType,
  };
}

class DashboardDriverObject {
  int? id;
  String? username;
  String? name;
  String? email;

  DashboardDriverObject({
    this.id,
    this.username,
    this.name,
    this.email,
  });

  factory DashboardDriverObject.fromJson(Map<String, dynamic> json) => DashboardDriverObject(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "email": email,
  };
}

class JourneyType {
  int? id;
  String? journeyType;

  JourneyType({
    this.id,
    this.journeyType,
  });

  factory JourneyType.fromJson(Map<String, dynamic> json) => JourneyType(
    id: json["id"],
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "journey_type": journeyType,
  };
}

class PaymentStatus {
  int? id;
  String? paymentStatus;

  PaymentStatus({
    this.id,
    this.paymentStatus,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) => PaymentStatus(
    id: json["id"],
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "payment_status": paymentStatus,
  };
}

class PaymentType {
  int? id;
  String? name;
  dynamic service;
  String? backgroundColor;
  String? foregroundColor;

  PaymentType({
    this.id,
    this.name,
    this.service,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
    id: json["id"],
    name: json["name"],
    service: json["service"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "service": service,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class DashboardSubsidiaryObject {
  int? id;
  String? backgroundColor;
  String? foregroundColor;
  String? name;

  DashboardSubsidiaryObject({
    this.id,
    this.backgroundColor,
    this.foregroundColor,
    this.name,
  });

  factory DashboardSubsidiaryObject.fromJson(Map<String, dynamic> json) => DashboardSubsidiaryObject(
    id: json["id"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "name": name,
  };
}

class VehicleType {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? handLuggages;
  int? minimumFares;
  int? minimumMiles;
  int? waitingTime;
  int? waitingTimeDuration;
  bool? defaultVehicle;
  bool? vehicleTypeMinimumFares;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? backgroundColor;
  String? foregroundColor;
  int? driverWaitingCharges;
  int? accountWaitingCharges;

  VehicleType({
    this.id,
    this.name,
    this.passengers,
    this.luggages,
    this.handLuggages,
    this.minimumFares,
    this.minimumMiles,
    this.waitingTime,
    this.waitingTimeDuration,
    this.defaultVehicle,
    this.vehicleTypeMinimumFares,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.backgroundColor,
    this.foregroundColor,
    this.driverWaitingCharges,
    this.accountWaitingCharges,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    id: json["id"],
    name: json["name"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    handLuggages: json["hand_luggages"],
    minimumFares: json["minimum_fares"],
    minimumMiles: json["minimum_miles"],
    waitingTime: json["waiting_time"],
    waitingTimeDuration: json["waiting_time_duration"],
    defaultVehicle: json["default_vehicle"],
    vehicleTypeMinimumFares: json["vehicle_type_minimum_fares"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    driverWaitingCharges: json["driver_waiting_charges"],
    accountWaitingCharges: json["account_waiting_charges"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "passengers": passengers,
    "luggages": luggages,
    "hand_luggages": handLuggages,
    "minimum_fares": minimumFares,
    "minimum_miles": minimumMiles,
    "waiting_time": waitingTime,
    "waiting_time_duration": waitingTimeDuration,
    "default_vehicle": defaultVehicle,
    "vehicle_type_minimum_fares": vehicleTypeMinimumFares,
    "image": image,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "driver_waiting_charges": driverWaitingCharges,
    "account_waiting_charges": accountWaitingCharges,
  };
}
