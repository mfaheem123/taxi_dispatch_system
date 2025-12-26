// To parse this JSON data, do
//
//     final templeteByTypeMOdel = templeteByTypeMOdelFromJson(jsonString);

import 'dart:convert';

TempleteByTypeMOdel templeteByTypeMOdelFromJson(String str) => TempleteByTypeMOdel.fromJson(json.decode(str));

String templeteByTypeMOdelToJson(TempleteByTypeMOdel data) => json.encode(data.toJson());

class TempleteByTypeMOdel {
  bool? status;
  List<Template>? templates;

  TempleteByTypeMOdel({
    this.status,
    this.templates,
  });

  factory TempleteByTypeMOdel.fromJson(Map<String, dynamic> json) => TempleteByTypeMOdel(
    status: json["status"],
    templates: json["templates"] == null ? [] : List<Template>.from(json["templates"]!.map((x) => Template.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "templates": templates == null ? [] : List<dynamic>.from(templates!.map((x) => x.toJson())),
  };
}

class Template {
  int? id;
  String? name;

  Template({
    this.id,
    this.name,
  });

  factory Template.fromJson(Map<String, dynamic> json) => Template(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
