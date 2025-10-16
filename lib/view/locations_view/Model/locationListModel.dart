// To parse this JSON data, do
//
//     final locationListModel = locationListModelFromJson(jsonString);

import 'dart:convert';

LocationListModel locationListModelFromJson(String str) => LocationListModel.fromJson(json.decode(str));

String locationListModelToJson(LocationListModel data) => json.encode(data.toJson());

class LocationListModel {
  bool? status;
  int? count;
  List<Location>? locations;

  LocationListModel({
    this.status,
    this.count,
    this.locations,
  });

  factory LocationListModel.fromJson(Map<String, dynamic> json) => LocationListModel(
    status: json["status"],
    count: json["count"],
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
  };
}

class Location {
  int? id;
  String? name;
  int? locationTypeId;
  String? address;
  String? postcode;
  int? zoneId;
  String? shortcut;
  dynamic backgroundColor;
  dynamic foregroundColor;
  String? extraCharges;
  String? pickupCharges;
  String? dropoffCharges;
  bool? blacklist;
  String? latitude;
  String? longitude;
  LocationType? locationType;
  Zone? zone;

  Location({
    this.id,
    this.name,
    this.locationTypeId,
    this.address,
    this.postcode,
    this.zoneId,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
    this.extraCharges,
    this.pickupCharges,
    this.dropoffCharges,
    this.blacklist,
    this.latitude,
    this.longitude,
    this.locationType,
    this.zone,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    name: json["name"],
    locationTypeId: json["location_type_id"],
    address: json["address"],
    postcode: json["postcode"],
    zoneId: json["zone_id"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    extraCharges: json["extra_charges"],
    pickupCharges: json["pickup_charges"],
    dropoffCharges: json["dropoff_charges"],
    blacklist: json["blacklist"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    locationType: json["location_type"] == null ? null : LocationType.fromJson(json["location_type"]),
    zone: json["zone"] == null ? null : Zone.fromJson(json["zone"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type_id": locationTypeId,
    "address": address,
    "postcode": postcode,
    "zone_id": zoneId,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "extra_charges": extraCharges,
    "pickup_charges": pickupCharges,
    "dropoff_charges": dropoffCharges,
    "blacklist": blacklist,
    "latitude": latitude,
    "longitude": longitude,
    "location_type": locationType?.toJson(),
    "zone": zone?.toJson(),
  };
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;

  LocationType({
    this.id,
    this.name,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
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

class Zone {
  int? id;
  bool? base;
  String? name;
  String? type;
  String? overlay;
  String? category;
  List<Vertex>? vertices;
  String? secondaryName;

  Zone({
    this.id,
    this.base,
    this.name,
    this.type,
    this.overlay,
    this.category,
    this.vertices,
    this.secondaryName,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json["id"],
    base: json["base"],
    name: json["name"],
    type: json["type"],
    overlay: json["overlay"],
    category: json["category"],
    vertices: json["vertices"] == null ? [] : List<Vertex>.from(json["vertices"]!.map((x) => Vertex.fromJson(x))),
    secondaryName: json["secondary_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "base": base,
    "name": name,
    "type": type,
    "overlay": overlay,
    "category": category,
    "vertices": vertices == null ? [] : List<dynamic>.from(vertices!.map((x) => x.toJson())),
    "secondary_name": secondaryName,
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
