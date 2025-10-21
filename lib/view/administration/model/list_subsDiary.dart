// To parse this JSON data, do
//
//     final subsDiaryModel = subsDiaryModelFromJson(jsonString);

import 'dart:convert';

SubsDiaryModel subsDiaryModelFromJson(String str) => SubsDiaryModel.fromJson(json.decode(str));

String subsDiaryModelToJson(SubsDiaryModel data) => json.encode(data.toJson());

class SubsDiaryModel {
    bool? status;
    int? statusCode;
    int? count;
    List<Subsidiary>? subsidiaries;

    SubsDiaryModel({
        this.status,
        this.statusCode,
        this.count,
        this.subsidiaries,
    });

    factory SubsDiaryModel.fromJson(Map<String, dynamic> json) => SubsDiaryModel(
        status: json["status"],
        statusCode: json["statusCode"],
        count: json["count"],
        subsidiaries: json["subsidiaries"] == null ? [] : List<Subsidiary>.from(json["subsidiaries"]!.map((x) => Subsidiary.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "count": count,
        "subsidiaries": subsidiaries == null ? [] : List<dynamic>.from(subsidiaries!.map((x) => x.toJson())),
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
