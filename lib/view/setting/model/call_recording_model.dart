// To parse this JSON data, do
//
//     final callRecordingModel = callRecordingModelFromJson(jsonString);

import 'dart:convert';

CallRecordingModel callRecordingModelFromJson(String str) => CallRecordingModel.fromJson(json.decode(str));

String callRecordingModelToJson(CallRecordingModel data) => json.encode(data.toJson());

class CallRecordingModel {
  bool? status;
  int? count;
  List<Recording>? recordings;

  CallRecordingModel({
    this.status,
    this.count,
    this.recordings,
  });

  factory CallRecordingModel.fromJson(Map<String, dynamic> json) => CallRecordingModel(
    status: json["status"],
    count: json["count"],
    recordings: json["recordings"] == null ? [] : List<Recording>.from(json["recordings"]!.map((x) => Recording.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "recordings": recordings == null ? [] : List<dynamic>.from(recordings!.map((x) => x.toJson())),
  };
}

class Recording {
  int? id;
  String? recordingId;
  String? token;
  String? eventType;
  int? duration;
  String? datetime;
  String? source;
  String? destination;
  String? filename;
  String? filePath;
  String? customer;

  Recording({
    this.id,
    this.recordingId,
    this.token,
    this.eventType,
    this.duration,
    this.datetime,
    this.source,
    this.destination,
    this.filename,
    this.filePath,
    this.customer,
  });

  factory Recording.fromJson(Map<String, dynamic> json) => Recording(
    id: json["_id"],
    recordingId: json["recording_id"],
    token: json["token"],
    eventType: json["event_type"],
    duration: json["duration"],
    datetime: json["datetime"],
    source: json["source"],
    destination: json["destination"],
    filename: json["filename"],
    filePath: json["file_path"],
    customer: json["customer"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "recording_id": recordingId,
    "token": token,
    "event_type": eventType,
    "duration": duration,
    "datetime": datetime,
    "source": source,
    "destination": destination,
    "filename": filename,
    "file_path": filePath,
    "customer": customer,
  };
}
