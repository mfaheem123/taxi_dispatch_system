// To parse this JSON data, do
//
//     final getCustomerComplainsModel = getCustomerComplainsModelFromJson(jsonString);

import 'dart:convert';

GetCustomerComplainsModel getCustomerComplainsModelFromJson(String str) => GetCustomerComplainsModel.fromJson(json.decode(str));

String getCustomerComplainsModelToJson(GetCustomerComplainsModel data) => json.encode(data.toJson());

class GetCustomerComplainsModel {
  bool? status;
  int? count;
  List<Complaint>? complaints;

  GetCustomerComplainsModel({
    this.status,
    this.count,
    this.complaints,
  });

  factory GetCustomerComplainsModel.fromJson(Map<String, dynamic> json) => GetCustomerComplainsModel(
    status: json["status"],
    count: json["count"],
    complaints: json["complaints"] == null ? [] : List<Complaint>.from(json["complaints"]!.map((x) => Complaint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
    "complaints": complaints == null ? [] : List<dynamic>.from(complaints!.map((x) => x.toJson())),
  };
}

class Complaint {
  int? id;
  String? referenceNumber;
  DateTime? complainDate;
  String? incidentDate;
  int? customerId;
  int? bookingId;
  String? complaint;
  String? dealtWith;
  String? result;
  int? driverId;
  dynamic employeeId;
  dynamic accountId;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  Booking? booking;

  Complaint({
    this.id,
    this.referenceNumber,
    this.complainDate,
    this.incidentDate,
    this.customerId,
    this.bookingId,
    this.complaint,
    this.dealtWith,
    this.result,
    this.driverId,
    this.employeeId,
    this.accountId,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.booking,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: int.tryParse(json["id"]?.toString() ?? ""),
      referenceNumber: json["reference_number"]?.toString(),

      complainDate: json["complain_date"] == null
          ? null
          : DateTime.tryParse(json["complain_date"].toString()),

      incidentDate: json["incident_date"]?.toString(),

      customerId:
      int.tryParse(json["customer_id"]?.toString() ?? ""),

      bookingId:
      int.tryParse(json["booking_id"]?.toString() ?? ""),

      complaint: json["complaint"]?.toString(),
      dealtWith: json["dealt_with"]?.toString(),
      result: json["result"]?.toString(),

      driverId:
      int.tryParse(json["driver_id"]?.toString() ?? ""),

      employeeId: json["employee_id"],
      accountId: json["account_id"],

      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),

      customer: json["customer"] == null
          ? null
          : Customer.fromJson(
        json["customer"] as Map<String, dynamic>,
      ),

      booking: json["booking"] == null
          ? null
          : Booking.fromJson(
        json["booking"] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reference_number": referenceNumber,
      "complain_date": complainDate?.toIso8601String(),
      "incident_date": incidentDate,
      "customer_id": customerId,
      "booking_id": bookingId,
      "complaint": complaint,
      "dealt_with": dealtWith,
      "result": result,
      "driver_id": driverId,
      "employee_id": employeeId,
      "account_id": accountId,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "customer": customer?.toJson(),
      "booking": booking?.toJson(),
    };
  }
}

class Booking {
  String? referenceNumber;
  String? notes;

  Booking({
    this.referenceNumber,
    this.notes,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    referenceNumber: json["reference_number"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "reference_number": referenceNumber,
    "notes": notes,
  };
}

class Customer {
  String? name;

  Customer({
    this.name,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
