class LocationListModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Locations>? locations;

  LocationListModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.locations});

  LocationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['locations'] != null) {
      locations = <Locations>[];
      json['locations'].forEach((v) {
        locations!.add(new Locations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    data['count'] = this.count;
    if (this.locations != null) {
      data['locations'] = this.locations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Locations {
  int? id;
  String? name;
  int? locationTypeId;
  String? address;
  String? postcode;
  int? zoneId;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;
  String? extraCharges;
  String? pickupCharges;
  String? dropoffCharges;
  bool? blacklist;
  String? latitude;
  String? longitude;
  LocationType? locationType;
  Zone? zone;

  Locations(
      {this.id,
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
      this.zone});

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    locationTypeId = json['location_type_id'];
    address = json['address'];
    postcode = json['postcode'];
    zoneId = json['zone_id'];
    shortcut = json['shortcut'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
    extraCharges = json['extra_charges'];
    pickupCharges = json['pickup_charges'];
    dropoffCharges = json['dropoff_charges'];
    blacklist = json['blacklist'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locationType = json['location_type'] != null
        ? new LocationType.fromJson(json['location_type'])
        : null;
    zone = json['zone'] != null ? new Zone.fromJson(json['zone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location_type_id'] = this.locationTypeId;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['zone_id'] = this.zoneId;
    data['shortcut'] = this.shortcut;
    data['background_color'] = this.backgroundColor;
    data['foreground_color'] = this.foregroundColor;
    data['extra_charges'] = this.extraCharges;
    data['pickup_charges'] = this.pickupCharges;
    data['dropoff_charges'] = this.dropoffCharges;
    data['blacklist'] = this.blacklist;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.locationType != null) {
      data['location_type'] = this.locationType!.toJson();
    }
    if (this.zone != null) {
      data['zone'] = this.zone!.toJson();
    }
    return data;
  }
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;

  LocationType(
      {this.id,
      this.name,
      this.shortcut,
      this.backgroundColor,
      this.foregroundColor});

  LocationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortcut = json['shortcut'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shortcut'] = this.shortcut;
    data['background_color'] = this.backgroundColor;
    data['foreground_color'] = this.foregroundColor;
    return data;
  }
}

class Zone {
  int? id;
  bool? base;
  String? name;
  String? type;
  String? overlay;
  String? category;
  List<Vertices>? vertices;
  String? secondaryName;

  Zone(
      {this.id,
      this.base,
      this.name,
      this.type,
      this.overlay,
      this.category,
      this.vertices,
      this.secondaryName});

  Zone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    base = json['base'];
    name = json['name'];
    type = json['type'];
    overlay = json['overlay'];
    category = json['category'];
    if (json['vertices'] != null) {
      vertices = <Vertices>[];
      json['vertices'].forEach((v) {
        vertices!.add(new Vertices.fromJson(v));
      });
    }
    secondaryName = json['secondary_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['base'] = this.base;
    data['name'] = this.name;
    data['type'] = this.type;
    data['overlay'] = this.overlay;
    data['category'] = this.category;
    if (this.vertices != null) {
      data['vertices'] = this.vertices!.map((v) => v.toJson()).toList();
    }
    data['secondary_name'] = this.secondaryName;
    return data;
  }
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
