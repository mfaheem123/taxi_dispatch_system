// To parse this JSON data, do
//
//     final customerInvoiceByIdModel = customerInvoiceByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

CustomerInvoiceByIdModel customerInvoiceByIdModelFromJson(String str) => CustomerInvoiceByIdModel.fromJson(json.decode(str));

String customerInvoiceByIdModelToJson(CustomerInvoiceByIdModel data) => json.encode(data.toJson());

class CustomerInvoiceByIdModel {
  bool? status;
  UpdateCustomerInvoice? customerInvoice;

  CustomerInvoiceByIdModel({
    this.status,
    this.customerInvoice,
  });

  factory CustomerInvoiceByIdModel.fromJson(Map<String, dynamic> json) => CustomerInvoiceByIdModel(
    status: json["status"],
    customerInvoice: json["customer_invoice"] == null ? null : UpdateCustomerInvoice.fromJson(json["customer_invoice"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "customer_invoice": customerInvoice?.toJson(),
  };
}

class UpdateCustomerInvoice {
  int? id;
  String? invoiceNumber;
  int? customerId;
  DateTime? invoiceDate;
  DateTime? invoiceDueDate;
  DateTime? fromDate;
  DateTime? toDate;
  String? invoiceType;
  dynamic amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  List<CustomerInvoiceLineitem>? customerInvoiceLineitems;

  UpdateCustomerInvoice({
    this.id,
    this.invoiceNumber,
    this.customerId,
    this.invoiceDate,
    this.invoiceDueDate,
    this.fromDate,
    this.toDate,
    this.invoiceType,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.customerInvoiceLineitems,
  });

  factory UpdateCustomerInvoice.fromJson(Map<String, dynamic> json) => UpdateCustomerInvoice(
    id: json["id"],
    invoiceNumber: json["invoice_number"],
    customerId: json["customer_id"],
    invoiceDate: json["invoice_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["invoice_date"].toString())
        : null,
    invoiceDueDate: json["invoice_due_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["invoice_due_date"].toString())
        : null,
    fromDate: json["from_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["from_date"].toString())
        : null,
    toDate: json["to_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["to_date"].toString())
        : null,
    invoiceType: json["invoice_type"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    customerInvoiceLineitems: json["customer_invoice_lineitems"] == null ? [] : List<CustomerInvoiceLineitem>.from(json["customer_invoice_lineitems"]!.map((x) => CustomerInvoiceLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_number": invoiceNumber,
    "customer_id": customerId,
    "invoice_date": invoiceDate,
    "invoice_due_date": invoiceDueDate,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "invoice_type": invoiceType,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "customer": customer?.toJson(),
    "customer_invoice_lineitems": customerInvoiceLineitems == null ? [] : List<dynamic>.from(customerInvoiceLineitems!.map((x) => x.toJson())),
  };
}

class Customer {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? telephone;

  Customer({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.telephone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    telephone: json["telephone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "telephone": telephone,
  };
}

class CustomerInvoiceLineitem {
  int? id;
  int? customerInvoiceId;
  int? bookingId;
  String? createdAt;
  Booking? booking;

  CustomerInvoiceLineitem({
    this.id,
    this.customerInvoiceId,
    this.bookingId,
    this.createdAt,
    this.booking,
  });

  factory CustomerInvoiceLineitem.fromJson(Map<String, dynamic> json) => CustomerInvoiceLineitem(
    id: json["id"],
    customerInvoiceId: json["customer_invoice_id"],
    bookingId: json["booking_id"],
    createdAt: json["created_at"],
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_invoice_id": customerInvoiceId,
    "booking_id": bookingId,
    "created_at": createdAt,
    "booking": booking?.toJson(),
  };
}

class Booking {
  String? id;
  String? referenceNumber;
  String? pickupDate;
  String? pickupTime;
  String? pickup;
  String? dropoff;
  String? viapoints;
  String? name;
  String? fares;
  String? parkingCharges;
  String? waitingCharges;
  String? extraDropCharges;
  String? meetAndGreet;
  String? congestionCharges;
  String? totalCharges;
  Type? vehicleType;
  JourneyType? journeyType;
  Type? paymentType;

  Booking({
    this.id,
    this.referenceNumber,
    this.pickupDate,
    this.pickupTime,
    this.pickup,
    this.dropoff,
    this.viapoints,
    this.name,
    this.fares,
    this.parkingCharges,
    this.waitingCharges,
    this.extraDropCharges,
    this.meetAndGreet,
    this.congestionCharges,
    this.totalCharges,
    this.vehicleType,
    this.journeyType,
    this.paymentType,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    referenceNumber: json["reference_number"],
    pickupDate: json["pickup_date"],
    pickupTime: json["pickup_time"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    viapoints: json["viapoints"],
    name: json["name"],
    fares: json["fares"],
    parkingCharges: json["parking_charges"],
    waitingCharges: json["waiting_charges"],
    extraDropCharges: json["extra_drop_charges"],
    meetAndGreet: json["meet_and_greet"],
    congestionCharges: json["congestion_charges"],
    totalCharges: json["total_charges"],
    vehicleType: json["vehicle_type"] == null ? null : Type.fromJson(json["vehicle_type"]),
    journeyType: json["journey_type"] == null ? null : JourneyType.fromJson(json["journey_type"]),
    paymentType: json["payment_type"] == null ? null : Type.fromJson(json["payment_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_number": referenceNumber,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "pickup": pickup,
    "dropoff": dropoff,
    "viapoints": viapoints,
    "name": name,
    "fares": fares,
    "parking_charges": parkingCharges,
    "waiting_charges": waitingCharges,
    "extra_drop_charges": extraDropCharges,
    "meet_and_greet": meetAndGreet,
    "congestion_charges": congestionCharges,
    "total_charges": totalCharges,
    "vehicle_type": vehicleType?.toJson(),
    "journey_type": journeyType?.toJson(),
    "payment_type": paymentType?.toJson(),
  };
}

class JourneyType {
  String? journeyType;

  JourneyType({
    this.journeyType,
  });

  factory JourneyType.fromJson(Map<String, dynamic> json) => JourneyType(
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "journey_type": journeyType,
  };
}

class Type {
  String? name;

  Type({
    this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}