// To parse this JSON data, do
//
//     final getDocumentNumberModel = getDocumentNumberModelFromJson(jsonString);

import 'dart:convert';

GetDocumentNumberModel getDocumentNumberModelFromJson(String str) => GetDocumentNumberModel.fromJson(json.decode(str));

String getDocumentNumberModelToJson(GetDocumentNumberModel data) => json.encode(data.toJson());

class GetDocumentNumberModel {
  bool? status;
  int? count;
  List<DocumentNumber>? documentNumbers;

  GetDocumentNumberModel({
    this.status,
    this.count,
    this.documentNumbers,
  });

  factory GetDocumentNumberModel.fromJson(Map<String, dynamic> json) => GetDocumentNumberModel(
    status: json["status"],
    count: json["count"],
    documentNumbers: json["document_numbers"] == null ? [] : List<DocumentNumber>.from(json["document_numbers"]!.map((x) => DocumentNumber.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "document_numbers": documentNumbers == null ? [] : List<dynamic>.from(documentNumbers!.map((x) => x.toJson())),
  };
}

class DocumentNumber {
  int? id;
  int? subsidiaryId;
  String? documentTable;
  String? documentColumn;
  String? prefix;
  int? startNumber;
  int? endNumber;
  int? incrementValue;
  bool? autoIncrement;
  String? createdAt;
  String? updatedAt;
  Subsidiary? subsidiary;

  DocumentNumber({
    this.id,
    this.subsidiaryId,
    this.documentTable,
    this.documentColumn,
    this.prefix,
    this.startNumber,
    this.endNumber,
    this.incrementValue,
    this.autoIncrement,
    this.createdAt,
    this.updatedAt,
    this.subsidiary,
  });

  factory DocumentNumber.fromJson(Map<String, dynamic> json) => DocumentNumber(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    documentTable: json["document_table"],
    documentColumn: json["document_column"],
    prefix: json["prefix"],
    startNumber: json["start_number"],
    endNumber: json["end_number"],
    incrementValue: json["increment_value"],
    autoIncrement: json["auto_increment"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    subsidiary: json["subsidiary"] == null ? null : Subsidiary.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "document_table": documentTable,
    "document_column": documentColumn,
    "prefix": prefix,
    "start_number": startNumber,
    "end_number": endNumber,
    "increment_value": incrementValue,
    "auto_increment": autoIncrement,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "subsidiary": subsidiary?.toJson(),
  };
}

class Subsidiary {
  String? name;

  Subsidiary({
    this.name,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
