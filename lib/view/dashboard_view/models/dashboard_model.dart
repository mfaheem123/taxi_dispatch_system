// To parse this JSON data, do
//
//     final dashboardDataModel = dashboardDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

DashboardDataModel dashboardDataModelFromJson(String str) => DashboardDataModel.fromJson(json.decode(str));

String dashboardDataModelToJson(DashboardDataModel data) => json.encode(data.toJson());

class DashboardDataModel {
  bool? status;
  List<BookingStatus>? bookingStatuses;
  List<BookingType>? bookingTypes;
  List<JourneyTypeObject>? journeyTypes;
  List<PaymentStatus>? paymentStatuses;
  List<PaymentTypeObject>? paymentTypes;
  List<DashboardVehicleTypeObject>? vehicleTypes;
  List<DashboardSubsidiaryObject>? subsidiaries;
  List<DashboardDriverObject>? drivers;
  List<BookingTabObject>? bookingTabs;
  List<FareConfigurationObject>? fareConfigurations;
  List<FixedFareObject>? fixedFares;
  List<PlotFareObject>? plotFares;
  List<FareByVehicleObject>? fareByVehicles;
  List<AirportChargeObject>? airportCharges;

  DashboardDataModel({
    this.status,
    this.bookingStatuses,
    this.bookingTypes,
    this.journeyTypes,
    this.paymentStatuses,
    this.paymentTypes,
    this.vehicleTypes,
    this.subsidiaries,
    this.drivers,
    this.bookingTabs,
    this.fareConfigurations,
    this.fixedFares,
    this.plotFares,
    this.fareByVehicles,
    this.airportCharges,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) => DashboardDataModel(
    status: json["status"],
    bookingStatuses: List<BookingStatus>.from(json["booking_statuses"].map((x) => BookingStatus.fromJson(x))),
    bookingTypes: List<BookingType>.from(json["booking_types"].map((x) => BookingType.fromJson(x))),
    journeyTypes: List<JourneyTypeObject>.from(json["journey_types"].map((x) => JourneyTypeObject.fromJson(x))),
    paymentStatuses: List<PaymentStatus>.from(json["payment_statuses"].map((x) => PaymentStatus.fromJson(x))),
    paymentTypes: List<PaymentTypeObject>.from(json["payment_types"].map((x) => PaymentTypeObject.fromJson(x))),
    vehicleTypes: List<DashboardVehicleTypeObject>.from(json["vehicle_types"].map((x) => DashboardVehicleTypeObject.fromJson(x))),
    subsidiaries: List<DashboardSubsidiaryObject>.from(json["subsidiaries"].map((x) => DashboardSubsidiaryObject.fromJson(x))),
    drivers: List<DashboardDriverObject>.from(json["drivers"].map((x) => DashboardDriverObject.fromJson(x))),
    bookingTabs: List<BookingTabObject>.from(json["booking_tabs"].map((x) => BookingTabObject.fromJson(x))),
    fareConfigurations: List<FareConfigurationObject>.from(json["fare_configurations"].map((x) => FareConfigurationObject.fromJson(x))),
    fixedFares: List<FixedFareObject>.from(json["fixed_fares"].map((x) => FixedFareObject.fromJson(x))),
    plotFares: List<PlotFareObject>.from(json["plot_fares"].map((x) => PlotFareObject.fromJson(x))),
    fareByVehicles: List<FareByVehicleObject>.from(json["fare_by_vehicles"].map((x) => FareByVehicleObject.fromJson(x))),
    airportCharges: List<AirportChargeObject>.from(json["airport_charges"].map((x) => AirportChargeObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "booking_statuses": List<dynamic>.from(bookingStatuses!.map((x) => x.toJson())),
    "booking_types": List<dynamic>.from(bookingTypes!.map((x) => x.toJson())),
    "journey_types": List<dynamic>.from(journeyTypes!.map((x) => x.toJson())),
    "payment_statuses": List<dynamic>.from(paymentStatuses!.map((x) => x.toJson())),
    "payment_types": List<dynamic>.from(paymentTypes!.map((x) => x.toJson())),
    "vehicle_types": List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "subsidiaries": List<dynamic>.from(subsidiaries!.map((x) => x.toJson())),
    "drivers": List<dynamic>.from(drivers!.map((x) => x.toJson())),
    "booking_tabs": List<dynamic>.from(bookingTabs!.map((x) => x.toJson())),
    "fare_configurations": List<dynamic>.from(fareConfigurations!.map((x) => x.toJson())),
    "fixed_fares": List<dynamic>.from(fixedFares!.map((x) => x.toJson())),
    "plot_fares": List<dynamic>.from(plotFares!.map((x) => x.toJson())),
    "fare_by_vehicles": List<dynamic>.from(fareByVehicles!.map((x) => x.toJson())),
    "airport_charges": List<dynamic>.from(airportCharges!.map((x) => x.toJson())),
  };
}

class AirportChargeObject {
  int? id;
  String? name;
  int? locationTypeId;
  String? address;
  String? postcode;
  dynamic zoneId;
  String? shortcut;
  dynamic backgroundColor;
  dynamic foregroundColor;
  String? extraCharges;
  String? pickupCharges;
  String? dropoffCharges;
  bool? blacklist;
  String? latitude;
  String? longitude;
  LocationType? locationType;

  AirportChargeObject({
    this.id,
    this.name,
    this.locationTypeId,
    this.address,
    this.postcode,
    this.zoneId,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
    this.extraCharges,
    this.pickupCharges,
    this.dropoffCharges,
    this.blacklist,
    this.latitude,
    this.longitude,
    this.locationType,
  });

  factory AirportChargeObject.fromJson(Map<String, dynamic> json) => AirportChargeObject(
    id: json["id"],
    name: json["name"],
    locationTypeId: json["location_type_id"],
    address: json["address"],
    postcode: json["postcode"],
    zoneId: json["zone_id"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    extraCharges: json["extra_charges"],
    pickupCharges: json["pickup_charges"],
    dropoffCharges: json["dropoff_charges"],
    blacklist: json["blacklist"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    locationType: LocationType.fromJson(json["location_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type_id": locationTypeId,
    "address": address,
    "postcode": postcode,
    "zone_id": zoneId,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "extra_charges": extraCharges,
    "pickup_charges": pickupCharges,
    "dropoff_charges": dropoffCharges,
    "blacklist": blacklist,
    "latitude": latitude,
    "longitude": longitude,
    "location_type": locationType!.toJson(),
  };
}

class LocationType {
  int? id;
  String? name;
  String? shortcut;
  String? backgroundColor;
  String? foregroundColor;

  LocationType({
    this.id,
    this.name,
    this.shortcut,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"],
    name: json["name"],
    shortcut: json["shortcut"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "shortcut": shortcut,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class PlotFareObject {
  int? id;
  int? vehicleTypeId;
  int? pickupPlotId;
  int? dropoffPlotId;
  String? fares;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vehicleTypeName;
  String? pickupPlotName;
  String? dropoffPlotName;

  PlotFareObject({
    this.id,
    this.vehicleTypeId,
    this.pickupPlotId,
    this.dropoffPlotId,
    this.fares,
    this.createdAt,
    this.updatedAt,
    this.vehicleTypeName,
    this.pickupPlotName,
    this.dropoffPlotName,
  });

  factory PlotFareObject.fromJson(Map<String, dynamic> json) => PlotFareObject(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    pickupPlotId: json["pickup_plot_id"],
    dropoffPlotId: json["dropoff_plot_id"],
    fares: json["fares"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    vehicleTypeName: json["vehicle_type_name"],
    pickupPlotName: json["pickup_plot_name"],
    dropoffPlotName: json["dropoff_plot_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "pickup_plot_id": pickupPlotId,
    "dropoff_plot_id": dropoffPlotId,
    "fares": fares,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "vehicle_type_name": vehicleTypeName,
    "pickup_plot_name": pickupPlotName,
    "dropoff_plot_name": dropoffPlotName,
  };
}


class FareByVehicleObject {
  int? id;
  int? vehicleTypeId;
  String? fareByVehicleOperator;
  String? value;
  DateTime? createdAt;
  dynamic updatedAt;
  DashboardVehicleTypeObject? vehicleType;

  FareByVehicleObject({
    this.id,
    this.vehicleTypeId,
    this.fareByVehicleOperator,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.vehicleType,
  });

  factory FareByVehicleObject.fromJson(Map<String, dynamic> json) => FareByVehicleObject(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    fareByVehicleOperator: json["operator"],
    value: json["value"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    vehicleType: DashboardVehicleTypeObject.fromJson(json["vehicle_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "operator": fareByVehicleOperator,
    "value": value,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "vehicle_type": vehicleType!.toJson(),
  };
}

class FareConfigurationObject {
  int? id;
  int? vehicleTypeId;
  int? accountId;
  String? fromDay;
  String? toDay;
  String? fromTime;
  String? toTime;
  String? minimumFares;
  String? minimumMiles;
  String? fromDate;
  String? toDate;
  String? title;
  DateTime? createdAt;
  String? vehicleTypeName;
  double? vehicleMinimumFare;

  FareConfigurationObject({
    this.id,
    this.vehicleTypeId,
    this.accountId,
    this.fromDay,
    this.toDay,
    this.fromTime,
    this.toTime,
    this.minimumFares,
    this.minimumMiles,
    this.fromDate,
    this.toDate,
    this.title,
    this.createdAt,
    this.vehicleTypeName,
    this.vehicleMinimumFare,
  });

  factory FareConfigurationObject.fromJson(Map<String, dynamic> json) => FareConfigurationObject(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    accountId: json["account_id"],
    fromDay: json["from_day"],
    toDay: json["to_day"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    minimumFares: json["minimum_fares"],
    minimumMiles: json["minimum_miles"],
    fromDate: json["from_date"],
    toDate: json["to_date"],
    title: json["title"],
    createdAt: DateTime.parse(json["created_at"]),
    vehicleTypeName: json["vehicle_type_name"],
    vehicleMinimumFare: json["vehicle_minimum_fare"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "account_id": accountId,
    "from_day": fromDay,
    "to_day": toDay,
    "from_time": fromTime,
    "to_time": toTime,
    "minimum_fares": minimumFares,
    "minimum_miles": minimumMiles,
    "from_date": fromDate,
    "to_date": toDate,
    "title": title,
    "created_at": createdAt!.toIso8601String(),
    "vehicle_type_name": vehicleTypeName,
    "vehicle_minimum_fare": vehicleMinimumFare,
  };
}

class FixedFareObject {
  int? id;
  int? vehicleTypeId;
  String? fares;
  String? area1;
  String? area2;
  int? fromLocationId;
  int? toLocationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vehicleTypeName;
  String? fromLocationName;
  String? toLocationName;

  FixedFareObject({
    this.id,
    this.vehicleTypeId,
    this.fares,
    this.area1,
    this.area2,
    this.fromLocationId,
    this.toLocationId,
    this.createdAt,
    this.updatedAt,
    this.vehicleTypeName,
    this.fromLocationName,
    this.toLocationName,
  });

  factory FixedFareObject.fromJson(Map<String, dynamic> json) => FixedFareObject(
    id: json["id"],
    vehicleTypeId: json["vehicle_type_id"],
    fares: json["fares"],
    area1: json["area1"],
    area2: json["area2"],
    fromLocationId: json["from_location_id"],
    toLocationId: json["to_location_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    vehicleTypeName: json["vehicle_type_name"],
    fromLocationName: json["from_location_name"],
    toLocationName: json["to_location_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle_type_id": vehicleTypeId,
    "fares": fares,
    "area1": area1,
    "area2": area2,
    "from_location_id": fromLocationId,
    "to_location_id": toLocationId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "vehicle_type_name": vehicleTypeName,
    "from_location_name": fromLocationName,
    "to_location_name": toLocationName,
  };
}

class BookingTabObject {
  int? id;
  String? bookingTabs;
  int? bookingCount;
  RxBool? selectedClr = false.obs;
  RxBool? deletedClr = false.obs;
  List<String>? dropDownList = [];
  String? selectedDropDownValue;

  BookingTabObject({
    this.id,
    this.bookingTabs,
    this.bookingCount,
    this.selectedClr,
    this.deletedClr,
    this.dropDownList,
    this.selectedDropDownValue,
  });

  factory BookingTabObject.fromJson(Map<String, dynamic> json) => BookingTabObject(
    id: json["id"],
    bookingTabs: json["booking_tabs"],
    bookingCount: json["booking_count"],
    selectedClr: false.obs,
    deletedClr: false.obs,
    dropDownList: [],
    selectedDropDownValue: null
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_tabs": bookingTabs,
    "booking_count": bookingCount,
    'dropDownList': dropDownList,
    'selectedDropDownValue': selectedDropDownValue,
    'selectedClr': false.obs,
    'deletedClr': false.obs,
  };
}

class BookingStatus {
  int? id;
  String? bookingStatus;

  BookingStatus({
    this.id,
    this.bookingStatus,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
    id: json["id"],
    bookingStatus: json["booking_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_status": bookingStatus,
  };
}

class BookingType {
  int? id;
  String? bookingType;

  BookingType({
    this.id,
    this.bookingType,
  });

  factory BookingType.fromJson(Map<String, dynamic> json) => BookingType(
    id: json["id"],
    bookingType: json["booking_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking_type": bookingType,
  };
}

class DashboardDriverObject {
  int? id;
  String? name;
  String? username;
  String? zone;
  String? vehicleType;
  DateTime? lastLoginAt;

  DashboardDriverObject({
    this.id,
    this.username,
    this.name,
    this.zone,
    this.lastLoginAt,
    this.vehicleType,
  });

  factory DashboardDriverObject.fromJson(Map<String, dynamic> json) => DashboardDriverObject(
    id: json['id'],
    name: json['name'],
    username: json['username'],
    zone: json['zone'],
    vehicleType: json['vehicle_type'],
    lastLoginAt: json['last_login_at'] != null
        ? DateTime.parse(json['last_login_at']).toLocal()
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "zone": zone,
    "last_login_at": lastLoginAt,
    "vehicle_type": vehicleType,
  };
}

class JourneyTypeObject {
  int? id;
  String? journeyType;

  JourneyTypeObject({
    this.id,
    this.journeyType,
  });

  factory JourneyTypeObject.fromJson(Map<String, dynamic> json) => JourneyTypeObject(
    id: json["id"],
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "journey_type": journeyType,
  };
}

class PaymentStatus {
  int? id;
  String? paymentStatus;

  PaymentStatus({
    this.id,
    this.paymentStatus,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) => PaymentStatus(
    id: json["id"],
    paymentStatus: json["payment_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "payment_status": paymentStatus,
  };
}

class PaymentTypeObject {
  int? id;
  String? name;
  dynamic service;
  String? backgroundColor;
  String? foregroundColor;

  PaymentTypeObject({
    this.id,
    this.name,
    this.service,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory PaymentTypeObject.fromJson(Map<String, dynamic> json) => PaymentTypeObject(
    id: json["id"],
    name: json["name"],
    service: json["service"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "service": service,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class DashboardSubsidiaryObject {
  int? id;
  String? backgroundColor;
  String? foregroundColor;
  String? name;

  DashboardSubsidiaryObject({
    this.id,
    this.backgroundColor,
    this.foregroundColor,
    this.name,
  });

  factory DashboardSubsidiaryObject.fromJson(Map<String, dynamic> json) => DashboardSubsidiaryObject(
    id: json["id"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "name": name,
  };
}

class DashboardVehicleTypeObject {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? handLuggages;
  num? minimumFares;
  num? minimumMiles;
  int? waitingTime;
  int? waitingTimeDuration;
  bool? defaultVehicle;
  bool? vehicleTypeMinimumFares;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? backgroundColor;
  String? foregroundColor;
  num? driverWaitingCharges;
  num? accountWaitingCharges;

  DashboardVehicleTypeObject({
    this.id,
    this.name,
    this.passengers,
    this.luggages,
    this.handLuggages,
    this.minimumFares,
    this.minimumMiles,
    this.waitingTime,
    this.waitingTimeDuration,
    this.defaultVehicle,
    this.vehicleTypeMinimumFares,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.backgroundColor,
    this.foregroundColor,
    this.driverWaitingCharges,
    this.accountWaitingCharges,
  });

  factory DashboardVehicleTypeObject.fromJson(Map<String, dynamic> json) => DashboardVehicleTypeObject(
    id: json["id"],
    name: json["name"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    handLuggages: json["hand_luggages"],
    minimumFares: json["minimum_fares"],
    minimumMiles: json["minimum_miles"],
    waitingTime: json["waiting_time"],
    waitingTimeDuration: json["waiting_time_duration"],
    defaultVehicle: json["default_vehicle"],
    vehicleTypeMinimumFares: json["vehicle_type_minimum_fares"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    driverWaitingCharges: json["driver_waiting_charges"],
    accountWaitingCharges: json["account_waiting_charges"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "passengers": passengers,
    "luggages": luggages,
    "hand_luggages": handLuggages,
    "minimum_fares": minimumFares,
    "minimum_miles": minimumMiles,
    "waiting_time": waitingTime,
    "waiting_time_duration": waitingTimeDuration,
    "default_vehicle": defaultVehicle,
    "vehicle_type_minimum_fares": vehicleTypeMinimumFares,
    "image": image,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "driver_waiting_charges": driverWaitingCharges,
    "account_waiting_charges": accountWaitingCharges,
  };
}
