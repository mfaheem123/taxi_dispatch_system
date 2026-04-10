// To parse this JSON data, do
//
//     final getLostPropertyModel = getLostPropertyModelFromJson(jsonString);

import 'dart:convert';

GetLostPropertyModel getLostPropertyModelFromJson(String str) => GetLostPropertyModel.fromJson(json.decode(str));

String getLostPropertyModelToJson(GetLostPropertyModel data) => json.encode(data.toJson());

class GetLostPropertyModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<LostProperty>? lostProperties;

  GetLostPropertyModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.lostProperties,
  });

  factory GetLostPropertyModel.fromJson(Map<String, dynamic> json) => GetLostPropertyModel(
    status: json["status"],
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["total_pages"],
    count: json["count"],
    lostProperties: json["lost_properties"] == null ? [] : List<LostProperty>.from(json["lost_properties"]!.map((x) => LostProperty.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "lost_properties": lostProperties == null ? [] : List<dynamic>.from(lostProperties!.map((x) => x.toJson())),
  };
}

class LostProperty {
  int? id;
  String? lostNumber;
  DateTime? reportDate;
  DateTime? lostDate;
  String? itemDescription;
  CustomerList? customer;

  LostProperty({
    this.id,
    this.lostNumber,
    this.reportDate,
    this.lostDate,
    this.itemDescription,
    this.customer,
  });

  factory LostProperty.fromJson(Map<String, dynamic> json) => LostProperty(
    id: json["id"],
    lostNumber: json["lost_number"],
    reportDate: (json["report_date"] == null || json["report_date"] == "") ? null : DateTime.tryParse(json["report_date"]),
    lostDate: (json["lost_date"] == null || json["lost_date"] == "") ? null : DateTime.tryParse(json["lost_date"]),
    itemDescription: json["item_description"],
    customer: json["customer"] == null ? null : CustomerList.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lost_number": lostNumber,
    "report_date": "${reportDate!.year.toString().padLeft(4, '0')}-${reportDate!.month.toString().padLeft(2, '0')}-${reportDate!.day.toString().padLeft(2, '0')}",
    "lost_date": "${lostDate!.year.toString().padLeft(4, '0')}-${lostDate!.month.toString().padLeft(2, '0')}-${lostDate!.day.toString().padLeft(2, '0')}",
    "item_description": itemDescription,
    "customer": customer?.toJson(),
  };
}

class CustomerList {
  String? name;

  CustomerList({
    this.name,
  });

  factory CustomerList.fromJson(Map<String, dynamic> json) => CustomerList(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
