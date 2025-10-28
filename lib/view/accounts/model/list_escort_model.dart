class EscortModel {
  bool? status;
  int? page;
  int? total;
  int? totalPages;
  int? count;
  List<Escorts>? escorts;

  EscortModel(
      {this.status,
      this.page,
      this.total,
      this.totalPages,
      this.count,
      this.escorts});

  EscortModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['escorts'] != null) {
      escorts = <Escorts>[];
      json['escorts'].forEach((v) {
        escorts!.add(new Escorts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    data['count'] = this.count;
    if (this.escorts != null) {
      data['escorts'] = this.escorts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Escorts {
  int? id;
  String? name;
  String? dob;
  String? email;
  String? mobile;
  String? address;
  bool? active;
  String? image;
  String? safeguardingDocument;
  String? patDocument;
  String? firstaidDocument;
  String? dbsDocument;
  String? safeguardingNumber;
  String? patNumber;
  String? firstaidNumber;
  String? dbsNumber;
  String? safeguardingExpiry;
  String? patExpiry;
  String? firstaidExpiry;
  String? dbsExpiry;
  String? createdAt;
  String? updatedAt;

  Escorts(
      {this.id,
      this.name,
      this.dob,
      this.email,
      this.mobile,
      this.address,
      this.active,
      this.image,
      this.safeguardingDocument,
      this.patDocument,
      this.firstaidDocument,
      this.dbsDocument,
      this.safeguardingNumber,
      this.patNumber,
      this.firstaidNumber,
      this.dbsNumber,
      this.safeguardingExpiry,
      this.patExpiry,
      this.firstaidExpiry,
      this.dbsExpiry,
      this.createdAt,
      this.updatedAt});

  Escorts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dob = json['dob'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    active = json['active'];
    image = json['image'];
    safeguardingDocument = json['safeguarding_document'];
    patDocument = json['pat_document'];
    firstaidDocument = json['firstaid_document'];
    dbsDocument = json['dbs_document'];
    safeguardingNumber = json['safeguarding_number'];
    patNumber = json['pat_number'];
    firstaidNumber = json['firstaid_number'];
    dbsNumber = json['dbs_number'];
    safeguardingExpiry = json['safeguarding_expiry'];
    patExpiry = json['pat_expiry'];
    firstaidExpiry = json['firstaid_expiry'];
    dbsExpiry = json['dbs_expiry'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['active'] = this.active;
    data['image'] = this.image;
    data['safeguarding_document'] = this.safeguardingDocument;
    data['pat_document'] = this.patDocument;
    data['firstaid_document'] = this.firstaidDocument;
    data['dbs_document'] = this.dbsDocument;
    data['safeguarding_number'] = this.safeguardingNumber;
    data['pat_number'] = this.patNumber;
    data['firstaid_number'] = this.firstaidNumber;
    data['dbs_number'] = this.dbsNumber;
    data['safeguarding_expiry'] = this.safeguardingExpiry;
    data['pat_expiry'] = this.patExpiry;
    data['firstaid_expiry'] = this.firstaidExpiry;
    data['dbs_expiry'] = this.dbsExpiry;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
