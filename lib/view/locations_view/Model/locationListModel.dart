// To parse this JSON data, do
//
//     final locationListModel = locationListModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final locationListModel = locationListModelFromJson(jsonString);

import 'dart:convert';

LocationListModel locationListModelFromJson(String str) => LocationListModel.fromJson(json.decode(str));

String locationListModelToJson(LocationListModel data) => json.encode(data.toJson());

class LocationListModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Location>? locations;

  LocationListModel({
    this.status,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.locations,
  });

  factory LocationListModel.fromJson(Map<String, dynamic> json) => LocationListModel(
    status: json["status"],
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPages: json["total_pages"],
    count: json["count"],
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
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
  String? zone;

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
    zone: json["zone"],
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
    "zone": zone,
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







class Vertices {
  double? latitude;
  double? longitude;

  Vertices({this.latitude, this.longitude});

  Vertices.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
