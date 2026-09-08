// To parse this JSON data, do
//
//     final driverSinBinSettingModel = driverSinBinSettingModelFromJson(jsonString);

import 'dart:convert';

DriverSinBinSettingModel driverSinBinSettingModelFromJson(String str) => DriverSinBinSettingModel.fromJson(json.decode(str));

String driverSinBinSettingModelToJson(DriverSinBinSettingModel data) => json.encode(data.toJson());

class DriverSinBinSettingModel {
  bool? status;
  Sinbin? sinbin;

  DriverSinBinSettingModel({
    this.status,
    this.sinbin,
  });

  factory DriverSinBinSettingModel.fromJson(Map<String, dynamic> json) => DriverSinBinSettingModel(
    status: json["status"],
    sinbin: json["sinbin"] == null ? null : Sinbin.fromJson(json["sinbin"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "sinbin": sinbin?.toJson(),
  };
}

class Sinbin {
  int? id;
  int? recoverjob;
  int? rejectjob;
  int? ignorejob;

  Sinbin({
    this.id,
    this.recoverjob,
    this.rejectjob,
    this.ignorejob,
  });

  factory Sinbin.fromJson(Map<String, dynamic> json) => Sinbin(
    id: json["id"],
    recoverjob: json["recoverjob"],
    rejectjob: json["rejectjob"],
    ignorejob: json["ignorejob"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "recoverjob": recoverjob,
    "rejectjob": rejectjob,
    "ignorejob": ignorejob,
  };
}
