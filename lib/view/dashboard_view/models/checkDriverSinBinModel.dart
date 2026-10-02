// To parse this JSON data, do
//
//     final checkSinBinDriver = checkSinBinDriverFromJson(jsonString);

import 'dart:convert';

CheckSinBinDriver checkSinBinDriverFromJson(String str) => CheckSinBinDriver.fromJson(json.decode(str));

String checkSinBinDriverToJson(CheckSinBinDriver data) => json.encode(data.toJson());

class CheckSinBinDriver {
  final bool status;
  final bool isInSinbin;

  CheckSinBinDriver({
    required this.status,
    required this.isInSinbin,
  });

  factory CheckSinBinDriver.fromJson(Map<String, dynamic> json) => CheckSinBinDriver(
    status: json["status"],
    isInSinbin: json["isInSinbin"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "isInSinbin": isInSinbin,
  };
}
