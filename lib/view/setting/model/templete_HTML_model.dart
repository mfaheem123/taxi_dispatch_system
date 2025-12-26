// To parse this JSON data, do
//
//     final htmlTempleteModel = htmlTempleteModelFromJson(jsonString);

import 'dart:convert';

HtmlTempleteModel htmlTempleteModelFromJson(String str) => HtmlTempleteModel.fromJson(json.decode(str));

String htmlTempleteModelToJson(HtmlTempleteModel data) => json.encode(data.toJson());

class HtmlTempleteModel {
  bool? status;
  Templates? templates;

  HtmlTempleteModel({
    this.status,
    this.templates,
  });

  factory HtmlTempleteModel.fromJson(Map<String, dynamic> json) => HtmlTempleteModel(
    status: json["status"],
    templates: json["templates"] == null ? null : Templates.fromJson(json["templates"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "templates": templates?.toJson(),
  };
}

class Templates {
  int? id;
  int? templateTypeId;
  String? name;
  String? subject;
  String? content;
  String? body;
  TemplateType? templateType;

  Templates({
    this.id,
    this.templateTypeId,
    this.name,
    this.subject,
    this.content,
    this.body,
    this.templateType,
  });

  factory Templates.fromJson(Map<String, dynamic> json) => Templates(
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
