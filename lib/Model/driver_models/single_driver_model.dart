

// To parse this JSON data, do
//
//     final SingleDriverModel = SingleDriverModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

SingleDriverModel singleDriverModelFromJson(String str) => SingleDriverModel.fromJson(json.decode(str));

String singleDriverModelToJson(SingleDriverModel data) => json.encode(data.toJson());

class SingleDriverModel {
  bool? status;
  Driver? driver;

  SingleDriverModel({
    this.status,
    this.driver,
  });

  factory SingleDriverModel.fromJson(Map<String, dynamic> json) => SingleDriverModel(
    status: json["status"],
    driver: Driver.fromJson(json["driver"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "driver": driver!.toJson(),
  };
}

class Driver {
  int? id;
  int? subsidiaryId;
  String? username;
  String? password;
  String? name;
  String? email;
  String? mobile;
  String? telephone;
  String? address;
  String? dob;
  String? driverType;
  String? driverCommission;
  String? rentLimit;
  bool? rentPaid;
  String? balance;
  bool? hasPda;
  bool? useCompanyVehicle;
  bool? active;
  String? startDate;
  String? endDate;
  String? licenceNumber;
  String? licenceExpiry;
  String? phcDriverNumber;
  String? phcDriverExpiry;
  String? insuranceNumber;
  String? insuranceExpiry;
  String? rentalAgreementNumber;
  String? rentalAgreementExpiry;
  String? roadTaxNumber;
  String? roadTaxExpiry;
  String? v5RegistrationNumber;
  String? v5RegistrationExpiry;
  String? motNumber;
  String? motExpiry;
  String? mot2Number;
  String? mot2Expiry;
  String? phcVehicleNumber;
  String? phcVehicleExpiry;
  String? ni;
  String? image;
  DateTime? createdAt;
  int? vehicleId;
  dynamic driverStatus;
  dynamic sessionStatus;
  dynamic bookingStatus;
  dynamic latitude;
  dynamic longitude;
  dynamic webDeviceId;
  dynamic mobileDeviceId;
  dynamic lastBooking;
  dynamic lastVehicle;
  List<Note>? notes;
  dynamic zone;
  dynamic rank;
  dynamic waitingTime;
  dynamic zoneUpdatedAt;
  dynamic os;
  dynamic version;
  String? sinBinTimer;
  dynamic position;
  dynamic pdaRent;
  dynamic companyVehicleId;
  String? licenceExpiryTime;
  String? phcDriverExpiryTime;
  String? insuranceExpiryTime;
  String? phcVehicleExpiryTime;
  String? motExpiryTime;
  String? mot2ExpiryTime;
  String? v5RegistrationExpiryTime;
  String? roadTaxExpiryTime;
  String? rentalAgreementExpiryTime;
  String? subsidiaryName;
  List<Shift>? shifts;
  Vehicle? vehicle;

  Driver({
    this.id,
    this.subsidiaryId,
    this.username,
    this.password,
    this.name,
    this.email,
    this.mobile,
    this.telephone,
    this.address,
    this.dob,
    this.driverType,
    this.driverCommission,
    this.rentLimit,
    this.rentPaid,
    this.balance,
    this.hasPda,
    this.useCompanyVehicle,
    this.active,
    this.startDate,
    this.endDate,
    this.licenceNumber,
    this.licenceExpiry,
    this.phcDriverNumber,
    this.phcDriverExpiry,
    this.insuranceNumber,
    this.insuranceExpiry,
    this.rentalAgreementNumber,
    this.rentalAgreementExpiry,
    this.roadTaxNumber,
    this.roadTaxExpiry,
    this.v5RegistrationNumber,
    this.v5RegistrationExpiry,
    this.motNumber,
    this.motExpiry,
    this.mot2Number,
    this.mot2Expiry,
    this.phcVehicleNumber,
    this.phcVehicleExpiry,
    this.ni,
    this.image,
    this.createdAt,
    this.vehicleId,
    this.driverStatus,
    this.sessionStatus,
    this.bookingStatus,
    this.latitude,
    this.longitude,
    this.webDeviceId,
    this.mobileDeviceId,
    this.lastBooking,
    this.lastVehicle,
    this.notes,
    this.zone,
    this.rank,
    this.waitingTime,
    this.zoneUpdatedAt,
    this.os,
    this.version,
    this.sinBinTimer,
    this.position,
    this.pdaRent,
    this.companyVehicleId,
    this.licenceExpiryTime,
    this.phcDriverExpiryTime,
    this.insuranceExpiryTime,
    this.phcVehicleExpiryTime,
    this.motExpiryTime,
    this.mot2ExpiryTime,
    this.v5RegistrationExpiryTime,
    this.roadTaxExpiryTime,
    this.rentalAgreementExpiryTime,
    this.subsidiaryName,
    this.shifts,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    username: json["username"],
    password: json["password"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    address: json["address"],
    dob: json["dob"],
    driverType: json["driver_type"],
    driverCommission: json["driver_commission"],
    rentLimit: json["rent_limit"],
    rentPaid: json["rent_paid"],
    balance: json["balance"],
    hasPda: json["has_pda"],
    useCompanyVehicle: json["use_company_vehicle"],
    active: json["active"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    licenceNumber: json["licence_number"],
    licenceExpiry: json["licence_expiry"],
    phcDriverNumber: json["phc_driver_number"],
    phcDriverExpiry: json["phc_driver_expiry"],
    insuranceNumber: json["insurance_number"],
    insuranceExpiry: json["insurance_expiry"],
    rentalAgreementNumber: json["rental_agreement_number"],
    rentalAgreementExpiry: json["rental_agreement_expiry"],
    roadTaxNumber: json["road_tax_number"],
    roadTaxExpiry: json["road_tax_expiry"],
    v5RegistrationNumber: json["v5_registration_number"],
    v5RegistrationExpiry: json["v5_registration_expiry"],
    motNumber: json["mot_number"],
    motExpiry: json["mot_expiry"],
    mot2Number: json["mot2_number"],
    mot2Expiry: json["mot2_expiry"],
    phcVehicleNumber: json["phc_vehicle_number"],
    phcVehicleExpiry: json["phc_vehicle_expiry"],
    ni: json["ni"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    vehicleId: json["vehicle_id"],
    driverStatus: json["driver_status"],
    sessionStatus: json["session_status"],
    bookingStatus: json["booking_status"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    webDeviceId: json["web_device_id"],
    mobileDeviceId: json["mobile_device_id"],
    lastBooking: json["last_booking"],
    lastVehicle: json["last_vehicle"],
    notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
    zone: json["zone"],
    rank: json["rank"],
    waitingTime: json["waiting_time"],
    zoneUpdatedAt: json["zone_updated_at"],
    os: json["os"],
    version: json["version"],
    sinBinTimer: json["sin_bin_timer"],
    position: json["position"],
    pdaRent: json["pda_rent"],
    companyVehicleId: json["company_vehicle_id"],
    licenceExpiryTime: json["licence_expiry_time"],
    phcDriverExpiryTime: json["phc_driver_expiry_time"],
    insuranceExpiryTime: json["insurance_expiry_time"],
    phcVehicleExpiryTime: json["phc_vehicle_expiry_time"],
    motExpiryTime: json["mot_expiry_time"],
    mot2ExpiryTime: json["mot2_expiry_time"],
    v5RegistrationExpiryTime: json["v5_registration_expiry_time"],
    roadTaxExpiryTime: json["road_tax_expiry_time"],
    rentalAgreementExpiryTime: json["rental_agreement_expiry_time"],
    subsidiaryName: json["subsidiary_name"],
    shifts: (json["shifts"] == null || json["shifts"].isEmpty)
        ? []
        : List<Shift>.from(json["shifts"].map((x) => Shift.fromJson(x))),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "username": username,
    "password": password,
    "name": name,
    "email": email,
    "mobile": mobile,
    "telephone": telephone,
    "address": address,
    "dob": dob,
    "driver_type": driverType,
    "driver_commission": driverCommission,
    "rent_limit": rentLimit,
    "rent_paid": rentPaid,
    "balance": balance,
    "has_pda": hasPda,
    "use_company_vehicle": useCompanyVehicle,
    "active": active,
    "start_date": startDate,
    "end_date": endDate,
    "licence_number": licenceNumber,
    "licence_expiry": licenceExpiry,
    "phc_driver_number": phcDriverNumber,
    "phc_driver_expiry": phcDriverExpiry,
    "insurance_number": insuranceNumber,
    "insurance_expiry": insuranceExpiry,
    "rental_agreement_number": rentalAgreementNumber,
    "rental_agreement_expiry": rentalAgreementExpiry,
    "road_tax_number": roadTaxNumber,
    "road_tax_expiry": roadTaxExpiry,
    "v5_registration_number": v5RegistrationNumber,
    "v5_registration_expiry": v5RegistrationExpiry,
    "mot_number": motNumber,
    "mot_expiry": motExpiry,
    "mot2_number": mot2Number,
    "mot2_expiry": mot2Expiry,
    "phc_vehicle_number": phcVehicleNumber,
    "phc_vehicle_expiry": phcVehicleExpiry,
    "ni": ni,
    "image": image,
    "created_at": createdAt!.toIso8601String(),
    "vehicle_id": vehicleId,
    "driver_status": driverStatus,
    "session_status": sessionStatus,
    "booking_status": bookingStatus,
    "latitude": latitude,
    "longitude": longitude,
    "web_device_id": webDeviceId,
    "mobile_device_id": mobileDeviceId,
    "last_booking": lastBooking,
    "last_vehicle": lastVehicle,
    "notes": List<dynamic>.from(notes!.map((x) => x.toJson())),
    "zone": zone,
    "rank": rank,
    "waiting_time": waitingTime,
    "zone_updated_at": zoneUpdatedAt,
    "os": os,
    "version": version,
    "sin_bin_timer": sinBinTimer,
    "position": position,
    "pda_rent": pdaRent,
    "company_vehicle_id": companyVehicleId,
    "licence_expiry_time": licenceExpiryTime,
    "phc_driver_expiry_time": phcDriverExpiryTime,
    "insurance_expiry_time": insuranceExpiryTime,
    "phc_vehicle_expiry_time": phcVehicleExpiryTime,
    "mot_expiry_time": motExpiryTime,
    "mot2_expiry_time": mot2ExpiryTime,
    "v5_registration_expiry_time": v5RegistrationExpiryTime,
    "road_tax_expiry_time": roadTaxExpiryTime,
    "rental_agreement_expiry_time": rentalAgreementExpiryTime,
    "subsidiary_name": subsidiaryName,
    "shifts": List<dynamic>.from(shifts!.map((x) => x.toJson())),
    "vehicle": vehicle!.toJson(),
  };
}

class Note {
  int? id;
  String? note;
  DateTime? createdAt;
  String? createdBy;

  Note({
    this.id,
    this.note,
    this.createdAt,
    this.createdBy,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"],
    note: json["note"],
    createdAt: DateFormat("dd-MM-yyyy").parse(json["created_at"]),
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "note": note,
    "created_at": createdAt!.toIso8601String(),
    "created_by": createdBy,
  };
}

class Shift {
  int? id;
  String? name;
  String? startTime;
  String? endTime;

  Shift({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
    id: json["id"],
    name: json["name"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_time": startTime,
    "end_time": endTime,
  };
}

class Vehicle {
  int? id;
  int? vehicleTypeId;
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  String? owner;
  String? startDate;
  String? endDate;
  bool? company;
  bool? assigned;
  LogBook? logBook;
  Mot? mot;
  Mot2? mot2;
  Insurance? insurance;
  PhcVehicle? phcVehicle;
  RoadTax? roadTax;
  RentalAgreement? rentalAgreement;
  V5Registration? v5Registration;
  Licence? licence;
  PhcDriver? phcDriver;
  VehicleType? vehicleType;

  Vehicle({
    this.id,
    this.vehicleTypeId,
    this.vehicleNumber,
    this.make,
    this.model,
    this.color,
    this.owner,
    this.startDate,
    this.endDate,
    this.company,
    this.assigned,
    this.logBook,
    this.mot,
    this.mot2,
    this.insurance,
    this.phcVehicle,
    this.roadTax,
    this.rentalAgreement,
    this.v5Registration,
    this.licence,
    this.phcDriver,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleNumber: json["vehicle_number"],
    make: json["make"],
    model: json["model"],
    color: json["color"],
    owner: json["owner"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    company: json["company"],
    assigned: json["assigned"],
    logBook: LogBook.fromJson(json["log_book"]),
    mot: Mot.fromJson(json["mot"]),
    mot2: Mot2.fromJson(json["mot2"]),
    insurance: Insurance.fromJson(json["insurance"]),
    phcVehicle: PhcVehicle.fromJson(json["phc_vehicle"]),
    roadTax: RoadTax.fromJson(json["road_tax"]),
    rentalAgreement: RentalAgreement.fromJson(json["rental_agreement"]),
    v5Registration: V5Registration.fromJson(json["v5_registration"]),
    licence: Licence.fromJson(json["licence"]),
    phcDriver: PhcDriver.fromJson(json["phc_driver"]),
    vehicleType: VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_number": vehicleNumber,
    "make": make,
    "model": model,
    "color": color,
    "owner": owner,
    "start_date": startDate,
    "end_date": endDate,
    "company": company,
    "assigned": assigned,
    "log_book": logBook!.toJson(),
    "mot": mot!.toJson(),
    "mot2": mot2!.toJson(),
    "insurance": insurance!.toJson(),
    "phc_vehicle": phcVehicle!.toJson(),
    "road_tax": roadTax!.toJson(),
    "rental_agreement": rentalAgreement!.toJson(),
    "v5_registration": v5Registration!.toJson(),
    "licence": licence!.toJson(),
    "phc_driver": phcDriver!.toJson(),
    "vehicle_type": vehicleType!.toJson(),
  };
}

class Insurance {
  String? insuranceNumber;
  String? insuranceExpiry;
  String? insuranceExpiryTime;
  String? insuranceDocument;

  Insurance({
    this.insuranceNumber,
    this.insuranceExpiry,
    this.insuranceExpiryTime,
    this.insuranceDocument,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
    insuranceNumber: json["insurance_number"],
    insuranceExpiry: json["insurance_expiry"],
    insuranceExpiryTime: json["insurance_expiry_time"],
    insuranceDocument: json["insurance_document"],
  );

  Map<String, dynamic> toJson() => {
    "insurance_number": insuranceNumber,
    "insurance_expiry": insuranceExpiry,
    "insurance_expiry_time": insuranceExpiryTime,
    "insurance_document": insuranceDocument,
  };
}

class Licence {
  String? licenceNumber;
  String? licenceExpiry;
  String? licenceExpiryTime;
  String? licenceDocument;

  Licence({
    this.licenceNumber,
    this.licenceExpiry,
    this.licenceExpiryTime,
    this.licenceDocument,
  });

  factory Licence.fromJson(Map<String, dynamic> json) => Licence(
    licenceNumber: json["licence_number"],
    licenceExpiry: json["licence_expiry"],
    licenceExpiryTime: json["licence_expiry_time"],
    licenceDocument: json["licence_document"],
  );

  Map<String, dynamic> toJson() => {
    "licence_number": licenceNumber,
    "licence_expiry": licenceExpiry,
    "licence_expiry_time": licenceExpiryTime,
    "licence_document": licenceDocument,
  };
}

class LogBook {
  String? logBookNumber;
  String? logBookDocument;

  LogBook({
    this.logBookNumber,
    this.logBookDocument,
  });

  factory LogBook.fromJson(Map<String, dynamic> json) => LogBook(
    logBookNumber: json["log_book_number"],
    logBookDocument: json["log_book_document"],
  );

  Map<String, dynamic> toJson() => {
    "log_book_number": logBookNumber,
    "log_book_document": logBookDocument,
  };
}

class Mot {
  String? motNumber;
  String? motExpiry;
  String? motExpiryTime;
  String? motDocument;

  Mot({
    this.motNumber,
    this.motExpiry,
    this.motExpiryTime,
    this.motDocument,
  });

  factory Mot.fromJson(Map<String, dynamic> json) => Mot(
    motNumber: json["mot_number"],
    motExpiry: json["mot_expiry"],
    motExpiryTime: json["mot_expiry_time"],
    motDocument: json["mot_document"],
  );

  Map<String, dynamic> toJson() => {
    "mot_number": motNumber,
    "mot_expiry": motExpiry,
    "mot_expiry_time": motExpiryTime,
    "mot_document": motDocument,
  };
}

class Mot2 {
  String? mot2Number;
  String? mot2Expiry;
  String? mot2ExpiryTime;
  String? mot2Document;

  Mot2({
    this.mot2Number,
    this.mot2Expiry,
    this.mot2ExpiryTime,
    this.mot2Document,
  });

  factory Mot2.fromJson(Map<String, dynamic> json) => Mot2(
    mot2Number: json["mot2_number"],
    mot2Expiry: json["mot2_expiry"],
    mot2ExpiryTime: json["mot2_expiry_time"],
    mot2Document: json["mot2_document"],
  );

  Map<String, dynamic> toJson() => {
    "mot2_number": mot2Number,
    "mot2_expiry": mot2Expiry,
    "mot2_expiry_time": mot2ExpiryTime,
    "mot2_document": mot2Document,
  };
}

class PhcDriver {
  String? phcDriverNumber;
  String? phcDriverExpiry;
  String? phcDriverExpiryTime;
  String? phcDriverDocument;

  PhcDriver({
    this.phcDriverNumber,
    this.phcDriverExpiry,
    this.phcDriverExpiryTime,
    this.phcDriverDocument,
  });

  factory PhcDriver.fromJson(Map<String, dynamic> json) => PhcDriver(
    phcDriverNumber: json["phc_driver_number"],
    phcDriverExpiry: json["phc_driver_expiry"],
    phcDriverExpiryTime: json["phc_driver_expiry_time"],
    phcDriverDocument: json["phc_driver_document"],
  );

  Map<String, dynamic> toJson() => {
    "phc_driver_number": phcDriverNumber,
    "phc_driver_expiry": phcDriverExpiry,
    "phc_driver_expiry_time": phcDriverExpiryTime,
    "phc_driver_document": phcDriverDocument,
  };
}

class PhcVehicle {
  String? phcVehicleNumber;
  String? phcVehicleExpiry;
  String? phcVehicleExpiryTime;
  String? phcVehicleDocument;

  PhcVehicle({
    this.phcVehicleNumber,
    this.phcVehicleExpiry,
    this.phcVehicleExpiryTime,
    this.phcVehicleDocument,
  });

  factory PhcVehicle.fromJson(Map<String, dynamic> json) => PhcVehicle(
    phcVehicleNumber: json["phc_vehicle_number"],
    phcVehicleExpiry: json["phc_vehicle_expiry"],
    phcVehicleExpiryTime: json["phc_vehicle_expiry_time"],
    phcVehicleDocument: json["phc_vehicle_document"],
  );

  Map<String, dynamic> toJson() => {
    "phc_vehicle_number": phcVehicleNumber,
    "phc_vehicle_expiry": phcVehicleExpiry,
    "phc_vehicle_expiry_time": phcVehicleExpiryTime,
    "phc_vehicle_document": phcVehicleDocument,
  };
}

class RentalAgreement {
  String? rentalAgreementNumber;
  String? rentalAgreementExpiry;
  String? rentalAgreementExpiryTime;
  String? rentalAgreementDocument;

  RentalAgreement({
    this.rentalAgreementNumber,
    this.rentalAgreementExpiry,
    this.rentalAgreementExpiryTime,
    this.rentalAgreementDocument,
  });

  factory RentalAgreement.fromJson(Map<String, dynamic> json) => RentalAgreement(
    rentalAgreementNumber: json["rental_agreement_number"],
    rentalAgreementExpiry: json["rental_agreement_expiry"],
    rentalAgreementExpiryTime: json["rental_agreement_expiry_time"],
    rentalAgreementDocument: json["rental_agreement_document"],
  );

  Map<String, dynamic> toJson() => {
    "rental_agreement_number": rentalAgreementNumber,
    "rental_agreement_expiry": rentalAgreementExpiry,
    "rental_agreement_expiry_time": rentalAgreementExpiryTime,
    "rental_agreement_document": rentalAgreementDocument,
  };
}

class RoadTax {
  String? roadTaxNumber;
  String? roadTaxExpiry;
  String? roadTaxExpiryTime;
  String? roadTaxDocument;

  RoadTax({
    this.roadTaxNumber,
    this.roadTaxExpiry,
    this.roadTaxExpiryTime,
    this.roadTaxDocument,
  });

  factory RoadTax.fromJson(Map<String, dynamic> json) => RoadTax(
    roadTaxNumber: json["road_tax_number"],
    roadTaxExpiry: json["road_tax_expiry"],
    roadTaxExpiryTime: json["road_tax_expiry_time"],
    roadTaxDocument: json["road_tax_document"],
  );

  Map<String, dynamic> toJson() => {
    "road_tax_number": roadTaxNumber,
    "road_tax_expiry": roadTaxExpiry,
    "road_tax_expiry_time": roadTaxExpiryTime,
    "road_tax_document": roadTaxDocument,
  };
}

class V5Registration {
  String? v5RegistrationNumber;
  String? v5RegistrationExpiry;
  String? v5RegistrationExpiryTime;
  String? v5RegistrationDocument;

  V5Registration({
    this.v5RegistrationNumber,
    this.v5RegistrationExpiry,
    this.v5RegistrationExpiryTime,
    this.v5RegistrationDocument,
  });

  factory V5Registration.fromJson(Map<String, dynamic> json) => V5Registration(
    v5RegistrationNumber: json["v5_registration_number"],
    v5RegistrationExpiry: json["v5_registration_expiry"],
    v5RegistrationExpiryTime: json["v5_registration_expiry_time"],
    v5RegistrationDocument: json["v5_registration_document"],
  );

  Map<String, dynamic> toJson() => {
    "v5_registration_number": v5RegistrationNumber,
    "v5_registration_expiry": v5RegistrationExpiry,
    "v5_registration_expiry_time": v5RegistrationExpiryTime,
    "v5_registration_document": v5RegistrationDocument,
  };
}

class VehicleType {
  int? id;
  String? name;
  int? driverWaitingCharges;
  int? accountWaitingCharges;
  dynamic waitingTime;

  VehicleType({
    this.id,
    this.name,
    this.driverWaitingCharges,
    this.accountWaitingCharges,
    this.waitingTime,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    id: json["id"],
    name: json["name"],
    driverWaitingCharges: json["driver_waiting_charges"],
    accountWaitingCharges: json["account_waiting_charges"],
    waitingTime: json["waiting_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "driver_waiting_charges": driverWaitingCharges,
    "account_waiting_charges": accountWaitingCharges,
    "waiting_time": waitingTime,
  };
}