// To parse this JSON data, do
//
//     final getFareIncrementMoodel = getFareIncrementMoodelFromJson(jsonString);

import 'dart:convert';

GetFareIncrementMoodel getFareIncrementMoodelFromJson(String str) => GetFareIncrementMoodel.fromJson(json.decode(str));

String getFareIncrementMoodelToJson(GetFareIncrementMoodel data) => json.encode(data.toJson());

class   GetFareIncrementMoodel {
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
  DateTime? startDate;
  DateTime? endDate;
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

  // Helper function to handle non-standard date formats
  static DateTime? _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr == "") return null;
    try {
      return DateTime.parse(dateStr.toString());
    } catch (e) {
      List<String> parts = dateStr.toString().split('-');
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null;
    }
  }

  factory FareIncrement.fromJson(Map<String, dynamic> json) => FareIncrement(
    id: json["id"],
    startDate: _parseDate(json["start_date"]),
    endDate: _parseDate(json["end_date"]),
    fareIncrementOperator: json["operator"],
    amount: json["amount"],
    fixFare: json["fix_fare"],
    mileage: json["mileage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "operator": fareIncrementOperator,
    "amount": amount,
    "fix_fare": fixFare,
    "mileage": mileage,
  };
}
