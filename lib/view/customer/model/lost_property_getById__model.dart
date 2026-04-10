// To parse this JSON data, do
//
//     final lostPropertyGetByIdModel = lostPropertyGetByIdModelFromJson(jsonString);

import 'dart:convert';

LostPropertyGetByIdModel lostPropertyGetByIdModelFromJson(String str) => LostPropertyGetByIdModel.fromJson(json.decode(str));

String lostPropertyGetByIdModelToJson(LostPropertyGetByIdModel data) => json.encode(data.toJson());

class LostPropertyGetByIdModel {
  bool? status;
  LostPropertyById? lostProperty;

  LostPropertyGetByIdModel({
    this.status,
    this.lostProperty,
  });

  factory LostPropertyGetByIdModel.fromJson(Map<String, dynamic> json) => LostPropertyGetByIdModel(
    status: json["status"],
    lostProperty: json["lost_property"] == null ? null : LostPropertyById.fromJson(json["lost_property"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "lost_property": lostProperty?.toJson(),
  };
}

class LostPropertyById {
  int? id;
  int? bookingId;
  int? customerId;
  String? itemDescription;
  String? inquiry;
  String? checkedBy;
  String? methodDesposition;
  String? result;
  DateTime? lostDate;
  DateTime? reportDate;
  String? lostNumber;
  dynamic status;
  String? createdAt;
  String? referenceNumber;
  String? pickupDate;
  String? pickupTime;
  String? pickup;
  String? dropoff;
  String? vehicleTypeName;
  String? customerName;
  String? mobile;
  dynamic doorNumber;
  dynamic address1;
  dynamic address2;
  Booking? booking;
  CustomerById? customer;

  LostPropertyById({
    this.id,
    this.bookingId,
    this.customerId,
    this.itemDescription,
    this.inquiry,
    this.checkedBy,
    this.methodDesposition,
    this.result,
    this.lostDate,
    this.reportDate,
    this.lostNumber,
    this.status,
    this.createdAt,
    this.referenceNumber,
    this.pickupDate,
    this.pickupTime,
    this.pickup,
    this.dropoff,
    this.vehicleTypeName,
    this.customerName,
    this.mobile,
    this.doorNumber,
    this.address1,
    this.address2,
    this.booking,
    this.customer,
  });

  factory LostPropertyById.fromJson(Map<String, dynamic> json) => LostPropertyById(
    id: json["id"],
    bookingId: json["booking_id"],
    customerId: json["customer_id"],
    itemDescription: json["item_description"],
    inquiry: json["inquiry"],
    checkedBy: json["checked_by"],
    methodDesposition: json["method_desposition"],
    result: json["result"],
    lostDate: json["lost_date"] == null ? null : DateTime.parse(json["lost_date"]),
    reportDate: json["report_date"] == null ? null : DateTime.parse(json["report_date"]),
    lostNumber: json["lost_number"],
    status: json["status"],
    createdAt: json["created_at"],
    referenceNumber: json["reference_number"],
    pickupDate: json["pickup_date"],
    pickupTime: json["pickup_time"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    vehicleTypeName: json["vehicle_type_name"],
    customerName: json["customer_name"],
    mobile: json["mobile"],
    doorNumber: json["door_number"],
    address1: json["address1"],
    address2: json["address2"],
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
    customer: json["customer"] == null ? null : CustomerById.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_id": bookingId,
    "customer_id": customerId,
    "item_description": itemDescription,
    "inquiry": inquiry,
    "checked_by": checkedBy,
    "method_desposition": methodDesposition,
    "result": result,
    "lost_date": "${lostDate!.year.toString().padLeft(4, '0')}-${lostDate!.month.toString().padLeft(2, '0')}-${lostDate!.day.toString().padLeft(2, '0')}",
    "report_date": "${reportDate!.year.toString().padLeft(4, '0')}-${reportDate!.month.toString().padLeft(2, '0')}-${reportDate!.day.toString().padLeft(2, '0')}",
    "lost_number": lostNumber,
    "status": status,
    "created_at": createdAt,
    "reference_number": referenceNumber,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "pickup": pickup,
    "dropoff": dropoff,
    "vehicle_type_name": vehicleTypeName,
    "customer_name": customerName,
    "mobile": mobile,
    "door_number": doorNumber,
    "address1": address1,
    "address2": address2,
    "booking": booking?.toJson(),
    "customer": customer?.toJson(),
  };
}

class Booking {
  String? referenceNumber;
  String? pickupDate;
  String? pickupTime;
  String? pickup;
  String? dropoff;
  VehicleType? vehicleType;

  Booking({
    this.referenceNumber,
    this.pickupDate,
    this.pickupTime,
    this.pickup,
    this.dropoff,
    this.vehicleType,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    referenceNumber: json["reference_number"],
    pickupDate: json["pickup_date"],
    pickupTime: json["pickup_time"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "reference_number": referenceNumber,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "pickup": pickup,
    "dropoff": dropoff,
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

class CustomerById {
  String? name;
  String? mobile;
  dynamic doorNumber;
  dynamic address1;
  dynamic address2;

  CustomerById({
    this.name,
    this.mobile,
    this.doorNumber,
    this.address1,
    this.address2,
  });

  factory CustomerById.fromJson(Map<String, dynamic> json) => CustomerById(
    name: json["name"],
    mobile: json["mobile"],
    doorNumber: json["door_number"],
    address1: json["address1"],
    address2: json["address2"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mobile": mobile,
    "door_number": doorNumber,
    "address1": address1,
    "address2": address2,
  };
}
