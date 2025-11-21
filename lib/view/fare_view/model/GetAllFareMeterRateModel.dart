// To parse this JSON data, do
//
//     final getAllFareMeterRateModel = getAllFareMeterRateModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

GetAllFareMeterRateModel getAllFareMeterRateModelFromJson(String str) => GetAllFareMeterRateModel.fromJson(json.decode(str));

String getAllFareMeterRateModelToJson(GetAllFareMeterRateModel data) => json.encode(data.toJson());

class GetAllFareMeterRateModel {
  bool? status;
  int? count;
  List<FareMeterObject>? fareMeters;

  GetAllFareMeterRateModel({
    this.status,
    this.count,
    this.fareMeters,
  });

  factory GetAllFareMeterRateModel.fromJson(Map<String, dynamic> json) => GetAllFareMeterRateModel(
    status: json["status"],
    count: json["count"],
    fareMeters: json["fareMeters"] == null ? [] : List<FareMeterObject>.from(json["fareMeters"]!.map((x) => FareMeterObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "fareMeters": fareMeters == null ? [] : List<dynamic>.from(fareMeters!.map((x) => x.toJson())),
  };
}

class FareMeterObject {
  int? id;
  bool hasMeter;
  bool autostartWait;
  int? autostartWaitingSpeedLimit;
  int? autostartWaitingTime;
  int? autostopWaitingSpeedLimit;
  List<WaitingCharge>? waitingCharges;
  int? waitingIntervals;
  int? vehicleTypeId;
  VehicleType? vehicleType;
  TextEditingController activeWaitingController = TextEditingController();
  TextEditingController autostartWaitingTimeController = TextEditingController();
  TextEditingController suspendWaitingSpeedController = TextEditingController();
  TextEditingController waitingIntervalsController = TextEditingController();

  FareMeterObject({
    this.id,
    this.hasMeter = false,
    this.autostartWait = false,
    this.autostartWaitingSpeedLimit,
    this.autostartWaitingTime,
    this.autostopWaitingSpeedLimit,
    this.waitingCharges,
    this.waitingIntervals,
    this.vehicleTypeId,
    this.vehicleType,
    required this.activeWaitingController,
    required this.autostartWaitingTimeController,
    required this.waitingIntervalsController,
    required this.suspendWaitingSpeedController,
  });

  factory FareMeterObject.fromJson(Map<String, dynamic> json) => FareMeterObject(
    id: json["id"],
    hasMeter: json["has_meter"],
    autostartWait: json["autostart_wait"],
    autostartWaitingSpeedLimit: json["autostart_waiting_speed_limit"],
    activeWaitingController: TextEditingController(text: json["autostart_waiting_speed_limit"].toString()),
    autostartWaitingTimeController: TextEditingController(text: json["autostart_waiting_time"].toString()),
    suspendWaitingSpeedController: TextEditingController(text: json["autostop_waiting_speed_limit"].toString()),
    waitingIntervalsController: TextEditingController(text: json["waiting_intervals"].toString()),
    autostartWaitingTime: json["autostart_waiting_time"],
    autostopWaitingSpeedLimit: json["autostop_waiting_speed_limit"],
    waitingCharges: json["waiting_charges"] == null ? [] : List<WaitingCharge>.from(json["waiting_charges"]!.map((x) => WaitingCharge.fromJson(x))),
    waitingIntervals: json["waiting_intervals"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "has_meter": hasMeter,
    "autostart_wait": autostartWait,
    "autostart_waiting_speed_limit": autostartWaitingSpeedLimit,
    "autostart_waiting_time": autostartWaitingTime,
    "autostop_waiting_speed_limit": autostopWaitingSpeedLimit,
    "waiting_charges": waitingCharges == null ? [] : List<dynamic>.from(waitingCharges!.map((x) => x.toJson())),
    "waiting_intervals": waitingIntervals,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_type": vehicleType?.toJson(),
  };
}

class VehicleType {
  String? name;

  VehicleType({
    this.name,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class WaitingCharge {
  String? day;
  num? charge;
  String? toTime;
  String? fromTime;

  WaitingCharge({
    this.day,
    this.charge,
    this.toTime,
    this.fromTime,
  });

  factory WaitingCharge.fromJson(Map<String, dynamic> json) => WaitingCharge(
    day: json["day"].toString(),
    charge: double.parse(json["charge"].toString()),
    toTime: json["to_time"],
    fromTime: json["from_time"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "charge": charge,
    "to_time": toTime,
    "from_time": fromTime,
  };
}
