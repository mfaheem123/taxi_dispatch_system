// To parse this JSON data, do
//
//     final getCustomerModel = getCustomerModelFromJson(jsonString);

import 'dart:convert';

GetCustomerModel getCustomerModelFromJson(String str) => GetCustomerModel.fromJson(json.decode(str));

String getCustomerModelToJson(GetCustomerModel data) => json.encode(data.toJson());

class GetCustomerModel {
    bool status;
    int page;
    int limit;
    int total;
    int totalPages;
    int count;
    List<Customer> customers;

    GetCustomerModel({
        required this.status,
        required this.page,
        required this.limit,
        required this.total,
        required this.totalPages,
        required this.count,
        required this.customers,
    });

    factory GetCustomerModel.fromJson(Map<String, dynamic> json) => GetCustomerModel(
        status: json["status"],
        page: json["page"],
        limit: json["limit"],
        total: json["total"],
        totalPages: json["total_pages"],
        count: json["count"],
        customers: List<Customer>.from(json["customers"].map((x) => Customer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "limit": limit,
        "total": total,
        "total_pages": totalPages,
        "count": count,
        "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
    };
}

class Customer {
    int id;
    String name;
    String email;
    String mobile;
    String telephone;
    dynamic fax;
    String doorNumber;
    String address1;
    String address2;
    bool blacklist;
    dynamic blacklistReason;
    String notes;
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
    bool smsFlag;
    String createdAt;
    List<RestrictedDriver> restrictedDrivers;

    Customer({
        required this.id,
        required this.name,
        required this.email,
        required this.mobile,
        required this.telephone,
        required this.fax,
        required this.doorNumber,
        required this.address1,
        required this.address2,
        required this.blacklist,
        required this.blacklistReason,
        required this.notes,
        required this.username,
        required this.password,
        required this.webDeviceId,
        required this.mobileDeviceId,
        required this.emailVerificationCode,
        required this.mobileVerificationCode,
        required this.emailVerified,
        required this.mobileVerified,
        required this.emailVerifiedAt,
        required this.mobileVerifiedAt,
        required this.smsFlag,
        required this.createdAt,
        required this.restrictedDrivers,
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
        restrictedDrivers: List<RestrictedDriver>.from(json["restricted_drivers"].map((x) => RestrictedDriver.fromJson(x))),
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
        "restricted_drivers": List<dynamic>.from(restrictedDrivers.map((x) => x.toJson())),
    };
}

class RestrictedDriver {
    int id;
    String username;
    String name;

    RestrictedDriver({
        required this.id,
        required this.username,
        required this.name,
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
