// To parse this JSON data, do
//
//     final selectTempleteType = selectTempleteTypeFromJson(jsonString);

import 'dart:convert';

SelectTempleteType selectTempleteTypeFromJson(String str) => SelectTempleteType.fromJson(json.decode(str));

String selectTempleteTypeToJson(SelectTempleteType data) => json.encode(data.toJson());

class SelectTempleteType {
  bool? status;
  List<TemplateType>? templateTypes;

  SelectTempleteType({
    this.status,
    this.templateTypes,
  });

  factory SelectTempleteType.fromJson(Map<String, dynamic> json) => SelectTempleteType(
    status: json["status"],
    templateTypes: json["template_types"] == null ? [] : List<TemplateType>.from(json["template_types"]!.map((x) => TemplateType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "template_types": templateTypes == null ? [] : List<dynamic>.from(templateTypes!.map((x) => x.toJson())),
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
