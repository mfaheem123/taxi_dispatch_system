class UserModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Employees>? employees;

  UserModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.employees});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['employees'] != null) {
      employees = <Employees>[];
      json['employees'].forEach((v) {
        employees!.add(new Employees.fromJson(v));
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
    if (this.employees != null) {
      data['employees'] = this.employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Employees {
  int? id;
  int? subsidiaryId;
  int? roleId;
  String? username;
  String? password;
  String? email;
  String? phone;
  String? fax;
  String? image;
  String? webDeviceId;
  String? mobileDeviceId;
  String? extensionNumber;
  bool? releaseNoteViewed;
  String? createdAt;
  String? updatedAt;
  String? roleName;
  String? subsidiaryName;
  Role? role;
  Role? subsidiary;

  Employees(
      {this.id,
      this.subsidiaryId,
      this.roleId,
      this.username,
      this.password,
      this.email,
      this.phone,
      this.fax,
      this.image,
      this.webDeviceId,
      this.mobileDeviceId,
      this.extensionNumber,
      this.releaseNoteViewed,
      this.createdAt,
      this.updatedAt,
      this.roleName,
      this.subsidiaryName,
      this.role,
      this.subsidiary});

  Employees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subsidiaryId = json['subsidiary_id'];
    roleId = json['role_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    phone = json['phone'];
    fax = json['fax'];
    image = json['image'];
    webDeviceId = json['web_device_id'];
    mobileDeviceId = json['mobile_device_id'];
    extensionNumber = json['extension_number'];
    releaseNoteViewed = json['release_note_viewed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roleName = json['role_name'];
    subsidiaryName = json['subsidiary_name'];
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
    subsidiary = json['subsidiary'] != null
        ? new Role.fromJson(json['subsidiary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subsidiary_id'] = this.subsidiaryId;
    data['role_id'] = this.roleId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fax'] = this.fax;
    data['image'] = this.image;
    data['web_device_id'] = this.webDeviceId;
    data['mobile_device_id'] = this.mobileDeviceId;
    data['extension_number'] = this.extensionNumber;
    data['release_note_viewed'] = this.releaseNoteViewed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role_name'] = this.roleName;
    data['subsidiary_name'] = this.subsidiaryName;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    if (this.subsidiary != null) {
      data['subsidiary'] = this.subsidiary!.toJson();
    }
    return data;
  }
}

class Role {
  String? name;

  Role({this.name});

  Role.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
