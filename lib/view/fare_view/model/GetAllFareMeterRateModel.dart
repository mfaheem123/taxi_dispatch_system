// To parse this JSON data, do
//
//     final getAllFareMeterRateModel = getAllFareMeterRateModelFromJson(jsonString);

import 'dart:convert';

GetAllFareMeterRateModel getAllFareMeterRateModelFromJson(String str) => GetAllFareMeterRateModel.fromJson(json.decode(str));

String getAllFareMeterRateModelToJson(GetAllFareMeterRateModel data) => json.encode(data.toJson());

class GetAllFareMeterRateModel {
  bool? status;
  int? count;
  List<FareMeter>? fareMeters;

  GetAllFareMeterRateModel({
    this.status,
    this.count,
    this.fareMeters,
  });

  factory GetAllFareMeterRateModel.fromJson(Map<String, dynamic> json) => GetAllFareMeterRateModel(
    status: json["status"],
    count: json["count"],
    fareMeters: json["fareMeters"] == null ? [] : List<FareMeter>.from(json["fareMeters"]!.map((x) => FareMeter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "fareMeters": fareMeters == null ? [] : List<dynamic>.from(fareMeters!.map((x) => x.toJson())),
  };
}

class FareMeter {
  int? id;
  bool? hasMeter;
  bool? autostartWait;
  int? autostartWaitingSpeedLimit;
  int? autostartWaitingTime;
  int? autostopWaitingSpeedLimit;
  List<WaitingCharge>? waitingCharges;
  int? waitingIntervals;
  int? vehicleTypeId;
  VehicleType? vehicleType;

  FareMeter({
    this.id,
    this.hasMeter,
    this.autostartWait,
    this.autostartWaitingSpeedLimit,
    this.autostartWaitingTime,
    this.autostopWaitingSpeedLimit,
    this.waitingCharges,
    this.waitingIntervals,
    this.vehicleTypeId,
    this.vehicleType,
  });

  factory FareMeter.fromJson(Map<String, dynamic> json) => FareMeter(
    id: json["id"],
    hasMeter: json["has_meter"],
    autostartWait: json["autostart_wait"],
    autostartWaitingSpeedLimit: json["autostart_waiting_speed_limit"],
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
  int? charge;
  String? toTime;
  String? fromTime;

  WaitingCharge({
    this.day,
    this.charge,
    this.toTime,
    this.fromTime,
  });

  factory WaitingCharge.fromJson(Map<String, dynamic> json) => WaitingCharge(
    day: json["day"],
    charge: json["charge"],
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
