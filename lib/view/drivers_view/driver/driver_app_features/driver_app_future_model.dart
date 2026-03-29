// To parse this JSON data, do
//
//     final driverAppFutureModel = driverAppFutureModelFromJson(jsonString);

import 'dart:convert';

DriverAppFutureModel driverAppFutureModelFromJson(String str) => DriverAppFutureModel.fromJson(json.decode(str));

String driverAppFutureModelToJson(DriverAppFutureModel data) => json.encode(data.toJson());

class DriverAppFutureModel {
  bool? status;
  List<AppFeature>? appFeatures;

  DriverAppFutureModel({
    this.status,
    this.appFeatures,
  });

  factory DriverAppFutureModel.fromJson(Map<String, dynamic> json) => DriverAppFutureModel(
    status: json["status"],
    appFeatures: json["appFeatures"] == null ? [] : List<AppFeature>.from(json["appFeatures"]!.map((x) => AppFeature.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "appFeatures": appFeatures == null ? [] : List<dynamic>.from(appFeatures!.map((x) => x.toJson())),
  };
}

class AppFeature {
  int? id;
  int? driverId;
  Features? features;

  AppFeature({
    this.id,
    this.driverId,
    this.features,
  });

  factory AppFeature.fromJson(Map<String, dynamic> json) => AppFeature(
    id: json["id"],
    driverId: json["driver_id"],
    features: json["features"] == null ? null : Features.fromJson(json["features"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "features": features?.toJson(),
  };
}

class Features {
  int? id;
  int? driverId;
  bool? showCustomerNumber;
  bool? enableCustomerCall;
  bool? enableFlagdown;
  bool? showAccountFare;
  bool? hideBreak;
  bool? hideDecline;
  bool? hideRecover;
  bool? hideNoPickup;
  bool? hidePickup;
  bool? hideDropoff;
  bool? fareMeter;
  bool? disableFareMeterAccountJob;
  bool? fareMeterWaitingCharges;
  bool? payByCard;
  bool? waitingAfterArrival;
  bool? sendReceipt;
  bool? showPlot;
  bool? disablePanicButon;
  bool? showNavigation;
  bool? showStaNear500Yards;
  bool? showFare;
  bool? hasCompanyCar;
  bool? hidePaymentType;
  bool? enableTollCharges;
  dynamic bookingTimer;
  dynamic breakTimer;
  dynamic mobileImeiNumber;
  dynamic mobileMake;
  dynamic mobileModel;
  dynamic mobileSimNetwork;
  dynamic mobileSimNumber;
  dynamic mobileNetworkProvider;
  dynamic mobileDataAllowance;
  dynamic pdaDeposit;
  dynamic pdaComments;
  String? createdAt;
  String? updatedAt;

  Features({
    this.id,
    this.driverId,
    this.showCustomerNumber,
    this.enableCustomerCall,
    this.enableFlagdown,
    this.showAccountFare,
    this.hideBreak,
    this.hideDecline,
    this.hideRecover,
    this.hideNoPickup,
    this.hidePickup,
    this.hideDropoff,
    this.fareMeter,
    this.disableFareMeterAccountJob,
    this.fareMeterWaitingCharges,
    this.payByCard,
    this.waitingAfterArrival,
    this.sendReceipt,
    this.showPlot,
    this.disablePanicButon,
    this.showNavigation,
    this.showStaNear500Yards,
    this.showFare,
    this.hasCompanyCar,
    this.hidePaymentType,
    this.enableTollCharges,
    this.bookingTimer,
    this.breakTimer,
    this.mobileImeiNumber,
    this.mobileMake,
    this.mobileModel,
    this.mobileSimNetwork,
    this.mobileSimNumber,
    this.mobileNetworkProvider,
    this.mobileDataAllowance,
    this.pdaDeposit,
    this.pdaComments,
    this.createdAt,
    this.updatedAt,
  });

  factory Features.fromJson(Map<String, dynamic> json) => Features(
    id: json["id"],
    driverId: json["driver_id"],
    showCustomerNumber: json["show_customer_number"],
    enableCustomerCall: json["enable_customer_call"],
    enableFlagdown: json["enable_flagdown"],
    showAccountFare: json["show_account_fare"],
    hideBreak: json["hide_break"],
    hideDecline: json["hide_decline"],
    hideRecover: json["hide_recover"],
    hideNoPickup: json["hide_no_pickup"],
    hidePickup: json["hide_pickup"],
    hideDropoff: json["hide_dropoff"],
    fareMeter: json["fare_meter"],
    disableFareMeterAccountJob: json["disable_fare_meter_account_job"],
    fareMeterWaitingCharges: json["fare_meter_waiting_charges"],
    payByCard: json["pay_by_card"],
    waitingAfterArrival: json["waiting_after_arrival"],
    sendReceipt: json["send_receipt"],
    showPlot: json["show_plot"],
    disablePanicButon: json["disable_panic_buton"],
    showNavigation: json["show_navigation"],
    showStaNear500Yards: json["show_sta_near_500_yards"],
    showFare: json["show_fare"],
    hasCompanyCar: json["has_company_car"],
    hidePaymentType: json["hide_payment_type"],
    enableTollCharges: json["enable_toll_charges"],
    bookingTimer: json["booking_timer"],
    breakTimer: json["break_timer"],
    mobileImeiNumber: json["mobile_imei_number"],
    mobileMake: json["mobile_make"],
    mobileModel: json["mobile_model"],
    mobileSimNetwork: json["mobile_sim_network"],
    mobileSimNumber: json["mobile_sim_number"],
    mobileNetworkProvider: json["mobile_network_provider"],
    mobileDataAllowance: json["mobile_data_allowance"],
    pdaDeposit: json["pda_deposit"],
    pdaComments: json["pda_comments"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id": driverId,
    "show_customer_number": showCustomerNumber,
    "enable_customer_call": enableCustomerCall,
    "enable_flagdown": enableFlagdown,
    "show_account_fare": showAccountFare,
    "hide_break": hideBreak,
    "hide_decline": hideDecline,
    "hide_recover": hideRecover,
    "hide_no_pickup": hideNoPickup,
    "hide_pickup": hidePickup,
    "hide_dropoff": hideDropoff,
    "fare_meter": fareMeter,
    "disable_fare_meter_account_job": disableFareMeterAccountJob,
    "fare_meter_waiting_charges": fareMeterWaitingCharges,
    "pay_by_card": payByCard,
    "waiting_after_arrival": waitingAfterArrival,
    "send_receipt": sendReceipt,
    "show_plot": showPlot,
    "disable_panic_buton": disablePanicButon,
    "show_navigation": showNavigation,
    "show_sta_near_500_yards": showStaNear500Yards,
    "show_fare": showFare,
    "has_company_car": hasCompanyCar,
    "hide_payment_type": hidePaymentType,
    "enable_toll_charges": enableTollCharges,
    "booking_timer": bookingTimer,
    "break_timer": breakTimer,
    "mobile_imei_number": mobileImeiNumber,
    "mobile_make": mobileMake,
    "mobile_model": mobileModel,
    "mobile_sim_network": mobileSimNetwork,
    "mobile_sim_number": mobileSimNumber,
    "mobile_network_provider": mobileNetworkProvider,
    "mobile_data_allowance": mobileDataAllowance,
    "pda_deposit": pdaDeposit,
    "pda_comments": pdaComments,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
