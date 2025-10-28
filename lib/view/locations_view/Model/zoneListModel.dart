class ZoneModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Zones>? zones;

  ZoneModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.zones});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['zones'] != null) {
      zones = <Zones>[];
      json['zones'].forEach((v) {
        zones!.add(new Zones.fromJson(v));
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
    if (this.zones != null) {
      data['zones'] = this.zones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Zones {
  int? id;
  String? name;
  String? secondaryName;
  String? type;
  String? category;
  List<Vertices>? vertices;
  bool? base;
  String? overlay;
  String? createdAt;
  String? updatedAt;

  Zones(
      {this.id,
      this.name,
      this.secondaryName,
      this.type,
      this.category,
      this.vertices,
      this.base,
      this.overlay,
      this.createdAt,
      this.updatedAt});

  Zones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    secondaryName = json['secondary_name'];
    type = json['type'];
    category = json['category'];
    if (json['vertices'] != null) {
      vertices = <Vertices>[];
      json['vertices'].forEach((v) {
        vertices!.add(new Vertices.fromJson(v));
      });
    }
    base = json['base'];
    overlay = json['overlay'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['secondary_name'] = this.secondaryName;
    data['type'] = this.type;
    data['category'] = this.category;
    if (this.vertices != null) {
      data['vertices'] = this.vertices!.map((v) => v.toJson()).toList();
    }
    data['base'] = this.base;
    data['overlay'] = this.overlay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
