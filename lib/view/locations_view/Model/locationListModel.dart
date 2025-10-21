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
  LocationType? locationType;
  Zone? zone;

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
        ? LocationType.fromJson(json["location_type"])
        : null,
    zone: json["zone"] != null ? Zone.fromJson(json["zone"]) : null,
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
  int id;
  String name;
  String shortcut;
  String backgroundColor;
  String foregroundColor;

  LocationType({
    required this.id,
    required this.name,
    required this.shortcut,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    shortcut: json["shortcut"] ?? '',
    backgroundColor: json["background_color"] ?? "#FFFFFF",
    foregroundColor: json["foreground_color"] ?? "#000000",
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
  int id;
  bool base;
  String name;
  String type;
  String overlay;
  String category;
  List<Vertex> vertices;
  String secondaryName;

  Zone({
    required this.id,
    required this.base,
    required this.name,
    required this.type,
    required this.overlay,
    required this.category,
    required this.vertices,
    required this.secondaryName,
  });

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json["id"] ?? 0,
    base: json["base"] ?? false,
    name: json["name"] ?? '',
    type: json["type"] ?? '',
    overlay: json["overlay"] ?? '',
    category: json["category"] ?? '',
    vertices: (json["vertices"] as List?)
        ?.map((x) => Vertex.fromJson(x))
        .toList() ??
        [],
    secondaryName: json["secondary_name"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "base": base,
    "name": name,
    "type": type,
    "overlay": overlay,
    "category": category,
    "vertices": vertices.map((x) => x.toJson()).toList(),
    "secondary_name": secondaryName,
  };
}

class Vertex {
  Bounds? bounds;
  Center? center;

  Vertex({this.bounds, this.center});

  factory Vertex.fromJson(Map<String, dynamic> json) => Vertex(
    bounds:
    json["bounds"] != null ? Bounds.fromJson(json["bounds"]) : null,
    center:
    json["center"] != null ? Center.fromJson(json["center"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "bounds": bounds?.toJson(),
    "center": center?.toJson(),
  };
}

class Bounds {
  double east;
  double west;
  double north;
  double south;

  Bounds({
    required this.east,
    required this.west,
    required this.north,
    required this.south,
  });

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
    east: (json["east"] ?? 0).toDouble(),
    west: (json["west"] ?? 0).toDouble(),
    north: (json["north"] ?? 0).toDouble(),
    south: (json["south"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "east": east,
    "west": west,
    "north": north,
    "south": south,
  };
}

class Center {
  double lat;
  double lng;

  Center({
    required this.lat,
    required this.lng,
  });

  factory Center.fromJson(Map<String, dynamic> json) => Center(
    lat: (json["lat"] ?? 0).toDouble(),
    lng: (json["lng"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}
