import 'location_types_zoneModel.dart';

class LocationListModel {
  bool status;
  int count;
  List<Location> locations;

  LocationListModel({
    required this.status,
    required this.count,
    required this.locations,
  });

  factory LocationListModel.fromJson(Map<String, dynamic> json) => LocationListModel(
    status: json["status"] ?? false,
    count: json["count"] ?? 0,
    locations: (json["locations"] as List?)
        ?.map((x) => Location.fromJson(x))
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "locations": locations.map((x) => x.toJson()).toList(),
  };
}

class Location {
  int id;
  String name;
  int locationTypeId;
  String address;
  String postcode;
  int zoneId;
  String shortcut;
  String backgroundColor;
  String foregroundColor;
  String extraCharges;
  String pickupCharges;
  String dropoffCharges;
  bool blacklist;
  String latitude;
  String longitude;
  LocationTypeObject? locationType;
  ZoneObject? zone;

  Location({
    required this.id,
    required this.name,
    required this.locationTypeId,
    required this.address,
    required this.postcode,
    required this.zoneId,
    required this.shortcut,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.extraCharges,
    required this.pickupCharges,
    required this.dropoffCharges,
    required this.blacklist,
    required this.latitude,
    required this.longitude,
    this.locationType,
    this.zone,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    locationTypeId: json["location_type_id"] ?? 0,
    address: json["address"] ?? '',
    postcode: json["postcode"] ?? '',
    zoneId: json["zone_id"] ?? 0,
    shortcut: json["shortcut"] ?? '',
    backgroundColor: json["background_color"] ?? "#FFFFFF",
    foregroundColor: json["foreground_color"] ?? "#000000",
    extraCharges: json["extra_charges"] ?? '0',
    pickupCharges: json["pickup_charges"] ?? '0',
    dropoffCharges: json["dropoff_charges"] ?? '0',
    blacklist: json["blacklist"] ?? false,
    latitude: json["latitude"] ?? '0.0',
    longitude: json["longitude"] ?? '0.0',
    locationType: json["location_type"] != null
        ? LocationTypeObject.fromJson(json["location_type"])
        : null,
    zone: json["zone"] != null ? ZoneObject.fromJson(json["zone"]) : null,
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