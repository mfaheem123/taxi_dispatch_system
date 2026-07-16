// To parse this JSON data, do
//
//     final earningInfoListModel = earningInfoListModelFromJson(jsonString);

import 'dart:convert';

EarningInfoListModel earningInfoListModelFromJson(String str) => EarningInfoListModel.fromJson(json.decode(str));

String earningInfoListModelToJson(EarningInfoListModel data) => json.encode(data.toJson());

class EarningInfoListModel {
  bool? success;
  Data? data;

  EarningInfoListModel({
    this.success,
    this.data,
  });

  factory EarningInfoListModel.fromJson(Map<String, dynamic> json) => EarningInfoListModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  int? totalTrips;
  double? totalEarnings;
  double? averagePerTrip;
  double? cashCollected;
  List<ChartDatum>? chartData;

  Data({
    this.totalTrips,
    this.totalEarnings,
    this.averagePerTrip,
    this.cashCollected,
    this.chartData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalTrips: json["total_trips"],
    totalEarnings: json["total_earnings"]?.toDouble(),
    averagePerTrip: json["average_per_trip"]?.toDouble(),
    cashCollected: json["cash_collected"]?.toDouble(),
    chartData: json["chart_data"] == null ? [] : List<ChartDatum>.from(json["chart_data"]!.map((x) => ChartDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_trips": totalTrips,
    "total_earnings": totalEarnings,
    "average_per_trip": averagePerTrip,
    "cash_collected": cashCollected,
    "chart_data": chartData == null ? [] : List<dynamic>.from(chartData!.map((x) => x.toJson())),
  };
}

class ChartDatum {
  String? label;
  String? earnings;

  ChartDatum({
    this.label,
    this.earnings,
  });

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
    label: json["label"],
    earnings: json["earnings"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "earnings": earnings,
  };
}