// To parse this JSON data, do
//
//     final driverRentModel = driverRentModelFromJson(jsonString);

import 'dart:convert';

DriverRentModel driverRentModelFromJson(String str) => DriverRentModel.fromJson(json.decode(str));

String driverRentModelToJson(DriverRentModel data) => json.encode(data.toJson());

class DriverRentModel {
  bool? status;
  String? message;
  int? total;
  List<CreateDriverRent>? drivers;

  DriverRentModel({
    this.status,
    this.message,
    this.total,
    this.drivers,
  });

  factory DriverRentModel.fromJson(Map<String, dynamic> json) => DriverRentModel(
    status: json["status"],
    message: json["message"],
    total: json["total"],
    drivers: json["drivers"] == null ? [] : List<CreateDriverRent>.from(json["drivers"]!.map((x) => CreateDriverRent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "total": total,
    "drivers": drivers == null ? [] : List<dynamic>.from(drivers!.map((x) => x.toJson())),
  };
}

class CreateDriverRent {
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
  String? createdAt;
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
  dynamic fcmUpdatedAt;
  String? subsidiaryName;
  Vehicle? vehicle;
  Subsidiary? subsidiary;

  CreateDriverRent({
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
    this.subsidiaryName,
    this.vehicle,
    this.subsidiary,
  });

  factory CreateDriverRent.fromJson(Map<String, dynamic> json) => CreateDriverRent(
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
    subsidiaryName: json["subsidiary_name"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    subsidiary: json["subsidiary"] == null ? null : Subsidiary.fromJson(json["subsidiary"]),
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
    "subsidiary_name": subsidiaryName,
    "vehicle": vehicle?.toJson(),
    "subsidiary": subsidiary?.toJson(),
  };
}

class Subsidiary {
  String? name;

  Subsidiary({
    this.name,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}

class Vehicle {
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  String? endDate;
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
