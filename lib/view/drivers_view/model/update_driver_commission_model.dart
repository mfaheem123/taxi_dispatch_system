// To parse this JSON data, do
//
//     final updateDriverCommissionByIdModel = updateDriverCommissionByIdModelFromJson(jsonString);

import 'dart:convert';

UpdateDriverCommissionByIdModel updateDriverCommissionByIdModelFromJson(String str) => UpdateDriverCommissionByIdModel.fromJson(json.decode(str));

String updateDriverCommissionByIdModelToJson(UpdateDriverCommissionByIdModel data) => json.encode(data.toJson());

class UpdateDriverCommissionByIdModel {
  bool? status;
  UpdateDriverCommission? driverCommission;

  UpdateDriverCommissionByIdModel({
    this.status,
    this.driverCommission,
  });

  factory UpdateDriverCommissionByIdModel.fromJson(Map<String, dynamic> json) => UpdateDriverCommissionByIdModel(
    status: json["status"],
    driverCommission: json["driver_commission"] == null ? null : UpdateDriverCommission.fromJson(json["driver_commission"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "driver_commission": driverCommission?.toJson(),
  };
}

class UpdateDriverCommission {
  int? id;
  String? transactionNumber;
  DateTime? transactionDate;
  int? driverId;
  String? jobsTotal;
  String? commissionTotal;
  String? cashJobsTotal;
  String? accountJobsTotal;
  String? owed;
  String? oldBalance;
  String? currentBalance;
  DateTime? fromDate;
  DateTime? toDate;
  dynamic paymentType;
  DateTime? lastModified;
  CommissionDriver? driver;
  List<DriverCommissionLineitem>? driverCommissionLineitems;

  UpdateDriverCommission({
    this.id,
    this.transactionNumber,
    this.transactionDate,
    this.driverId,
    this.jobsTotal,
    this.commissionTotal,
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
    this.driverCommissionLineitems,
  });

  factory UpdateDriverCommission.fromJson(Map<String, dynamic> json) => UpdateDriverCommission(
    id: json["id"],
    transactionNumber: json["transaction_number"],
    transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
    driverId: json["driver_id"],
    jobsTotal: json["jobs_total"],
    commissionTotal: json["commission_total"],
    cashJobsTotal: json["cash_jobs_total"],
    accountJobsTotal: json["account_jobs_total"],
    owed: json["owed"],
    oldBalance: json["old_balance"],
    currentBalance: json["current_balance"],
    fromDate: json["from_date"] == null ? null : DateTime.parse(json["from_date"]),
    toDate: json["to_date"] == null ? null : DateTime.parse(json["to_date"]),
    paymentType: json["payment_type"],
    lastModified: json["last_modified"] == null ? null : DateTime.parse(json["last_modified"]),
    driver: json["driver"] == null ? null : CommissionDriver.fromJson(json["driver"]),
    driverCommissionLineitems: json["driver_commission_lineitems"] == null ? [] : List<DriverCommissionLineitem>.from(json["driver_commission_lineitems"]!.map((x) => DriverCommissionLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "transaction_number": transactionNumber,
    "transaction_date": "${transactionDate!.year.toString().padLeft(4, '0')}-${transactionDate!.month.toString().padLeft(2, '0')}-${transactionDate!.day.toString().padLeft(2, '0')}",
    "driver_id": driverId,
    "jobs_total": jobsTotal,
    "commission_total": commissionTotal,
    "cash_jobs_total": cashJobsTotal,
    "account_jobs_total": accountJobsTotal,
    "owed": owed,
    "old_balance": oldBalance,
    "current_balance": currentBalance,
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "payment_type": paymentType,
    "last_modified": "${lastModified!.year.toString().padLeft(4, '0')}-${lastModified!.month.toString().padLeft(2, '0')}-${lastModified!.day.toString().padLeft(2, '0')}",
    "driver": driver?.toJson(),
    "driver_commission_lineitems": driverCommissionLineitems == null ? [] : List<dynamic>.from(driverCommissionLineitems!.map((x) => x.toJson())),
  };
}

class CommissionDriver {
  int? id;
  String? name;
  String? username;
  String? email;
  int? driverCommission;
  int? pdaRent;
  int? balance;
  int? subsidiaryId;

  CommissionDriver({
    this.id,
    this.name,
    this.username,
    this.email,
    this.driverCommission,
    this.pdaRent,
    this.balance,
    this.subsidiaryId,
  });

  factory CommissionDriver.fromJson(Map<String, dynamic> json) => CommissionDriver(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    email: json["email"],
    driverCommission: json["driver_commission"],
    pdaRent: json["pda_rent"],
    balance: json["balance"],
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

class DriverCommissionLineitem {
  int? id;
  int? driverCommissionId;
  int? bookingId;
  CommissionBooking? booking;

  DriverCommissionLineitem({
    this.id,
    this.driverCommissionId,
    this.bookingId,
    this.booking,
  });

  factory DriverCommissionLineitem.fromJson(Map<String, dynamic> json) => DriverCommissionLineitem(
    id: json["id"],
    driverCommissionId: json["driver_commission_id"],
    bookingId: json["booking_id"],
    booking: json["booking"] == null ? null : CommissionBooking.fromJson(json["booking"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_commission_id": driverCommissionId,
    "booking_id": bookingId,
    "booking": booking?.toJson(),
  };
}

class CommissionBooking {
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

  CommissionBooking({
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

  factory CommissionBooking.fromJson(Map<String, dynamic> json) => CommissionBooking(
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
