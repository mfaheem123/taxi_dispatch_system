class CompanyVehicleModel {
  bool? status;
  int? page;
  int? total;
  int? totalPages;
  int? count;
  List<Vehicles>? vehicles;

  CompanyVehicleModel(
      {this.status,
      this.page,
      this.total,
      this.totalPages,
      this.count,
      this.vehicles});

  CompanyVehicleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    data['count'] = this.count;
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  int? id;
  String? vehicleNumber;
  String? make;
  String? model;
  String? color;
  String? owner;
  bool? company;
  bool? assigned;
  int? vehicleTypeId;
  String? logBookNumber;
  String? phcVehicleNumber;
  String? motNumber;
  String? mot2Number;
  String? insuranceNumber;
  DateTime? phcVehicleExpiry;
  DateTime? motExpiry;
  DateTime? mot2Expiry;
  DateTime? insuranceExpiry;
  String? logBookDocument;
  String? phcVehicleDocument;
  String? motDocument;
  String? mot2Document;
  String? insuranceDocument;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  String? phcVehicleExpiryTime;
  String? motExpiryTime;
  String? mot2ExpiryTime;
  String? insuranceExpiryTime;
  String? vehicleTypeName;
  VehicleType? vehicleType;

  Vehicles(
      {this.id,
      this.vehicleNumber,
      this.make,
      this.model,
      this.color,
      this.owner,
      this.company,
      this.assigned,
      this.vehicleTypeId,
      this.logBookNumber,
      this.phcVehicleNumber,
      this.motNumber,
      this.mot2Number,
      this.insuranceNumber,
      this.phcVehicleExpiry,
      this.motExpiry,
      this.mot2Expiry,
      this.insuranceExpiry,
      this.logBookDocument,
      this.phcVehicleDocument,
      this.motDocument,
      this.mot2Document,
      this.insuranceDocument,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt,
      this.phcVehicleExpiryTime,
      this.motExpiryTime,
      this.mot2ExpiryTime,
      this.insuranceExpiryTime,
      this.vehicleTypeName,
      this.vehicleType});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleNumber = json['vehicle_number'];
    make = json['make'];
    model = json['model'];
    color = json['color'];
    owner = json['owner'];
    company = json['company'];
    assigned = json['assigned'];
    vehicleTypeId = json['vehicle_type_id'];
    logBookNumber = json['log_book_number'];
    phcVehicleNumber = json['phc_vehicle_number'];
    motNumber = json['mot_number'];
    mot2Number = json['mot2_number'];
    insuranceNumber = json['insurance_number'];
    phcVehicleExpiry = json['phc_vehicle_expiry'] == null ? null : DateTime.parse(json["phc_vehicle_expiry"]);
    motExpiry = json['mot_expiry'] == null ? null : DateTime.parse(json["mot_expiry"]);
    mot2Expiry = json['mot2_expiry'] == null ? null : DateTime.parse(json["mot2_expiry"]);
    insuranceExpiry = json['insurance_expiry'] == null ? null : DateTime.parse(json["insurance_expiry"]);
    logBookDocument = json['log_book_document'];
    phcVehicleDocument = json['phc_vehicle_document'];
    motDocument = json['mot_document'];
    mot2Document = json['mot2_document'];
    insuranceDocument = json['insurance_document'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phcVehicleExpiryTime = json['phc_vehicle_expiry_time'];
    motExpiryTime = json['mot_expiry_time'];
    mot2ExpiryTime = json['mot2_expiry_time'];
    insuranceExpiryTime = json['insurance_expiry_time'];
    vehicleTypeName = json['vehicle_type_name'];
    vehicleType = json['vehicle_type'] != null
        ? new VehicleType.fromJson(json['vehicle_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_number'] = this.vehicleNumber;
    data['make'] = this.make;
    data['model'] = this.model;
    data['color'] = this.color;
    data['owner'] = this.owner;
    data['company'] = this.company;
    data['assigned'] = this.assigned;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['log_book_number'] = this.logBookNumber;
    data['phc_vehicle_number'] = this.phcVehicleNumber;
    data['mot_number'] = this.motNumber;
    data['mot2_number'] = this.mot2Number;
    data['insurance_number'] = this.insuranceNumber;
    data['phc_vehicle_expiry'] = this.phcVehicleExpiry != null
        ? "${this.phcVehicleExpiry!.year.toString().padLeft(4, '0')}-${this.phcVehicleExpiry!.month.toString().padLeft(2, '0')}-${this.phcVehicleExpiry!.day.toString().padLeft(2, '0')}"
        : null;

    data['mot_expiry'] = this.motExpiry != null
        ? "${this.motExpiry!.year.toString().padLeft(4, '0')}-${this.motExpiry!.month.toString().padLeft(2, '0')}-${this.motExpiry!.day.toString().padLeft(2, '0')}"
        : null;

    data['mot2_expiry'] = this.mot2Expiry != null
        ? "${this.mot2Expiry!.year.toString().padLeft(4, '0')}-${this.mot2Expiry!.month.toString().padLeft(2, '0')}-${this.mot2Expiry!.day.toString().padLeft(2, '0')}"
        : null;

    data['insurance_expiry'] = this.insuranceExpiry != null
        ? "${this.insuranceExpiry!.year.toString().padLeft(4, '0')}-${this.insuranceExpiry!.month.toString().padLeft(2, '0')}-${this.insuranceExpiry!.day.toString().padLeft(2, '0')}"
        : null;
    data['log_book_document'] = this.logBookDocument;
    data['phc_vehicle_document'] = this.phcVehicleDocument;
    data['mot_document'] = this.motDocument;
    data['mot2_document'] = this.mot2Document;
    data['insurance_document'] = this.insuranceDocument;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phc_vehicle_expiry_time'] = this.phcVehicleExpiryTime;
    data['mot_expiry_time'] = this.motExpiryTime;
    data['mot2_expiry_time'] = this.mot2ExpiryTime;
    data['insurance_expiry_time'] = this.insuranceExpiryTime;
    data['vehicle_type_name'] = this.vehicleTypeName;
    if (this.vehicleType != null) {
      data['vehicle_type'] = this.vehicleType!.toJson();
    }
    return data;
  }
}

class VehicleType {
  int? id;
  String? name;

  VehicleType({this.id, this.name});

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
