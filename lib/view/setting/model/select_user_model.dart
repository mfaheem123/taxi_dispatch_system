// To parse this JSON data, do
//
//     final selectUser = selectUserFromJson(jsonString);

import 'dart:convert';

SelectUser selectUserFromJson(String str) => SelectUser.fromJson(json.decode(str));

String selectUserToJson(SelectUser data) => json.encode(data.toJson());

class SelectUser {
  bool? status;
  Template? template;

  SelectUser({
    this.status,
    this.template,
  });

  factory SelectUser.fromJson(Map<String, dynamic> json) => SelectUser(
    status: json["status"],
    template: json["template"] == null ? null : Template.fromJson(json["template"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "template": template?.toJson(),
  };
}

class Template {
  int? id;
  int? templateTypeId;
  String? name;
  String? subject;
  String? content;
  String? body;
  TemplateType? templateType;

  Template({
    this.id,
    this.templateTypeId,
    this.name,
    this.subject,
    this.content,
    this.body,
    this.templateType,
  });

  factory Template.fromJson(Map<String, dynamic> json) => Template(
    id: json["id"],
    templateTypeId: json["template_type_id"],
    name: json["name"],
    subject: json["subject"],
    content: json["content"],
    body: json["body"],
    templateType: json["template_type"] == null ? null : TemplateType.fromJson(json["template_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "template_type_id": templateTypeId,
    "name": name,
    "subject": subject,
    "content": content,
    "body": body,
    "template_type": templateType?.toJson(),
  };
}

class TemplateType {
  int? id;
  String? name;

  TemplateType({
    this.id,
    this.name,
  });

  factory TemplateType.fromJson(Map<String, dynamic> json) => TemplateType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
