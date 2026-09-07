


// To parse this JSON data, do
//
//     final jobsDetailsJobs = jobsDetailsJobsFromJson(jsonString);

import 'dart:convert';

import 'package:dashboard_new1/view/dashboard_view/models/dashboard_table_model.dart';

JobsDetailsJobs jobsDetailsJobsFromJson(String str) => JobsDetailsJobs.fromJson(json.decode(str));

String jobsDetailsJobsToJson(JobsDetailsJobs data) => json.encode(data.toJson());

class JobsDetailsJobs {
  bool success;
  List<BookingObjectData> booking;

  JobsDetailsJobs({
    required this.success,
    required this.booking,
  });

  factory JobsDetailsJobs.fromJson(Map<String, dynamic> json) => JobsDetailsJobs(
    success: json["success"],
    booking: List<BookingObjectData>.from(json["booking"].map((x) => BookingObjectData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "booking": List<dynamic>.from(booking.map((x) => x.toJson())),
  };
}


