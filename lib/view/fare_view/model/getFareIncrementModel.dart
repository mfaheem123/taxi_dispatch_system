// To parse this JSON data, do
//
//     final getFareIncrementMoodel = getFareIncrementMoodelFromJson(jsonString);

import 'dart:convert';

GetFareIncrementMoodel getFareIncrementMoodelFromJson(String str) => GetFareIncrementMoodel.fromJson(json.decode(str));

String getFareIncrementMoodelToJson(GetFareIncrementMoodel data) => json.encode(data.toJson());

class GetFareIncrementMoodel {
  bool? status;
  int? count;
  List<FareIncrement>? fareIncrement;

  GetFareIncrementMoodel({
    this.status,
    this.count,
    this.fareIncrement,
  });

  factory GetFareIncrementMoodel.fromJson(Map<String, dynamic> json) => GetFareIncrementMoodel(
    status: json["status"],
    count: json["count"],
    fareIncrement: json["fareIncrement"] == null ? [] : List<FareIncrement>.from(json["fareIncrement"]!.map((x) => FareIncrement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "fareIncrement": fareIncrement == null ? [] : List<dynamic>.from(fareIncrement!.map((x) => x.toJson())),
  };
}

class FareIncrement {
  int? id;
  String? startDate;
  String? endDate;
  String? fareIncrementOperator;
  String? amount;
  bool? fixFare;
  bool? mileage;

  FareIncrement({
    this.id,
    this.startDate,
    this.endDate,
    this.fareIncrementOperator,
    this.amount,
    this.fixFare,
    this.mileage,
  });

  factory FareIncrement.fromJson(Map<String, dynamic> json) => FareIncrement(
    id: json["id"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    fareIncrementOperator: json["operator"],
    amount: json["amount"],
    fixFare: json["fix_fare"],
    mileage: json["mileage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_date": startDate,
    "end_date": endDate,
    "operator": fareIncrementOperator,
    "amount": amount,
    "fix_fare": fixFare,
    "mileage": mileage,
  };
}
