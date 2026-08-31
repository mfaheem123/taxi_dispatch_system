// To parse this JSON data, do
//
//     final driverLoginReportListModel = driverLoginReportListModelFromJson(jsonString);

import 'dart:convert';

DriverLoginReportListModel driverLoginReportListModelFromJson(String str) => DriverLoginReportListModel.fromJson(json.decode(str));

String driverLoginReportListModelToJson(DriverLoginReportListModel data) => json.encode(data.toJson());

class DriverLoginReportListModel {
  bool? success;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<DriverShiftHistory>? driverShiftHistories;

  DriverLoginReportListModel({
    this.success,
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.count,
    this.driverShiftHistories,
  });

  factory DriverLoginReportListModel.fromJson(Map<String, dynamic> json) {
    dynamic shiftHistoriesData = json["driver_shift_histories"];

    List<DriverShiftHistory> histories = [];
    int? page = json["page"] is int ? json["page"] : int.tryParse(json["page"]?.toString() ?? "");
    int? limit = json["limit"] is int ? json["limit"] : int.tryParse(json["limit"]?.toString() ?? "");
    int? total = json["total"] is int ? json["total"] : int.tryParse(json["total"]?.toString() ?? "");
    int? totalPages = json["total_pages"] is int ? json["total_pages"] : int.tryParse(json["total_pages"]?.toString() ?? "");
    int? count = json["count"] is int ? json["count"] : int.tryParse(json["count"]?.toString() ?? "");
    bool? success = json["success"] ?? json["status"];

    if (shiftHistoriesData is Map<String, dynamic>) {
      page = shiftHistoriesData["page"] is int
          ? shiftHistoriesData["page"]
          : int.tryParse(shiftHistoriesData["page"]?.toString() ?? "") ?? page;
      limit = shiftHistoriesData["limit"] is int
          ? shiftHistoriesData["limit"]
          : int.tryParse(shiftHistoriesData["limit"]?.toString() ?? "") ?? limit;
      total = shiftHistoriesData["total"] is int
          ? shiftHistoriesData["total"]
          : int.tryParse(shiftHistoriesData["total"]?.toString() ?? "") ?? total;
      totalPages = shiftHistoriesData["total_pages"] is int
          ? shiftHistoriesData["total_pages"]
          : int.tryParse(shiftHistoriesData["total_pages"]?.toString() ?? "") ?? totalPages;
      count = shiftHistoriesData["count"] is int
          ? shiftHistoriesData["count"]
          : int.tryParse(shiftHistoriesData["count"]?.toString() ?? "") ?? count;

      if (shiftHistoriesData["data"] is List) {
        histories = (shiftHistoriesData["data"] as List)
            .map((x) => DriverShiftHistory.fromJson(x as Map<String, dynamic>))
            .toList();
      }
    } else if (shiftHistoriesData is List) {
      histories = shiftHistoriesData
          .map((x) => DriverShiftHistory.fromJson(x as Map<String, dynamic>))
          .toList();
    } else if (json["data"] is List) {
      histories = (json["data"] as List)
          .map((x) => DriverShiftHistory.fromJson(x as Map<String, dynamic>))
          .toList();
    }

    return DriverLoginReportListModel(
      success: success,
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      count: count,
      driverShiftHistories: histories,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "page": page,
    "limit": limit,
    "total": total,
    "total_pages": totalPages,
    "count": count,
    "driver_shift_histories": driverShiftHistories == null ? [] : List<dynamic>.from(driverShiftHistories!.map((x) => x.toJson())),
  };
}

class DriverShiftHistory {
  int? id;
  int? driverId;
  DateTime? loginDate;
  double? loginLatitude;
  double? loginLongitude;
  DateTime? logoutDate;
  double? logoutLatitude;
  double? logoutLongitude;
  List<dynamic>? booking;
  String? loginTime;
  String? logoutTime;
  Driver? driver;

  DriverShiftHistory({
    this.id,
    this.driverId,
    this.loginDate,
    this.loginLatitude,
    this.loginLongitude,
    this.logoutDate,
    this.logoutLatitude,
    this.logoutLongitude,
    this.booking,
    this.loginTime,
    this.logoutTime,
    this.driver,
  });

  factory DriverShiftHistory.fromJson(Map<String, dynamic> json) => DriverShiftHistory(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
    driverId: json["driver_id"] is int ? json["driver_id"] : int.tryParse(json["driver_id"]?.toString() ?? ""),
    loginDate: json["login_date"] == null ? null : DateTime.tryParse(json["login_date"].toString()),
    loginLatitude: json["login_latitude"] != null ? double.tryParse(json["login_latitude"].toString()) : null,
    loginLongitude: json["login_longitude"] != null ? double.tryParse(json["login_longitude"].toString()) : null,
    logoutDate: json["logout_date"] == null ? null : DateTime.tryParse(json["logout_date"].toString()),
    logoutLatitude: json["logout_latitude"] != null ? double.tryParse(json["logout_latitude"].toString()) : null,
    logoutLongitude: json["logout_longitude"] != null ? double.tryParse(json["logout_longitude"].toString()) : null,
    booking: json["booking"] == null
        ? []
        : (json["booking"] is List
            ? List<dynamic>.from(json["booking"])
            : []),
    loginTime: json["login_time"]?.toString(),
    logoutTime: json["logout_time"]?.toString(),
    driver: json["driver"] == null
        ? null
        : (json["driver"] is Map<String, dynamic>
            ? Driver.fromJson(json["driver"])
            : null),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "login_date": loginDate == null ? null : "${loginDate!.year.toString().padLeft(4, '0')}-${loginDate!.month.toString().padLeft(2, '0')}-${loginDate!.day.toString().padLeft(2, '0')}",
    "login_latitude": loginLatitude,
    "login_longitude": loginLongitude,
    "logout_date": logoutDate == null ? null : "${logoutDate!.year.toString().padLeft(4, '0')}-${logoutDate!.month.toString().padLeft(2, '0')}-${logoutDate!.day.toString().padLeft(2, '0')}",
    "logout_latitude": logoutLatitude,
    "logout_longitude": logoutLongitude,
    "booking": booking == null ? [] : List<dynamic>.from(booking!.map((x) => x)),
    "login_time": loginTime,
    "logout_time": logoutTime,
    "driver": driver?.toJson(),
  };
}

class Driver {
  String? username;

  Driver({
    this.username,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    username: json["username"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
  };
}

