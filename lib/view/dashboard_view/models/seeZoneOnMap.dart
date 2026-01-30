// To parse this JSON data, do
//
//     final seeZoneOnMapModel = seeZoneOnMapModelFromJson(jsonString);

import 'dart:convert';

SeeZoneOnMapModel seeZoneOnMapModelFromJson(String str) => SeeZoneOnMapModel.fromJson(json.decode(str));

String seeZoneOnMapModelToJson(SeeZoneOnMapModel data) => json.encode(data.toJson());

class SeeZoneOnMapModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Zone>? zones;

  SeeZoneOnMapModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.zones,
  });

  factory SeeZoneOnMapModel.fromJson(Map<String, dynamic> json) => SeeZoneOnMapModel(
    status: json["status"],
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["total_pages"],
    count: json["count"],
    zones: json["zones"] == null ? [] : List<Zone>.from(json["zones"]!.map((x) => Zone.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "zones": zones == null ? [] : List<dynamic>.from(zones!.map((x) => x.toJson())),
  };
}

class Zone {
  int? id;
  String? name;
  String? secondaryName;
  String? type;
  String? category;
  List<Vertex>? vertices;
  bool? base;
  String? overlay;
  DateTime? createdAt;
  DateTime? updatedAt;

  Zone({
    this.id,
    this.name,
    this.secondaryName,
    this.type,
    this.category,
    this.vertices,
    this.base,
    this.overlay,
    this.createdAt,
    this.updatedAt,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json["id"],
    name: json["name"],
    secondaryName: json["secondary_name"],
    type: json["type"],
    category: json["category"],
    vertices: json["vertices"] == null ? [] : List<Vertex>.from(json["vertices"]!.map((x) => Vertex.fromJson(x))),
    base: json["base"],
    overlay: json["overlay"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "secondary_name": secondaryName,
    "type": type,
    "category": category,
    "vertices": vertices == null ? [] : List<dynamic>.from(vertices!.map((x) => x.toJson())),
    "base": base,
    "overlay": overlay,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Vertex {
  double? latitude;
  double? longitude;

  Vertex({
    this.latitude,
    this.longitude,
  });

  factory Vertex.fromJson(Map<String, dynamic> json) => Vertex(
    latitude: double.parse(json["latitude"].toString()),
    longitude: double.parse(json["longitude"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };}