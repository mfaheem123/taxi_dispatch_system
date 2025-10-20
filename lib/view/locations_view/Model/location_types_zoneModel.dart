// To parse this JSON data, do
//
//     final locationtypezoneModel = locationtypezoneModelFromJson(jsonString);

import 'dart:convert';

LocationtypezoneModel locationtypezoneModelFromJson(String str) => LocationtypezoneModel.fromJson(json.decode(str));

String locationtypezoneModelToJson(LocationtypezoneModel data) => json.encode(data.toJson());

class LocationtypezoneModel {
  bool? status;
  String? message;
  int? locationTypesCount;
  int? zonesCount;
  List<LocationTypeObject>? locationTypesList;
  List<ZoneObject>? zonesList;

  LocationtypezoneModel({
    this.status,
    this.message,
    this.locationTypesCount,
    this.zonesCount,
    this.locationTypesList,
    this.zonesList,
  });

  factory LocationtypezoneModel.fromJson(Map<String, dynamic> json) => LocationtypezoneModel(
    status: json["status"],
    message: json["message"],
    locationTypesCount: json["location_types_count"],
    zonesCount: json["zones_count"],
    locationTypesList: json["location_types"] == null ? [] : List<LocationTypeObject>.from(json["location_types"]!.map((x) => LocationTypeObject.fromJson(x))),
    zonesList: json["zones"] == null ? [] : List<ZoneObject>.from(json["zones"]!.map((x) => ZoneObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "location_types_count": locationTypesCount,
    "zones_count": zonesCount,
    "location_types": locationTypesList == null ? [] : List<dynamic>.from(locationTypesList!.map((x) => x.toJson())),
    "zones": zonesList == null ? [] : List<dynamic>.from(zonesList!.map((x) => x.toJson())),
  };
}

class LocationTypeObject {
  int? id;
  String? name;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;

  LocationTypeObject({
    this.id,
    this.name,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory LocationTypeObject.fromJson(Map<String, dynamic> json) => LocationTypeObject(
    id: json["id"],
    name: json["name"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class ZoneObject {
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

  ZoneObject({
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

  factory ZoneObject.fromJson(Map<String, dynamic> json) => ZoneObject(
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
  Bounds? bounds;
  Center? center;

  Vertex({
    this.bounds,
    this.center,
  });

  factory Vertex.fromJson(Map<String, dynamic> json) => Vertex(
    bounds: json["bounds"] == null ? null : Bounds.fromJson(json["bounds"]),
    center: json["center"] == null ? null : Center.fromJson(json["center"]),
  );

  Map<String, dynamic> toJson() => {
    "bounds": bounds?.toJson(),
    "center": center?.toJson(),
  };
}

class Bounds {
  double? east;
  double? west;
  double? north;
  double? south;

  Bounds({
    this.east,
    this.west,
    this.north,
    this.south,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
    east: json["east"]?.toDouble(),
    west: json["west"]?.toDouble(),
    north: json["north"]?.toDouble(),
    south: json["south"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "east": east,
    "west": west,
    "north": north,
    "south": south,
  };
}

class Center {
  double? lat;
  double? lng;

  Center({
    this.lat,
    this.lng,
  });

  factory Center.fromJson(Map<String, dynamic> json) => Center(
    lat: json["lat"]?.toDouble(),
    lng: json["lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}
