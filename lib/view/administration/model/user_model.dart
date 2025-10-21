// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    bool? status;
    int? statusCode;
    int? count;
    List<Employee>? employees;

    UserModel({
        this.status,
        this.statusCode,
        this.count,
        this.employees,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        statusCode: json["statusCode"],
        count: json["count"],
        employees: json["employees"] == null ? [] : List<Employee>.from(json["employees"]!.map((x) => Employee.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "statusCode": statusCode,
        "count": count,
        "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
    };
}

class Employee {
    int? id;
    int? subsidiaryId;
    int? roleId;
    String? username;
    String? password;
    String? email;
    String? phone;
    dynamic fax;
    dynamic image;
    dynamic webDeviceId;
    dynamic mobileDeviceId;
    dynamic extensionNumber;
    bool? releaseNoteViewed;
    String? createdAt;
    String? updatedAt;
    String? roleName;
    String? subsidiaryName;
    Role? role;
    Role? subsidiary;

    Employee({
        this.id,
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
        this.subsidiary,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        subsidiaryId: json["subsidiary_id"],
        roleId: json["role_id"],
        username: json["username"],
        password: json["password"],
        email: json["email"],
        phone: json["phone"],
        fax: json["fax"],
        image: json["image"],
        webDeviceId: json["web_device_id"],
        mobileDeviceId: json["mobile_device_id"],
        extensionNumber: json["extension_number"],
        releaseNoteViewed: json["release_note_viewed"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        roleName: json["role_name"],
        subsidiaryName: json["subsidiary_name"],
        role: json["role"] == null ? null : Role.fromJson(json["role"]),
        subsidiary: json["subsidiary"] == null ? null : Role.fromJson(json["subsidiary"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "subsidiary_id": subsidiaryId,
        "role_id": roleId,
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
        "fax": fax,
        "image": image,
        "web_device_id": webDeviceId,
        "mobile_device_id": mobileDeviceId,
        "extension_number": extensionNumber,
        "release_note_viewed": releaseNoteViewed,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "role_name": roleName,
        "subsidiary_name": subsidiaryName,
        "role": role?.toJson(),
        "subsidiary": subsidiary?.toJson(),
    };
}

class Role {
    String? name;

    Role({
        this.name,
    });

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
