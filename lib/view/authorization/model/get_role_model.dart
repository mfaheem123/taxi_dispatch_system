// To parse this JSON data, do
//
//     final getRoleModel = getRoleModelFromJson(jsonString);

import 'dart:convert';

GetRoleModel getRoleModelFromJson(String str) => GetRoleModel.fromJson(json.decode(str));

String getRoleModelToJson(GetRoleModel data) => json.encode(data.toJson());

class GetRoleModel {
  bool? status;
  int? statusCode;
  int? count;
  List<Role>? roles;

  GetRoleModel({
    this.status,
    this.statusCode,
    this.count,
    this.roles,
  });

  factory GetRoleModel.fromJson(Map<String, dynamic> json) => GetRoleModel(
    status: json["status"],
    statusCode: json["statusCode"],
    count: json["count"],
    roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "count": count,
    "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x.toJson())),
  };
}

class Role {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Role({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
