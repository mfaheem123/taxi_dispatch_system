// To parse this JSON data, do
//
//     final getMobileNumberWithNameModel = getMobileNumberWithNameModelFromJson(jsonString);

import 'dart:convert';

GetMobileNumberWithNameModel getMobileNumberWithNameModelFromJson(String str) => GetMobileNumberWithNameModel.fromJson(json.decode(str));

String getMobileNumberWithNameModelToJson(GetMobileNumberWithNameModel data) => json.encode(data.toJson());

class GetMobileNumberWithNameModel {
  bool? status;
  List<BookingStatus>? bookingStatuses;
  List<BookingType>? bookingTypes;
  List<JourneyType>? journeyTypes;
  List<PaymentStatus>? paymentStatuses;
  List<PaymentType>? paymentTypes;
  List<VehicleType>? vehicleTypes;
  List<Customer>? customers;
  List<Subsidiary>? subsidiaries;

  GetMobileNumberWithNameModel({
    this.status,
    this.bookingStatuses,
    this.bookingTypes,
    this.journeyTypes,
    this.paymentStatuses,
    this.paymentTypes,
    this.vehicleTypes,
    this.customers,
    this.subsidiaries,
  });

  factory GetMobileNumberWithNameModel.fromJson(Map<String, dynamic> json) => GetMobileNumberWithNameModel(
    status: json["status"],
    bookingStatuses: json["booking_statuses"] == null ? [] : List<BookingStatus>.from(json["booking_statuses"]!.map((x) => BookingStatus.fromJson(x))),
    bookingTypes: json["booking_types"] == null ? [] : List<BookingType>.from(json["booking_types"]!.map((x) => BookingType.fromJson(x))),
    journeyTypes: json["journey_types"] == null ? [] : List<JourneyType>.from(json["journey_types"]!.map((x) => JourneyType.fromJson(x))),
    paymentStatuses: json["payment_statuses"] == null ? [] : List<PaymentStatus>.from(json["payment_statuses"]!.map((x) => PaymentStatus.fromJson(x))),
    paymentTypes: json["payment_types"] == null ? [] : List<PaymentType>.from(json["payment_types"]!.map((x) => PaymentType.fromJson(x))),
    vehicleTypes: json["vehicle_types"] == null ? [] : List<VehicleType>.from(json["vehicle_types"]!.map((x) => VehicleType.fromJson(x))),
    customers: json["customers"] == null ? [] : List<Customer>.from(json["customers"]!.map((x) => Customer.fromJson(x))),
    subsidiaries: json["subsidiaries"] == null ? [] : List<Subsidiary>.from(json["subsidiaries"]!.map((x) => Subsidiary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "booking_statuses": bookingStatuses == null ? [] : List<dynamic>.from(bookingStatuses!.map((x) => x.toJson())),
    "booking_types": bookingTypes == null ? [] : List<dynamic>.from(bookingTypes!.map((x) => x.toJson())),
    "journey_types": journeyTypes == null ? [] : List<dynamic>.from(journeyTypes!.map((x) => x.toJson())),
    "payment_statuses": paymentStatuses == null ? [] : List<dynamic>.from(paymentStatuses!.map((x) => x.toJson())),
    "payment_types": paymentTypes == null ? [] : List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
    "vehicle_types": vehicleTypes == null ? [] : List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "customers": customers == null ? [] : List<dynamic>.from(customers!.map((x) => x.toJson())),
    "subsidiaries": subsidiaries == null ? [] : List<dynamic>.from(subsidiaries!.map((x) => x.toJson())),
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

class Customer {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? telephone;
  dynamic fax;
  String? doorNumber;
  String? address1;
  String? address2;
  bool? blacklist;
  dynamic blacklistReason;
  String? notes;
  dynamic username;
  dynamic password;
  dynamic webDeviceId;
  dynamic mobileDeviceId;
  dynamic emailVerificationCode;
  dynamic mobileVerificationCode;
  dynamic emailVerified;
  dynamic mobileVerified;
  dynamic emailVerifiedAt;
  dynamic mobileVerifiedAt;
  bool? smsFlag;
  String? createdAt;

  Customer({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.telephone,
    this.fax,
    this.doorNumber,
    this.address1,
    this.address2,
    this.blacklist,
    this.blacklistReason,
    this.notes,
    this.username,
    this.password,
    this.webDeviceId,
    this.mobileDeviceId,
    this.emailVerificationCode,
    this.mobileVerificationCode,
    this.emailVerified,
    this.mobileVerified,
    this.emailVerifiedAt,
    this.mobileVerifiedAt,
    this.smsFlag,
    this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    fax: json["fax"],
    doorNumber: json["door_number"],
    address1: json["address1"],
    address2: json["address2"],
    blacklist: json["blacklist"],
    blacklistReason: json["blacklist_reason"],
    notes: json["notes"],
    username: json["username"],
    password: json["password"],
    webDeviceId: json["web_device_id"],
    mobileDeviceId: json["mobile_device_id"],
    emailVerificationCode: json["email_verification_code"],
    mobileVerificationCode: json["mobile_verification_code"],
    emailVerified: json["email_verified"],
    mobileVerified: json["mobile_verified"],
    emailVerifiedAt: json["email_verified_at"],
    mobileVerifiedAt: json["mobile_verified_at"],
    smsFlag: json["sms_flag"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "telephone": telephone,
    "fax": fax,
    "door_number": doorNumber,
    "address1": address1,
    "address2": address2,
    "blacklist": blacklist,
    "blacklist_reason": blacklistReason,
    "notes": notes,
    "username": username,
    "password": password,
    "web_device_id": webDeviceId,
    "mobile_device_id": mobileDeviceId,
    "email_verification_code": emailVerificationCode,
    "mobile_verification_code": mobileVerificationCode,
    "email_verified": emailVerified,
    "mobile_verified": mobileVerified,
    "email_verified_at": emailVerifiedAt,
    "mobile_verified_at": mobileVerifiedAt,
    "sms_flag": smsFlag,
    "created_at": createdAt,
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

class Subsidiary {
  int? id;
  dynamic logo;
  String? backgroundColor;
  String? foregroundColor;
  String? name;
  String? telephoneNumber;
  String? emergencyContactNumber;
  String? email;
  String? fax;
  String? website;
  String? address;
  String? sortCode;
  String? accountNumber;
  String? accountTitle;
  String? bank;
  String? companyNumber;
  String? vatNumber;
  String? iban;
  String? balance;
  String? currency;
  String? webAccessToken;
  String? mobileAccessToken;
  int? maximumDrivers;
  int? activeDrivers;
  double? addressLatitude;
  double? addressLongitude;
  String? createdAt;
  String? updatedAt;

  Subsidiary({
    this.id,
    this.logo,
    this.backgroundColor,
    this.foregroundColor,
    this.name,
    this.telephoneNumber,
    this.emergencyContactNumber,
    this.email,
    this.fax,
    this.website,
    this.address,
    this.sortCode,
    this.accountNumber,
    this.accountTitle,
    this.bank,
    this.companyNumber,
    this.vatNumber,
    this.iban,
    this.balance,
    this.currency,
    this.webAccessToken,
    this.mobileAccessToken,
    this.maximumDrivers,
    this.activeDrivers,
    this.addressLatitude,
    this.addressLongitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    id: json["id"],
    logo: json["logo"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    name: json["name"],
    telephoneNumber: json["telephone_number"],
    emergencyContactNumber: json["emergency_contact_number"],
    email: json["email"],
    fax: json["fax"],
    website: json["website"],
    address: json["address"],
    sortCode: json["sort_code"],
    accountNumber: json["account_number"],
    accountTitle: json["account_title"],
    bank: json["bank"],
    companyNumber: json["company_number"],
    vatNumber: json["vat_number"],
    iban: json["iban"],
    balance: json["balance"],
    currency: json["currency"],
    webAccessToken: json["web_access_token"],
    mobileAccessToken: json["mobile_access_token"],
    maximumDrivers: json["maximum_drivers"],
    activeDrivers: json["active_drivers"],
    addressLatitude: json["address_latitude"]?.toDouble(),
    addressLongitude: json["address_longitude"]?.toDouble(),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "name": name,
    "telephone_number": telephoneNumber,
    "emergency_contact_number": emergencyContactNumber,
    "email": email,
    "fax": fax,
    "website": website,
    "address": address,
    "sort_code": sortCode,
    "account_number": accountNumber,
    "account_title": accountTitle,
    "bank": bank,
    "company_number": companyNumber,
    "vat_number": vatNumber,
    "iban": iban,
    "balance": balance,
    "currency": currency,
    "web_access_token": webAccessToken,
    "mobile_access_token": mobileAccessToken,
    "maximum_drivers": maximumDrivers,
    "active_drivers": activeDrivers,
    "address_latitude": addressLatitude,
    "address_longitude": addressLongitude,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
  String? createdAt;
  String? updatedAt;
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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "driver_waiting_charges": driverWaitingCharges,
    "account_waiting_charges": accountWaitingCharges,
  };
}
