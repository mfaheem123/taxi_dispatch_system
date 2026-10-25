// To parse this JSON data, do
//
//     final emailTrackingModel = emailTrackingModelFromJson(jsonString);

import 'dart:convert';

EmailTrackingModel emailTrackingModelFromJson(String str) => EmailTrackingModel.fromJson(json.decode(str));

String emailTrackingModelToJson(EmailTrackingModel data) => json.encode(data.toJson());

class EmailTrackingModel {
  bool? status;
  int? count;
  int? totalPages;
  int? currentPage;
  int? limit;
  List<Email>? emails;

  EmailTrackingModel({
    this.status,
    this.count,
    this.totalPages,
    this.currentPage,
    this.limit,
    this.emails,
  });

  factory EmailTrackingModel.fromJson(Map<String, dynamic> json) => EmailTrackingModel(
    status: json["status"],
    count: json["count"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    limit: json["limit"],
    emails: json["emails"] == null ? [] : List<Email>.from(json["emails"]!.map((x) => Email.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "totalPages": totalPages,
    "currentPage": currentPage,
    "limit": limit,
    "emails": emails == null ? [] : List<dynamic>.from(emails!.map((x) => x.toJson())),
  };
}

class Email {
  int? id;
  String? email;
  String? subject;
  String? content;
  DateTime? date;
  String? time;
  String? status;

  Email({
    this.id,
    this.email,
    this.subject,
    this.content,
    this.date,
    this.time,
    this.status,
  });

  factory Email.fromJson(Map<String, dynamic> json) => Email(
    id: json["id"],
    email: json["email"],
    subject: json["subject"],
    content: json["content"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    time: json["time"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "subject": subject,
    "content": content,
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "time": time,
    "status": status,
  };
}
