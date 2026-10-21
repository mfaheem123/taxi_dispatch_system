// To parse this JSON data, do
//
//     final invoiceNumberModel = invoiceNumberModelFromJson(jsonString);

import 'dart:convert';

InvoiceNumberModel invoiceNumberModelFromJson(String str) => InvoiceNumberModel.fromJson(json.decode(str));

String invoiceNumberModelToJson(InvoiceNumberModel data) => json.encode(data.toJson());

class InvoiceNumberModel {
  bool? status;
  DocumentNumber? documentNumber;

  InvoiceNumberModel({
    this.status,
    this.documentNumber,
  });

  factory InvoiceNumberModel.fromJson(Map<String, dynamic> json) => InvoiceNumberModel(
    status: json["status"],
    documentNumber: json["document_number"] == null ? null : DocumentNumber.fromJson(json["document_number"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "document_number": documentNumber?.toJson(),
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
