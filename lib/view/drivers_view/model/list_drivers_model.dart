class GetDriverModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Drivers>? drivers;

  GetDriverModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.drivers});

  GetDriverModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['drivers'] != null) {
      drivers = <Drivers>[];
      json['drivers'].forEach((v) {
        drivers!.add(new Drivers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    data['count'] = this.count;
    if (this.drivers != null) {
      data['drivers'] = this.drivers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Drivers {
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
  Null? vehicleId;
  Null? driverStatus;
  Null? sessionStatus;
  Null? bookingStatus;
  Null? latitude;
  Null? longitude;
  Null? webDeviceId;
  Null? mobileDeviceId;
  Null? lastBooking;
  Null? lastVehicle;
  Null? notes;
  Null? zone;
  Null? rank;
  Null? waitingTime;
  Null? zoneUpdatedAt;
  Null? os;
  Null? version;
  String? sinBinTimer;
  Null? position;
  Null? pdaRent;
  int? companyVehicleId;
  Null? licenceExpiryTime;
  Null? phcDriverExpiryTime;
  Null? insuranceExpiryTime;
  Null? phcVehicleExpiryTime;
  Null? motExpiryTime;
  Null? mot2ExpiryTime;
  Null? v5RegistrationExpiryTime;
  Null? roadTaxExpiryTime;
  Null? rentalAgreementExpiryTime;
  String? subsidiaryName;
  Vehicle? vehicle;
  Subsidiary? subsidiary;

  Drivers(
      {this.id,
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
      this.vehicle,
      this.subsidiary});

  Drivers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subsidiaryId = json['subsidiary_id'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    telephone = json['telephone'];
    address = json['address'];
    dob = json['dob'];
    driverType = json['driver_type'];
    driverCommission = json['driver_commission'];
    rentLimit = json['rent_limit'];
    rentPaid = json['rent_paid'];
    balance = json['balance'];
    hasPda = json['has_pda'];
    useCompanyVehicle = json['use_company_vehicle'];
    active = json['active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    licenceNumber = json['licence_number'];
    licenceExpiry = json['licence_expiry'];
    phcDriverNumber = json['phc_driver_number'];
    phcDriverExpiry = json['phc_driver_expiry'];
    insuranceNumber = json['insurance_number'];
    insuranceExpiry = json['insurance_expiry'];
    rentalAgreementNumber = json['rental_agreement_number'];
    rentalAgreementExpiry = json['rental_agreement_expiry'];
    roadTaxNumber = json['road_tax_number'];
    roadTaxExpiry = json['road_tax_expiry'];
    v5RegistrationNumber = json['v5_registration_number'];
    v5RegistrationExpiry = json['v5_registration_expiry'];
    motNumber = json['mot_number'];
    motExpiry = json['mot_expiry'];
    mot2Number = json['mot2_number'];
    mot2Expiry = json['mot2_expiry'];
    phcVehicleNumber = json['phc_vehicle_number'];
    phcVehicleExpiry = json['phc_vehicle_expiry'];
    ni = json['ni'];
    image = json['image'];
    createdAt = json['created_at'];
    vehicleId = json['vehicle_id'];
    driverStatus = json['driver_status'];
    sessionStatus = json['session_status'];
    bookingStatus = json['booking_status'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    webDeviceId = json['web_device_id'];
    mobileDeviceId = json['mobile_device_id'];
    lastBooking = json['last_booking'];
    lastVehicle = json['last_vehicle'];
    notes = json['notes'];
    zone = json['zone'];
    rank = json['rank'];
    waitingTime = json['waiting_time'];
    zoneUpdatedAt = json['zone_updated_at'];
    os = json['os'];
    version = json['version'];
    sinBinTimer = json['sin_bin_timer'];
    position = json['position'];
    pdaRent = json['pda_rent'];
    companyVehicleId = json['company_vehicle_id'];
    licenceExpiryTime = json['licence_expiry_time'];
    phcDriverExpiryTime = json['phc_driver_expiry_time'];
    insuranceExpiryTime = json['insurance_expiry_time'];
    phcVehicleExpiryTime = json['phc_vehicle_expiry_time'];
    motExpiryTime = json['mot_expiry_time'];
    mot2ExpiryTime = json['mot2_expiry_time'];
    v5RegistrationExpiryTime = json['v5_registration_expiry_time'];
    roadTaxExpiryTime = json['road_tax_expiry_time'];
    rentalAgreementExpiryTime = json['rental_agreement_expiry_time'];
    subsidiaryName = json['subsidiary_name'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    subsidiary = json['subsidiary'] != null
        ? new Subsidiary.fromJson(json['subsidiary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subsidiary_id'] = this.subsidiaryId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['telephone'] = this.telephone;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['driver_type'] = this.driverType;
    data['driver_commission'] = this.driverCommission;
    data['rent_limit'] = this.rentLimit;
    data['rent_paid'] = this.rentPaid;
    data['balance'] = this.balance;
    data['has_pda'] = this.hasPda;
    data['use_company_vehicle'] = this.useCompanyVehicle;
    data['active'] = this.active;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['licence_number'] = this.licenceNumber;
    data['licence_expiry'] = this.licenceExpiry;
    data['phc_driver_number'] = this.phcDriverNumber;
    data['phc_driver_expiry'] = this.phcDriverExpiry;
    data['insurance_number'] = this.insuranceNumber;
    data['insurance_expiry'] = this.insuranceExpiry;
    data['rental_agreement_number'] = this.rentalAgreementNumber;
    data['rental_agreement_expiry'] = this.rentalAgreementExpiry;
    data['road_tax_number'] = this.roadTaxNumber;
    data['road_tax_expiry'] = this.roadTaxExpiry;
    data['v5_registration_number'] = this.v5RegistrationNumber;
    data['v5_registration_expiry'] = this.v5RegistrationExpiry;
    data['mot_number'] = this.motNumber;
    data['mot_expiry'] = this.motExpiry;
    data['mot2_number'] = this.mot2Number;
    data['mot2_expiry'] = this.mot2Expiry;
    data['phc_vehicle_number'] = this.phcVehicleNumber;
    data['phc_vehicle_expiry'] = this.phcVehicleExpiry;
    data['ni'] = this.ni;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['vehicle_id'] = this.vehicleId;
    data['driver_status'] = this.driverStatus;
    data['session_status'] = this.sessionStatus;
    data['booking_status'] = this.bookingStatus;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['web_device_id'] = this.webDeviceId;
    data['mobile_device_id'] = this.mobileDeviceId;
    data['last_booking'] = this.lastBooking;
    data['last_vehicle'] = this.lastVehicle;
    data['notes'] = this.notes;
    data['zone'] = this.zone;
    data['rank'] = this.rank;
    data['waiting_time'] = this.waitingTime;
    data['zone_updated_at'] = this.zoneUpdatedAt;
    data['os'] = this.os;
    data['version'] = this.version;
    data['sin_bin_timer'] = this.sinBinTimer;
    data['position'] = this.position;
    data['pda_rent'] = this.pdaRent;
    data['company_vehicle_id'] = this.companyVehicleId;
    data['licence_expiry_time'] = this.licenceExpiryTime;
    data['phc_driver_expiry_time'] = this.phcDriverExpiryTime;
    data['insurance_expiry_time'] = this.insuranceExpiryTime;
    data['phc_vehicle_expiry_time'] = this.phcVehicleExpiryTime;
    data['mot_expiry_time'] = this.motExpiryTime;
    data['mot2_expiry_time'] = this.mot2ExpiryTime;
    data['v5_registration_expiry_time'] = this.v5RegistrationExpiryTime;
    data['road_tax_expiry_time'] = this.roadTaxExpiryTime;
    data['rental_agreement_expiry_time'] = this.rentalAgreementExpiryTime;
    data['subsidiary_name'] = this.subsidiaryName;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    if (this.subsidiary != null) {
      data['subsidiary'] = this.subsidiary!.toJson();
    }
    return data;
  }
}

class Vehicle {
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  Null? endDate;
  VehicleType? vehicleType;

  Vehicle(
      {this.vehicleNumber,
      this.make,
      this.model,
      this.color,
      this.endDate,
      this.vehicleType});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleNumber = json['vehicle_number'];
    make = json['make'];
    model = json['model'];
    color = json['color'];
    endDate = json['end_date'];
    vehicleType = json['vehicle_type'] != null
        ? new VehicleType.fromJson(json['vehicle_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_number'] = this.vehicleNumber;
    data['make'] = this.make;
    data['model'] = this.model;
    data['color'] = this.color;
    data['end_date'] = this.endDate;
    if (this.vehicleType != null) {
      data['vehicle_type'] = this.vehicleType!.toJson();
    }
    return data;
  }
}

class VehicleType {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? driverWaitingCharges;

  VehicleType(
      {this.id,
      this.name,
      this.passengers,
      this.luggages,
      this.driverWaitingCharges});

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    passengers = json['passengers'];
    luggages = json['luggages'];
    driverWaitingCharges = json['driver_waiting_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['passengers'] = this.passengers;
    data['luggages'] = this.luggages;
    data['driver_waiting_charges'] = this.driverWaitingCharges;
    return data;
  }
}

class Subsidiary {
  String? name;

  Subsidiary({this.name});

  Subsidiary.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
