// To parse this JSON data, do
//
//     final listEscortModel = listEscortModelFromJson(jsonString);

import 'dart:convert';

ListEscortModel listEscortModelFromJson(String str) => ListEscortModel.fromJson(json.decode(str));

String listEscortModelToJson(ListEscortModel data) => json.encode(data.toJson());

class ListEscortModel {
    bool? status;
    int? count;
    List<Escort>? escorts;

    ListEscortModel({
        this.status,
        this.count,
        this.escorts,
    });

    factory ListEscortModel.fromJson(Map<String, dynamic> json) => ListEscortModel(
        status: json["status"],
        count: json["count"],
        escorts: json["escorts"] == null ? [] : List<Escort>.from(json["escorts"]!.map((x) => Escort.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "escorts": escorts == null ? [] : List<dynamic>.from(escorts!.map((x) => x.toJson())),
    };
}

class Escort {
    int? id;
    String? name;
    String? dob;
    String? email;
    String? mobile;
    String? address;
    bool? active;
    String? image;
    String? safeguardingDocument;
    String? patDocument;
    String? firstaidDocument;
    String? dbsDocument;
    String? safeguardingNumber;
    String? patNumber;
    String? firstaidNumber;
    String? dbsNumber;
    String? safeguardingExpiry;
    String? patExpiry;
    String? firstaidExpiry;
    String? dbsExpiry;
    String? createdAt;
    String? updatedAt;

    Escort({
        this.id,
        this.name,
        this.dob,
        this.email,
        this.mobile,
        this.address,
        this.active,
        this.image,
        this.safeguardingDocument,
        this.patDocument,
        this.firstaidDocument,
        this.dbsDocument,
        this.safeguardingNumber,
        this.patNumber,
        this.firstaidNumber,
        this.dbsNumber,
        this.safeguardingExpiry,
        this.patExpiry,
        this.firstaidExpiry,
        this.dbsExpiry,
        this.createdAt,
        this.updatedAt,
    });

    factory Escort.fromJson(Map<String, dynamic> json) => Escort(
        id: json["id"],
        name: json["name"],
        dob: json["dob"],
        email: json["email"],
        mobile: json["mobile"],
        address: json["address"],
        active: json["active"],
        image: json["image"],
        safeguardingDocument: json["safeguarding_document"],
        patDocument: json["pat_document"],
        firstaidDocument: json["firstaid_document"],
        dbsDocument: json["dbs_document"],
        safeguardingNumber: json["safeguarding_number"],
        patNumber: json["pat_number"],
        firstaidNumber: json["firstaid_number"],
        dbsNumber: json["dbs_number"],
        safeguardingExpiry: json["safeguarding_expiry"],
        patExpiry: json["pat_expiry"],
        firstaidExpiry: json["firstaid_expiry"],
        dbsExpiry: json["dbs_expiry"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dob": dob,
        "email": email,
        "mobile": mobile,
        "address": address,
        "active": active,
        "image": image,
        "safeguarding_document": safeguardingDocument,
        "pat_document": patDocument,
        "firstaid_document": firstaidDocument,
        "dbs_document": dbsDocument,
        "safeguarding_number": safeguardingNumber,
        "pat_number": patNumber,
        "firstaid_number": firstaidNumber,
        "dbs_number": dbsNumber,
        "safeguarding_expiry": safeguardingExpiry,
        "pat_expiry": patExpiry,
        "firstaid_expiry": firstaidExpiry,
        "dbs_expiry": dbsExpiry,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
