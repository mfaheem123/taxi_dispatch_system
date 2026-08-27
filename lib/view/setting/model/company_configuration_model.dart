// To parse this JSON data, do
//
//     final companyConfigurationModel = companyConfigurationModelFromJson(jsonString);

import 'dart:convert';

CompanyConfigurationModel companyConfigurationModelFromJson(String str) => CompanyConfigurationModel.fromJson(json.decode(str));

String companyConfigurationModelToJson(CompanyConfigurationModel data) => json.encode(data.toJson());

class CompanyConfigurationModel {
  bool? status;
  CompanyConfiguration? companyConfiguration;

  CompanyConfigurationModel({
    this.status,
    this.companyConfiguration,
  });

  factory CompanyConfigurationModel.fromJson(Map<String, dynamic> json) => CompanyConfigurationModel(
    status: json["status"],
    companyConfiguration: json["company_configuration"] == null ? null : CompanyConfiguration.fromJson(json["company_configuration"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "company_configuration": companyConfiguration?.toJson(),
  };
}

class CompanyConfiguration {
  int? id;
  int? subsidiaryId;
  String? emailUsername;
  String? emailPassword;
  String? emailService;
  String? emailHost;
  String? emailPort;
  String? emailCc;
  bool? emailSecureConnection;
  bool? toggleAcceptEmail;
  bool? toggleDeclineEmail;
  String? mapService;
  String? mapApiKey;
  String? mapDistanceFactor;
  String? mapTimeFactor;
  bool? toggleMapControls;
  String? voipService;
  String? voipStatus;
  String? companyDateFormat;
  String? companyTimeFormat;
  String? companyTimeZone;
  String? smsHost;
  String? smsPort;
  int? tabBookings;
  int? tabPreBookings;
  int? tabRecentBookings;
  String? discountOnewayBooking;
  String? discountReturnBooking;
  String? discountWaitAndReturnBooking;
  int? bookingExpiryNotice;
  int? airportBookingExpiryNotice;
  int? accountBookingExpiryNotice;
  int? driverExpiryNotice;
  String? airportPickupCharges;
  String? creditCardCharges;
  bool? enableBookingQuotation;
  bool? webBookerConfirmation;
  bool? customerAppConfirmation;
  bool? enableBookingText;
  int? bookingTextMinutes;
  bool? enableCustomerText;
  bool? enableNotification;
  bool? enableBookingDueNotification;
  int? roundoffFares;
  bool? enablePeakFactors;
  String? stripePublicKey;
  String? stripeSecretKey;
  String? endpointKey;
  String? invoiceEndpointKey;
  String? smsUsername;
  String? smsPassword;
  String? smsService;
  String? smsServiceIp;
  String? amountType;
  String? recordingToken;
  bool? smsIncoming;
  bool? enableDeadMileage;
  bool? callFeature;
  String? baseAddress;
  String? deadMileageMiles;
  String? deadMileageMethods;
  String? flightTrackerApi;
  int? huntGroup;
  String? serviceApiKey;
  String? mainApiKey;
  String? yestechCallUrl;
  String? yestechCallToken;
  String? createdAt;
  String? updatedAt;
  int? companyId;
  String? subsidiaryName;

  CompanyConfiguration({
    this.id,
    this.subsidiaryId,
    this.emailUsername,
    this.emailPassword,
    this.emailService,
    this.emailHost,
    this.emailPort,
    this.emailCc,
    this.emailSecureConnection,
    this.toggleAcceptEmail,
    this.toggleDeclineEmail,
    this.mapService,
    this.mapApiKey,
    this.mapDistanceFactor,
    this.mapTimeFactor,
    this.toggleMapControls,
    this.voipService,
    this.voipStatus,
    this.companyDateFormat,
    this.companyTimeFormat,
    this.companyTimeZone,
    this.smsHost,
    this.smsPort,
    this.tabBookings,
    this.tabPreBookings,
    this.tabRecentBookings,
    this.discountOnewayBooking,
    this.discountReturnBooking,
    this.discountWaitAndReturnBooking,
    this.bookingExpiryNotice,
    this.airportBookingExpiryNotice,
    this.accountBookingExpiryNotice,
    this.driverExpiryNotice,
    this.airportPickupCharges,
    this.creditCardCharges,
    this.enableBookingQuotation,
    this.webBookerConfirmation,
    this.customerAppConfirmation,
    this.enableBookingText,
    this.bookingTextMinutes,
    this.enableCustomerText,
    this.enableNotification,
    this.enableBookingDueNotification,
    this.roundoffFares,
    this.enablePeakFactors,
    this.stripePublicKey,
    this.stripeSecretKey,
    this.endpointKey,
    this.invoiceEndpointKey,
    this.smsUsername,
    this.smsPassword,
    this.smsService,
    this.smsServiceIp,
    this.amountType,
    this.recordingToken,
    this.smsIncoming,
    this.enableDeadMileage,
    this.callFeature,
    this.baseAddress,
    this.deadMileageMiles,
    this.deadMileageMethods,
    this.flightTrackerApi,
    this.huntGroup,
    this.serviceApiKey,
    this.mainApiKey,
    this.yestechCallUrl,
    this.yestechCallToken,
    this.createdAt,
    this.updatedAt,
    this.companyId,
    this.subsidiaryName,
  });

  factory CompanyConfiguration.fromJson(Map<String, dynamic> json) => CompanyConfiguration(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    emailUsername: json["email_username"],
    emailPassword: json["email_password"],
    emailService: json["email_service"],
    emailHost: json["email_host"],
    emailPort: json["email_port"],
    emailCc: json["email_cc"],
    emailSecureConnection: json["email_secure_connection"],
    toggleAcceptEmail: json["toggle_accept_email"],
    toggleDeclineEmail: json["toggle_decline_email"],
    mapService: json["map_service"],
    mapApiKey: json["map_api_key"],
    mapDistanceFactor: json["map_distance_factor"],
    mapTimeFactor: json["map_time_factor"],
    toggleMapControls: json["toggle_map_controls"],
    voipService: json["voip_service"],
    voipStatus: json["voip_status"],
    companyDateFormat: json["company_date_format"],
    companyTimeFormat: json["company_time_format"],
    companyTimeZone: json["company_time_zone"],
    smsHost: json["sms_host"],
    smsPort: json["sms_port"],
    tabBookings: json["tab_bookings"],
    tabPreBookings: json["tab_pre_bookings"],
    tabRecentBookings: json["tab_recent_bookings"],
    discountOnewayBooking: json["discount_oneway_booking"],
    discountReturnBooking: json["discount_return_booking"],
    discountWaitAndReturnBooking: json["discount_wait_and_return_booking"],
    bookingExpiryNotice: json["booking_expiry_notice"],
    airportBookingExpiryNotice: json["airport_booking_expiry_notice"],
    accountBookingExpiryNotice: json["account_booking_expiry_notice"],
    driverExpiryNotice: json["driver_expiry_notice"],
    airportPickupCharges: json["airport_pickup_charges"],
    creditCardCharges: json["credit_card_charges"],
    enableBookingQuotation: json["enable_booking_quotation"],
    webBookerConfirmation: json["web_booker_confirmation"],
    customerAppConfirmation: json["customer_app_confirmation"],
    enableBookingText: json["enable_booking_text"],
    bookingTextMinutes: json["booking_text_minutes"],
    enableCustomerText: json["enable_customer_text"],
    enableNotification: json["enable_notification"],
    enableBookingDueNotification: json["enable_booking_due_notification"],
    roundoffFares: json["roundoff_fares"],
    enablePeakFactors: json["enable_peak_factors"],
    stripePublicKey: json["stripe_public_key"],
    stripeSecretKey: json["stripe_secret_key"],
    endpointKey: json["endpoint_key"],
    invoiceEndpointKey: json["invoice_endpoint_key"],
    smsUsername: json["sms_username"],
    smsPassword: json["sms_password"],
    smsService: json["sms_service"],
    smsServiceIp: json["sms_service_ip"],
    amountType: json["amount_type"],
    recordingToken: json["recording_token"],
    smsIncoming: json["sms_incoming"],
    enableDeadMileage: json["enable_dead_mileage"],
    callFeature: json["call_feature"],
    baseAddress: json["base_address"],
    deadMileageMiles: json["dead_mileage_miles"],
    deadMileageMethods: json["dead_mileage_methods"],
    flightTrackerApi: json["flight_tracker_api"],
    huntGroup: json["hunt_group"],
    serviceApiKey: json["service_api_key"],
    mainApiKey: json["main_api_key"],
    yestechCallUrl: json["yestech_call_url"],
    yestechCallToken: json["yestech_call_token"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    companyId: json["company_id"],
    subsidiaryName: json["subsidiary_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "email_username": emailUsername,
    "email_password": emailPassword,
    "email_service": emailService,
    "email_host": emailHost,
    "email_port": emailPort,
    "email_cc": emailCc,
    "email_secure_connection": emailSecureConnection,
    "toggle_accept_email": toggleAcceptEmail,
    "toggle_decline_email": toggleDeclineEmail,
    "map_service": mapService,
    "map_api_key": mapApiKey,
    "map_distance_factor": mapDistanceFactor,
    "map_time_factor": mapTimeFactor,
    "toggle_map_controls": toggleMapControls,
    "voip_service": voipService,
    "voip_status": voipStatus,
    "company_date_format": companyDateFormat,
    "company_time_format": companyTimeFormat,
    "company_time_zone": companyTimeZone,
    "sms_host": smsHost,
    "sms_port": smsPort,
    "tab_bookings": tabBookings,
    "tab_pre_bookings": tabPreBookings,
    "tab_recent_bookings": tabRecentBookings,
    "discount_oneway_booking": discountOnewayBooking,
    "discount_return_booking": discountReturnBooking,
    "discount_wait_and_return_booking": discountWaitAndReturnBooking,
    "booking_expiry_notice": bookingExpiryNotice,
    "airport_booking_expiry_notice": airportBookingExpiryNotice,
    "account_booking_expiry_notice": accountBookingExpiryNotice,
    "driver_expiry_notice": driverExpiryNotice,
    "airport_pickup_charges": airportPickupCharges,
    "credit_card_charges": creditCardCharges,
    "enable_booking_quotation": enableBookingQuotation,
    "web_booker_confirmation": webBookerConfirmation,
    "customer_app_confirmation": customerAppConfirmation,
    "enable_booking_text": enableBookingText,
    "booking_text_minutes": bookingTextMinutes,
    "enable_customer_text": enableCustomerText,
    "enable_notification": enableNotification,
    "enable_booking_due_notification": enableBookingDueNotification,
    "roundoff_fares": roundoffFares,
    "enable_peak_factors": enablePeakFactors,
    "stripe_public_key": stripePublicKey,
    "stripe_secret_key": stripeSecretKey,
    "endpoint_key": endpointKey,
    "invoice_endpoint_key": invoiceEndpointKey,
    "sms_username": smsUsername,
    "sms_password": smsPassword,
    "sms_service": smsService,
    "sms_service_ip": smsServiceIp,
    "amount_type": amountType,
    "recording_token": recordingToken,
    "sms_incoming": smsIncoming,
    "enable_dead_mileage": enableDeadMileage,
    "call_feature": callFeature,
    "base_address": baseAddress,
    "dead_mileage_miles": deadMileageMiles,
    "dead_mileage_methods": deadMileageMethods,
    "flight_tracker_api": flightTrackerApi,
    "hunt_group": huntGroup,
    "service_api_key": serviceApiKey,
    "main_api_key": mainApiKey,
    "yestech_call_url": yestechCallUrl,
    "yestech_call_token": yestechCallToken,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "company_id": companyId,
    "subsidiary_name": subsidiaryName,
  };
}
