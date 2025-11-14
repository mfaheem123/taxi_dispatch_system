// To parse this JSON data, do
//
//     final allPlotFareModel = allPlotFareModelFromJson(jsonString);

import 'dart:convert';

AllPlotFareModel allPlotFareModelFromJson(String str) => AllPlotFareModel.fromJson(json.decode(str));

String allPlotFareModelToJson(AllPlotFareModel data) => json.encode(data.toJson());

class AllPlotFareModel {
  bool? status;
  int? count;
  List<PlotFare>? plotFares;

  AllPlotFareModel({
    this.status,
    this.count,
    this.plotFares,
  });

  factory AllPlotFareModel.fromJson(Map<String, dynamic> json) => AllPlotFareModel(
    status: json["status"],
    count: json["count"],
    plotFares: json["plot_fares"] == null ? [] : List<PlotFare>.from(json["plot_fares"]!.map((x) => PlotFare.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "plot_fares": plotFares == null ? [] : List<dynamic>.from(plotFares!.map((x) => x.toJson())),
  };
}

class PlotFare {
  int? id;
  int? vehicleTypeId;
  String? fares;
  VehicleType? vehicleType;
  Plot? pickupPlot;
  Plot? dropoffPlot;

  PlotFare({
    this.id,
    this.vehicleTypeId,
    this.fares,
    this.vehicleType,
    this.pickupPlot,
    this.dropoffPlot,
  });

  factory PlotFare.fromJson(Map<String, dynamic> json) => PlotFare(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    fares: json["fares"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
    pickupPlot: json["pickup_plot"] == null ? null : Plot.fromJson(json["pickup_plot"]),
    dropoffPlot: json["dropoff_plot"] == null ? null : Plot.fromJson(json["dropoff_plot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "fares": fares,
    "vehicle_type": vehicleType?.toJson(),
    "pickup_plot": pickupPlot?.toJson(),
    "dropoff_plot": dropoffPlot?.toJson(),
  };
}

class Plot {
  int? id;
  String? name;

  Plot({
    this.id,
    this.name,
  });

  factory Plot.fromJson(Map<String, dynamic> json) => Plot(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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
