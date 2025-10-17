// To parse this JSON data, do
//
//     final companyVehicleModel = companyVehicleModelFromJson(jsonString);

import 'dart:convert';

CompanyVehicleModel companyVehicleModelFromJson(String str) => CompanyVehicleModel.fromJson(json.decode(str));

String companyVehicleModelToJson(CompanyVehicleModel data) => json.encode(data.toJson());

class CompanyVehicleModel {
    bool? status;
    int? count;
    List<Vehicle>? vehicles;

    CompanyVehicleModel({
        this.status,
        this.count,
        this.vehicles,
    });

    factory CompanyVehicleModel.fromJson(Map<String, dynamic> json) => CompanyVehicleModel(
        status: json["status"],
        count: json["count"],
        vehicles: json["vehicles"] == null ? [] : List<Vehicle>.from(json["vehicles"]!.map((x) => Vehicle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "vehicles": vehicles == null ? [] : List<dynamic>.from(vehicles!.map((x) => x.toJson())),
    };
}

class Vehicle {
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
    DateTime? startDate;
    DateTime? endDate;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? vehicleTypeName;
    VehicleType? vehicleType;

    Vehicle({
        this.id,
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
        this.vehicleTypeName,
        this.vehicleType,
    });

    factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        vehicleNumber: json["vehicle_number"],
        make: json["make"],
        model: json["model"],
        color: json["color"],
        owner: json["owner"],
        company: json["company"],
        assigned: json["assigned"],
        vehicleTypeId: json["vehicle_type_id"],
        logBookNumber: json["log_book_number"],
        phcVehicleNumber: json["phc_vehicle_number"],
        motNumber: json["mot_number"],
        mot2Number: json["mot2_number"],
        insuranceNumber: json["insurance_number"],
        phcVehicleExpiry: json["phc_vehicle_expiry"] == null ? null : DateTime.parse(json["phc_vehicle_expiry"]),
        motExpiry: json["mot_expiry"] == null ? null : DateTime.parse(json["mot_expiry"]),
        mot2Expiry: json["mot2_expiry"] == null ? null : DateTime.parse(json["mot2_expiry"]),
        insuranceExpiry: json["insurance_expiry"] == null ? null : DateTime.parse(json["insurance_expiry"]),
        logBookDocument: json["log_book_document"],
        phcVehicleDocument: json["phc_vehicle_document"],
        motDocument: json["mot_document"],
        mot2Document: json["mot2_document"],
        insuranceDocument: json["insurance_document"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        vehicleTypeName: json["vehicle_type_name"],
        vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_number": vehicleNumber,
        "make": make,
        "model": model,
        "color": color,
        "owner": owner,
        "company": company,
        "assigned": assigned,
        "vehicle_type_id": vehicleTypeId,
        "log_book_number": logBookNumber,
        "phc_vehicle_number": phcVehicleNumber,
        "mot_number": motNumber,
        "mot2_number": mot2Number,
        "insurance_number": insuranceNumber,
        "phc_vehicle_expiry": phcVehicleExpiry?.toIso8601String(),
        "mot_expiry": motExpiry?.toIso8601String(),
        "mot2_expiry": mot2Expiry?.toIso8601String(),
        "insurance_expiry": insuranceExpiry?.toIso8601String(),
        "log_book_document": logBookDocument,
        "phc_vehicle_document": phcVehicleDocument,
        "mot_document": motDocument,
        "mot2_document": mot2Document,
        "insurance_document": insuranceDocument,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "vehicle_type_name": vehicleTypeName,
        "vehicle_type": vehicleType?.toJson(),
    };
}

class VehicleType {
    int? id;
    String? name;

    VehicleType({
        this.id,
        this.name,
    });

    factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
