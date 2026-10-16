import 'dart:convert';

DriverAttributeModel driverAttributeModelFromJson(String str) =>
    DriverAttributeModel.fromJson(json.decode(str));

String driverAttributeModelToJson(DriverAttributeModel data) =>
    json.encode(data.toJson());

class DriverAttributeModel {
  bool? status;
  int? count;
  String? message;
  List<DriverAttribute>? driverAttributes;

  DriverAttributeModel({
    this.status,
    this.count,
    this.message,
    this.driverAttributes,
  });

  factory DriverAttributeModel.fromJson(Map<String, dynamic> json) {
    List<DriverAttribute> list = [];
    if (json["driver_attribute"] != null) {
      if (json["driver_attribute"] is List) {
        list = List<DriverAttribute>.from(
          (json["driver_attribute"] as List)
              .map((x) => DriverAttribute.fromJson(x)),
        );
      } else if (json["driver_attribute"] is Map<String, dynamic>) {
        list = [DriverAttribute.fromJson(json["driver_attribute"])];
      }
    }
    return DriverAttributeModel(
      status: json["status"],
      count: json["count"],
      message: json["message"],
      driverAttributes: list,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "message": message,
        "driver_attribute": driverAttributes == null
            ? []
            : List<dynamic>.from(driverAttributes!.map((x) => x.toJson())),
      };
}

class DriverAttribute {
  int? id;
  String? attributeName;
  String? shortName;

  DriverAttribute({
    this.id,
    this.attributeName,
    this.shortName,
  });

  factory DriverAttribute.fromJson(Map<String, dynamic> json) => DriverAttribute(
        id: json["id"],
        attributeName: json["attribute_name"],
        shortName: json["short_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attribute_name": attributeName,
        "short_name": shortName,
      };
}
