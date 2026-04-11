// To parse this JSON data, do
//
//     final searchCustomerByMobileModel = searchCustomerByMobileModelFromJson(jsonString);

import 'dart:convert';

SearchCustomerByMobileModel searchCustomerByMobileModelFromJson(String str) => SearchCustomerByMobileModel.fromJson(json.decode(str));

String searchCustomerByMobileModelToJson(SearchCustomerByMobileModel data) => json.encode(data.toJson());

class SearchCustomerByMobileModel {
  bool? status;
  int? count;
  List<SearchCustomer>? customer;

  SearchCustomerByMobileModel({
    this.status,
    this.count,
    this.customer,
  });

  factory SearchCustomerByMobileModel.fromJson(Map<String, dynamic> json) => SearchCustomerByMobileModel(
    status: json["status"],
    count: json["count"],
    customer: json["customer"] == null ? [] : List<SearchCustomer>.from(json["customer"]!.map((x) => SearchCustomer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "customer": customer == null ? [] : List<dynamic>.from(customer!.map((x) => x.toJson())),
  };
}

class SearchCustomer {
  int? id;
  bool? smsFlag;
  String? name;
  String? mobile;
  String? email;
  String? telephone;
  String? address1;
  String? address2;

  SearchCustomer({
    this.id,
    this.smsFlag,
    this.name,
    this.mobile,
    this.email,
    this.telephone,
    this.address1,
    this.address2,
  });

  factory SearchCustomer.fromJson(Map<String, dynamic> json) => SearchCustomer(
    id: json["id"],
    smsFlag: json["sms_flag"],
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
    telephone: json["telephone"],
    address1: json["address1"],
    address2: json["address2"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sms_flag": smsFlag,
    "name": name,
    "mobile": mobile,
    "email": email,
    "telephone": telephone,
    "address1": address1,
    "address2": address2,
  };
}
