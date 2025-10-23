// To parse this JSON data, do
//
//     final getZoneListModel = getZoneListModelFromJson(jsonString);

import 'dart:convert';

GetZoneListModel getZoneListModelFromJson(String str) => GetZoneListModel.fromJson(json.decode(str));

String getZoneListModelToJson(GetZoneListModel data) => json.encode(data.toJson());

class GetZoneListModel {
  bool? status;
  int? count;
  List<Zone>? zones;

  GetZoneListModel({
    this.status,
    this.count,
    this.zones,
  });

  factory GetZoneListModel.fromJson(Map<String, dynamic> json) => GetZoneListModel(
    status: json["status"],
    count: json["count"],
    zones: json["zones"] == null ? [] : List<Zone>.from(json["zones"]!.map((x) => Zone.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
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
  String? createdAt;
  String? updatedAt;

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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "created_at": createdAt,
    "updated_at": updatedAt,
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
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
