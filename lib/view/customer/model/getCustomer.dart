// To parse this JSON data, do
//
//     final getCustomerModel = getCustomerModelFromJson(jsonString);

import 'dart:convert';

GetCustomerModel getCustomerModelFromJson(String str) => GetCustomerModel.fromJson(json.decode(str));

String getCustomerModelToJson(GetCustomerModel data) => json.encode(data.toJson());

class GetCustomerModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Customer>? customers;

  GetCustomerModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.customers,
  });

  factory GetCustomerModel.fromJson(Map<String, dynamic> json) => GetCustomerModel(
    status: json["status"],
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["total_pages"],
    count: json["count"],
    customers: json["customers"] == null ? [] : List<Customer>.from(json["customers"]!.map((x) => Customer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "customers": customers == null ? [] : List<dynamic>.from(customers!.map((x) => x.toJson())),
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
  String? password;
  dynamic webDeviceId;
  dynamic mobileDeviceId;
  String? emailVerificationCode;
  dynamic mobileVerificationCode;
  bool? emailVerified;
  bool? mobileVerified;
  String? emailVerifiedAt;
  dynamic mobileVerifiedAt;
  bool? smsFlag;
  String? createdAt;
  String? otpCreatedAt;
  dynamic profileImage;
  List<RestrictedDriver>? restrictedDrivers;

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
    this.otpCreatedAt,
    this.profileImage,
    this.restrictedDrivers,
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
    otpCreatedAt: json["otp_created_at"],
    profileImage: json["profile_image"],
    restrictedDrivers: json["restricted_drivers"] == null ? [] : List<RestrictedDriver>.from(json["restricted_drivers"]!.map((x) => RestrictedDriver.fromJson(x))),
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
    "otp_created_at": otpCreatedAt,
    "profile_image": profileImage,
    "restricted_drivers": restrictedDrivers == null ? [] : List<dynamic>.from(restrictedDrivers!.map((x) => x.toJson())),
  };
}

class RestrictedDriver {
  int? id;
  String? username;
  String? name;

  RestrictedDriver({
    this.id,
    this.username,
    this.name,
  });

  factory RestrictedDriver.fromJson(Map<String, dynamic> json) => RestrictedDriver(
    id: json["id"],
    username: json["username"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
  };
}
