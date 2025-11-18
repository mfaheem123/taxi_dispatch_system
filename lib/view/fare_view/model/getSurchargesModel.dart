// To parse this JSON data, do
//
//     final getSurchargesModel = getSurchargesModelFromJson(jsonString);

import 'dart:convert';

GetSurchargesModel getSurchargesModelFromJson(String str) => GetSurchargesModel.fromJson(json.decode(str));

String getSurchargesModelToJson(GetSurchargesModel data) => json.encode(data.toJson());

class GetSurchargesModel {
  bool? status;
  int? count;
  List<SurchargeObject>? surcharges;

  GetSurchargesModel({
    this.status,
    this.count,
    this.surcharges,
  });

  factory GetSurchargesModel.fromJson(Map<String, dynamic> json) => GetSurchargesModel(
    status: json["status"],
    count: json["count"],
    surcharges: json["surcharges"] == null ? [] : List<SurchargeObject>.from(json["surcharges"]!.map((x) => SurchargeObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "surcharges": surcharges == null ? [] : List<dynamic>.from(surcharges!.map((x) => x.toJson())),
  };
}

class SurchargeObject {
  int? id;
  String? fromDate;
  String? toDate;
  String? surchargesType;
  String? condition;
  String? postcode;
  String? surchargeOperator;
  String? fare;
  String? parkingCharges;
  String? extraDropCharges;
  String? congestionCharges;
  String? duration;
  String? fromTime;
  String? toTime;
  bool? active;
  dynamic day;
  String? createdAt;
  String? updatedAt;

  SurchargeObject({
    this.id,
    this.fromDate,
    this.toDate,
    this.surchargesType,
    this.condition,
    this.postcode,
    this.surchargeOperator,
    this.fare,
    this.parkingCharges,
    this.extraDropCharges,
    this.congestionCharges,
    this.duration,
    this.fromTime,
    this.toTime,
    this.active,
    this.day,
    this.createdAt,
    this.updatedAt,
  });

  factory SurchargeObject.fromJson(Map<String, dynamic> json) => SurchargeObject(
    id: json["id"],
    fromDate: json["from_date"],
    toDate: json["to_date"],
    surchargesType: json["surcharges_type"],
    condition: json["condition"],
    postcode: json["postcode"],
    surchargeOperator: json["operator"],
    fare: json["fare"],
    parkingCharges: json["parking_charges"],
    extraDropCharges: json["extra_drop_charges"],
    congestionCharges: json["congestion_charges"],
    duration: json["duration"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    active: json["active"],
    day: json["day"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_date": fromDate,
    "to_date": toDate,
    "surcharges_type": surchargesType,
    "condition": condition,
    "postcode": postcode,
    "operator": surchargeOperator,
    "fare": fare,
    "parking_charges": parkingCharges,
    "extra_drop_charges": extraDropCharges,
    "congestion_charges": congestionCharges,
    "duration": duration,
    "from_time": fromTime,
    "to_time": toTime,
    "active": active,
    "day": day,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
