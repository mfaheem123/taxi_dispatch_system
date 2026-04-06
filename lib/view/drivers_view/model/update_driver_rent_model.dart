// To parse this JSON data, do
//
//     final driverRentByIdModel = driverRentByIdModelFromJson(jsonString);

import 'dart:convert';

DriverRentByIdModel driverRentByIdModelFromJson(String str) => DriverRentByIdModel.fromJson(json.decode(str));

String driverRentByIdModelToJson(DriverRentByIdModel data) => json.encode(data.toJson());

class DriverRentByIdModel {
  bool? status;
  DriverRent? driverRent;

  DriverRentByIdModel({
    this.status,
    this.driverRent,
  });

  factory DriverRentByIdModel.fromJson(Map<String, dynamic> json) => DriverRentByIdModel(
    status: json["status"],
    driverRent: json["driver_rent"] == null ? null : DriverRent.fromJson(json["driver_rent"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "driver_rent": driverRent?.toJson(),
  };
}

class DriverRent {
  int? id;
  String? transactionNumber;
  String? transactionDate;
  int? driverId;
  String? jobsTotal;
  String? rentTotal;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? owed;
  String? oldBalance;
  String? currentBalance;
  DateTime? fromDate;
  DateTime? toDate;
  dynamic paymentType;
  String? lastModified;
  DriverUpdate? driver;
  List<DriverRentLineitem>? driverRentLineitems;

  DriverRent({
    this.id,
    this.transactionNumber,
    this.transactionDate,
    this.driverId,
    this.jobsTotal,
    this.rentTotal,
    this.cashJobsTotal,
    this.accountJobsTotal,
    this.owed,
    this.oldBalance,
    this.currentBalance,
    this.fromDate,
    this.toDate,
    this.paymentType,
    this.lastModified,
    this.driver,
    this.driverRentLineitems,
  });

  factory DriverRent.fromJson(Map<String, dynamic> json) => DriverRent(
    id: json["id"],
    transactionNumber: json["transaction_number"],
    transactionDate: json["transaction_date"],
    driverId: json["driver_id"],
    jobsTotal: json["jobs_total"],
    rentTotal: json["rent_total"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    owed: json["owed"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    paymentType: json["payment_type"],
    lastModified: json["last_modified"],
    driver: json["driver"] == null ? null : DriverUpdate.fromJson(json["driver"]),
    driverRentLineitems: json["driver_rent_lineitems"] == null ? [] : List<DriverRentLineitem>.from(json["driver_rent_lineitems"]!.map((x) => DriverRentLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_number": transactionNumber,
    "transaction_date": transactionDate,
    "driver_id": driverId,
    "jobs_total": jobsTotal,
    "rent_total": rentTotal,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "owed": owed,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "payment_type": paymentType,
    "last_modified": lastModified,
    "driver": driver?.toJson(),
    "driver_rent_lineitems": driverRentLineitems == null ? [] : List<dynamic>.from(driverRentLineitems!.map((x) => x.toJson())),
  };
}

class DriverUpdate {
  int? id;
  String? name;
  String? username;
  String? email;
  int? driverCommission;
  int? pdaRent;
  double? balance;
  int? subsidiaryId;

  DriverUpdate({
    this.id,
    this.name,
    this.username,
    this.email,
    this.driverCommission,
    this.pdaRent,
    this.balance,
    this.subsidiaryId,
  });

  factory DriverUpdate.fromJson(Map<String, dynamic> json) => DriverUpdate(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    driverCommission: json["driver_commission"],
    pdaRent: json["pda_rent"],
    balance: json["balance"]?.toDouble(),
    subsidiaryId: json["subsidiary_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "email": email,
    "driver_commission": driverCommission,
    "pda_rent": pdaRent,
    "balance": balance,
    "subsidiary_id": subsidiaryId,
  };
}

class DriverRentLineitem {
  int? id;
  int? driverRentId;
  int? bookingId;
  BookingRent? booking;

  DriverRentLineitem({
    this.id,
    this.driverRentId,
    this.bookingId,
    this.booking,
  });

  factory DriverRentLineitem.fromJson(Map<String, dynamic> json) => DriverRentLineitem(
    id: json["id"],
    driverRentId: json["driver_rent_id"],
    bookingId: json["booking_id"],
    booking: json["booking"] == null ? null : BookingRent.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_rent_id": driverRentId,
    "booking_id": bookingId,
    "booking": booking?.toJson(),
  };
}

class BookingRent {
  int? id;
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
  String? congestionCharges;
  String? totalCharges;
  bool? commission;
  JourneyType? journeyType;
  Account? paymentType;
  Account? vehicleType;
  Account? account;

  BookingRent({
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
    this.congestionCharges,
    this.totalCharges,
    this.commission,
    this.journeyType,
    this.paymentType,
    this.vehicleType,
    this.account,
  });

  factory BookingRent.fromJson(Map<String, dynamic> json) => BookingRent(
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
    congestionCharges: json["congestion_charges"],
    totalCharges: json["total_charges"],
    commission: json["commission"],
    journeyType: json["journey_type"] == null ? null : JourneyType.fromJson(json["journey_type"]),
    paymentType: json["payment_type"] == null ? null : Account.fromJson(json["payment_type"]),
    vehicleType: json["vehicle_type"] == null ? null : Account.fromJson(json["vehicle_type"]),
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
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
    "congestion_charges": congestionCharges,
    "total_charges": totalCharges,
    "commission": commission,
    "journey_type": journeyType?.toJson(),
    "payment_type": paymentType?.toJson(),
    "vehicle_type": vehicleType?.toJson(),
    "account": account?.toJson(),
  };
}

class Account {
  String? name;

  Account({
    this.name,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
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
