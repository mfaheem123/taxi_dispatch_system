


// To parse this JSON data, do
//
//     final getPhoneNumbersModel = getPhoneNumbersModelFromJson(jsonString);

import 'dart:convert';

GetPhoneNumbersModel getPhoneNumbersModelFromJson(String str) => GetPhoneNumbersModel.fromJson(json.decode(str));

String getPhoneNumbersModelToJson(GetPhoneNumbersModel data) => json.encode(data.toJson());

class GetPhoneNumbersModel {
  bool? status;
  int? count;
  List<CustomerObject>? customerInfo;

  GetPhoneNumbersModel({
    this.status,
    this.count,
    this.customerInfo,
  });

  factory GetPhoneNumbersModel.fromJson(Map<String, dynamic> json) => GetPhoneNumbersModel(
    status: json["status"],
    count: json["count"],
    customerInfo: List<CustomerObject>.from(json["customer"].map((x) => CustomerObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "customer": List<dynamic>.from(customerInfo!.map((x) => x.toJson())),
  };
}

class CustomerObject {
  int? id;
  bool? smsFlag;
  String? name;
  String? mobile;
  String? email;
  String? telephone;
  String? doorNumber;
  String? notes;
  String? address1;
  String? address2;
  dynamic fax;
  bool? blacklist;
  dynamic blacklistReason;
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

  CustomerObject({
    this.id,
    this.smsFlag,
    this.name,
    this.mobile,
    this.email,
    this.telephone,
    this.doorNumber,
    this.notes,
    this.address1,
    this.address2,
    this.fax,
    this.blacklist,
    this.blacklistReason,
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
  });

  factory CustomerObject.fromJson(Map<String, dynamic> json) => CustomerObject(
    id: json["id"],
    smsFlag: json["sms_flag"],
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
    telephone: json["telephone"],
    doorNumber: json["door_number"],
    notes: json["notes"],
    address1: json["address1"],
    address2: json["address2"],
    fax: json["fax"],
    blacklist: json["blacklist"],
    blacklistReason: json["blacklist_reason"],
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sms_flag": smsFlag,
    "name": name,
    "mobile": mobile,
    "email": email,
    "telephone": telephone,
    "door_number": doorNumber,
    "notes": notes,
    "address1": address1,
    "address2": address2,
    "fax": fax,
    "blacklist": blacklist,
    "blacklist_reason": blacklistReason,
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
  };
}
