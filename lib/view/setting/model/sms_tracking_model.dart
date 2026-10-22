// To parse this JSON data, do
//
//     final smsTrackingModel = smsTrackingModelFromJson(jsonString);

import 'dart:convert';

SmsTrackingModel smsTrackingModelFromJson(String str) => SmsTrackingModel.fromJson(json.decode(str));

String smsTrackingModelToJson(SmsTrackingModel data) => json.encode(data.toJson());

class SmsTrackingModel {
  bool? status;
  int? count;
  List<Message>? messages;

  SmsTrackingModel({
    this.status,
    this.count,
    this.messages,
  });

  factory SmsTrackingModel.fromJson(Map<String, dynamic> json) => SmsTrackingModel(
    status: json["status"],
    count: json["count"],
    messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class Message {
  int? id;
  int? companyId;
  String? number;
  String? sms;
  DateTime? date;
  String? time;
  String? status;

  Message({
    this.id,
    this.companyId,
    this.number,
    this.sms,
    this.date,
    this.time,
    this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    companyId: json["company_id"],
    number: json["number"],
    sms: json["sms"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "number": number,
    "sms": sms,
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "status": status,
  };
}
