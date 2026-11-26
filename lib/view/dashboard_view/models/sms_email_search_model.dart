// To parse this JSON data, do
//
//     final smsEmailSearchModel = smsEmailSearchModelFromJson(jsonString);

import 'dart:convert';

SmsEmailSearchModel smsEmailSearchModelFromJson(String str) => SmsEmailSearchModel.fromJson(json.decode(str));

String smsEmailSearchModelToJson(SmsEmailSearchModel data) => json.encode(data.toJson());

class SmsEmailSearchModel {
  bool? status;
  int? count;
  List<SearchContactItem>? data;

  SmsEmailSearchModel({
    this.status,
    this.count,
    this.data,
  });

  factory SmsEmailSearchModel.fromJson(Map<String, dynamic> json) => SmsEmailSearchModel(
    status: json["status"],
    count: json["count"],
    data: json["data"] == null ? [] : List<SearchContactItem>.from(json["data"]!.map((x) => SearchContactItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SearchContactItem {
  int? id;
  String? name;
  String? mobile;
  String? email;

  SearchContactItem({
    this.id,
    this.name,
    this.mobile,
    this.email,
  });

  factory SearchContactItem.fromJson(Map<String, dynamic> json) => SearchContactItem(
    id: json["id"] is String ? int.tryParse(json["id"]) : json["id"],
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "email": email,
  };
}
