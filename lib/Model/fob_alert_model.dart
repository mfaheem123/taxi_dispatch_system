// To parse this JSON data, do
//
//     final getFobModel = getFobModelFromJson(jsonString);

import 'dart:convert';

GetFobModel getFobModelFromJson(String str) => GetFobModel.fromJson(json.decode(str));

String getFobModelToJson(GetFobModel data) => json.encode(data.toJson());

class GetFobModel {
  bool? status;
  List<Driver>? drivers;

  GetFobModel({
    this.status,
    this.drivers,
  });

  factory GetFobModel.fromJson(Map<String, dynamic> json) => GetFobModel(
    status: json["status"],
    drivers: json["drivers"] == null ? [] : List<Driver>.from(json["drivers"]!.map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "drivers": drivers == null ? [] : List<dynamic>.from(drivers!.map((x) => x.toJson())),
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
  dynamic licenceNumber;
  DateTime? licenceExpiry;
  dynamic phcDriverNumber;
  DateTime? phcDriverExpiry;
  dynamic insuranceNumber;
  DateTime? insuranceExpiry;
  dynamic rentalAgreementNumber;
  DateTime? rentalAgreementExpiry;
  dynamic roadTaxNumber;
  DateTime? roadTaxExpiry;
  dynamic v5RegistrationNumber;
  DateTime? v5RegistrationExpiry;
  dynamic motNumber;
  DateTime? motExpiry;
  dynamic mot2Number;
  DateTime? mot2Expiry;
  dynamic phcVehicleNumber;
  DateTime? phcVehicleExpiry;
  String? ni;
  String? image;
  String? createdAt;
  int? vehicleId;
  String? driverStatus;
  String? sessionStatus;
  String? bookingStatus;
  String? latitude;
  String? longitude;
  dynamic webDeviceId;
  dynamic mobileDeviceId;
  dynamic lastBooking;
  dynamic lastVehicle;
  dynamic notes;
  dynamic zone;
  int? rank;
  dynamic waitingTime;
  dynamic zoneUpdatedAt;
  dynamic os;
  dynamic version;
  String? sinBinTimer;
  dynamic position;
  String? pdaRent;
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
  String? driverAccessToken;
  int? companyId;
  dynamic fcmToken;
  String? fcmUpdatedAt;
  dynamic lastLoginAt;
  String? subsidiaryName;
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
    this.driverAccessToken,
    this.companyId,
    this.fcmToken,
    this.fcmUpdatedAt,
    this.lastLoginAt,
    this.subsidiaryName,
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
    licenceExpiry: json["licence_expiry"] == null ? null : DateTime.parse(json["licence_expiry"]),
    phcDriverNumber: json["phc_driver_number"],
    phcDriverExpiry: json["phc_driver_expiry"] == null ? null : DateTime.parse(json["phc_driver_expiry"]),
    insuranceNumber: json["insurance_number"],
    insuranceExpiry: json["insurance_expiry"] == null ? null : DateTime.parse(json["insurance_expiry"]),
    rentalAgreementNumber: json["rental_agreement_number"],
    rentalAgreementExpiry: json["rental_agreement_expiry"] == null ? null : DateTime.parse(json["rental_agreement_expiry"]),
    roadTaxNumber: json["road_tax_number"],
    roadTaxExpiry: json["road_tax_expiry"] == null ? null : DateTime.parse(json["road_tax_expiry"]),
    v5RegistrationNumber: json["v5_registration_number"],
    v5RegistrationExpiry: json["v5_registration_expiry"] == null ? null : DateTime.parse(json["v5_registration_expiry"]),
    motNumber: json["mot_number"],
    motExpiry: json["mot_expiry"] == null ? null : DateTime.parse(json["mot_expiry"]),
    mot2Number: json["mot2_number"],
    mot2Expiry: json["mot2_expiry"] == null ? null : DateTime.parse(json["mot2_expiry"]),
    phcVehicleNumber: json["phc_vehicle_number"],
    phcVehicleExpiry: json["phc_vehicle_expiry"] == null ? null : DateTime.parse(json["phc_vehicle_expiry"]),
    ni: json["ni"],
    image: json["image"],
    createdAt: json["created_at"],
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
    notes: json["notes"],
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
    driverAccessToken: json["driver_access_token"],
    companyId: json["company_id"],
    fcmToken: json["fcm_token"],
    fcmUpdatedAt: json["fcm_updated_at"],
    lastLoginAt: json["last_login_at"],
    subsidiaryName: json["subsidiary_name"],
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
    "licence_expiry": "${licenceExpiry!.year.toString().padLeft(4, '0')}-${licenceExpiry!.month.toString().padLeft(2, '0')}-${licenceExpiry!.day.toString().padLeft(2, '0')}",
    "phc_driver_number": phcDriverNumber,
    "phc_driver_expiry": "${phcDriverExpiry!.year.toString().padLeft(4, '0')}-${phcDriverExpiry!.month.toString().padLeft(2, '0')}-${phcDriverExpiry!.day.toString().padLeft(2, '0')}",
    "insurance_number": insuranceNumber,
    "insurance_expiry": "${insuranceExpiry!.year.toString().padLeft(4, '0')}-${insuranceExpiry!.month.toString().padLeft(2, '0')}-${insuranceExpiry!.day.toString().padLeft(2, '0')}",
    "rental_agreement_number": rentalAgreementNumber,
    "rental_agreement_expiry": "${rentalAgreementExpiry!.year.toString().padLeft(4, '0')}-${rentalAgreementExpiry!.month.toString().padLeft(2, '0')}-${rentalAgreementExpiry!.day.toString().padLeft(2, '0')}",
    "road_tax_number": roadTaxNumber,
    "road_tax_expiry": "${roadTaxExpiry!.year.toString().padLeft(4, '0')}-${roadTaxExpiry!.month.toString().padLeft(2, '0')}-${roadTaxExpiry!.day.toString().padLeft(2, '0')}",
    "v5_registration_number": v5RegistrationNumber,
    "v5_registration_expiry": "${v5RegistrationExpiry!.year.toString().padLeft(4, '0')}-${v5RegistrationExpiry!.month.toString().padLeft(2, '0')}-${v5RegistrationExpiry!.day.toString().padLeft(2, '0')}",
    "mot_number": motNumber,
    "mot_expiry": "${motExpiry!.year.toString().padLeft(4, '0')}-${motExpiry!.month.toString().padLeft(2, '0')}-${motExpiry!.day.toString().padLeft(2, '0')}",
    "mot2_number": mot2Number,
    "mot2_expiry": "${mot2Expiry!.year.toString().padLeft(4, '0')}-${mot2Expiry!.month.toString().padLeft(2, '0')}-${mot2Expiry!.day.toString().padLeft(2, '0')}",
    "phc_vehicle_number": phcVehicleNumber,
    "phc_vehicle_expiry": "${phcVehicleExpiry!.year.toString().padLeft(4, '0')}-${phcVehicleExpiry!.month.toString().padLeft(2, '0')}-${phcVehicleExpiry!.day.toString().padLeft(2, '0')}",
    "ni": ni,
    "image": image,
    "created_at": createdAt,
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
    "notes": notes,
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
    "driver_access_token": driverAccessToken,
    "company_id": companyId,
    "fcm_token": fcmToken,
    "fcm_updated_at": fcmUpdatedAt,
    "last_login_at": lastLoginAt,
    "subsidiary_name": subsidiaryName,
    "vehicle": vehicle?.toJson(),
  };
}

class Vehicle {
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  dynamic endDate;
  VehicleType? vehicleType;

  Vehicle({
    this.vehicleNumber,
    this.make,
    this.model,
    this.color,
    this.endDate,
    this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    vehicleNumber: json["vehicle_number"],
    make: json["make"],
    model: json["model"],
    color: json["color"],
    endDate: json["end_date"],
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "vehicle_number": vehicleNumber,
    "make": make,
    "model": model,
    "color": color,
    "end_date": endDate,
    "vehicle_type": vehicleType?.toJson(),
  };
}

class VehicleType {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? driverWaitingCharges;

  VehicleType({
    this.id,
    this.name,
    this.passengers,
    this.luggages,
    this.driverWaitingCharges,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    id: json["id"],
    name: json["name"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    driverWaitingCharges: json["driver_waiting_charges"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "passengers": passengers,
    "luggages": luggages,
    "driver_waiting_charges": driverWaitingCharges,
  };
}
