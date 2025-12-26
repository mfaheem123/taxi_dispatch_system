// To parse this JSON data, do
//
//     final tempTypeModel = tempTypeModelFromJson(jsonString);

import 'dart:convert';

TempTypeModel tempTypeModelFromJson(String str) => TempTypeModel.fromJson(json.decode(str));

String tempTypeModelToJson(TempTypeModel data) => json.encode(data.toJson());

class TempTypeModel {
  bool? status;
  List<TemplateType>? templateTypes;

  TempTypeModel({
    this.status,
    this.templateTypes,
  });

  factory TempTypeModel.fromJson(Map<String, dynamic> json) => TempTypeModel(
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
