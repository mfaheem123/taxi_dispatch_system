// To parse this JSON data, do
//
//     final driverLogsReportListModel = driverLogsReportListModelFromJson(jsonString);

import 'dart:convert';

DriverLogsReportListModel driverLogsReportListModelFromJson(String str) => DriverLogsReportListModel.fromJson(json.decode(str));

String driverLogsReportListModelToJson(DriverLogsReportListModel data) => json.encode(data.toJson());

class DriverLogsReportListModel {
  bool? success;
  int? count;
  List<Booking>? bookings;

  DriverLogsReportListModel({
    this.success,
    this.count,
    this.bookings,
  });

  factory DriverLogsReportListModel.fromJson(Map<String, dynamic> json) => DriverLogsReportListModel(
    success: json["success"],
    count: json["count"],
    bookings: json["bookings"] == null ? [] : List<Booking>.from(json["bookings"]!.map((x) => Booking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "bookings": bookings == null ? [] : List<dynamic>.from(bookings!.map((x) => x.toJson())),
  };
}

class Booking {
  String? id;
  String? referenceNumber;
  int? subsidiaryId;
  int? bookingTypeId;
  int? bookingStatusId;
  int? journeyTypeId;
  dynamic accountId;
  int? customerId;
  int? employeeId;
  String? pickup;
  String? dropoff;
  String? pickupDate;
  String? pickupTime;
  dynamic dropoffDate;
  dynamic dropoffTime;
  String? pickupDoorNumber;
  String? dropoffDoorNumber;
  dynamic pickupPlot;
  dynamic dropoffPlot;
  dynamic pickupLocationTypeId;
  dynamic dropoffLocationTypeId;
  String? pickupLatitude;
  String? pickupLongitude;
  String? dropoffLatitude;
  String? dropoffLongitude;
  List<dynamic>? viapoints;
  List<dynamic>? restrictedDrivers;
  dynamic flightNumber;
  dynamic arrivingFrom;
  int? vehicleTypeId;
  dynamic vehicleId;
  int? driverId;
  dynamic passengers;
  dynamic luggages;
  dynamic handLuggages;
  List<dynamic>? childSeat;
  String? name;
  String? email;
  String? mobile;
  String? telephone;
  dynamic leadTime;
  List<dynamic>? notes;
  dynamic specialInstructions;
  int? paymentTypeId;
  String? companyPrice;
  String? fares;
  String? totalCharges;
  String? parkingCharges;
  String? waitingCharges;
  String? extraDropCharges;
  String? creditCardCharges;
  String? congestionCharges;
  String? miles;
  String? meetAndGreet;
  dynamic department;
  dynamic escortId;
  dynamic orderNumber;
  dynamic bookedBy;
  bool? addReturnFare;
  bool? fareMeterStatus;
  bool? fareMeter;
  bool? quotation;
  bool? quoted;
  bool? dispatch;
  dynamic dispatchAs;
  bool? sms;
  bool? emailflag;
  bool? trash;
  bool? hidden;
  int? multiBookingId;
  dynamic associatedBooking;
  String? invoiceStatus;
  String? commissionStatus;
  bool? commission;
  List<dynamic>? skippedBookings;
  bool? permanent;
  dynamic toggleDriverText;
  dynamic togglePassengerText;
  dynamic cancelledReason;
  String? bookingSource;
  bool? onRoute;
  bool? arrived;
  bool? passengerOnBoard;
  bool? completed;
  bool? controllerCompleted;
  dynamic driverWaitingTime;
  dynamic dispatchedAt;
  String? bookedAt;
  dynamic stripeCustomerId;
  dynamic stripePaymentId;
  dynamic invoiceNumber;
  dynamic initialSubsidiaryId;
  String? createdAt;
  String? updatedAt;
  String? eta;
  bool? fob;
  LogsBookingStatus? bookingStatus;
  LogBookingType? bookingType;
  JourneyType? journeyType;
  Subsidiary? subsidiary;
  VehicleType? vehicleType;
  PaymentType? paymentType;
  Account? account;
  Driver? driver;
  Customer? customer;
  LogsEmployee? employee;
  Airport? airport;

  Booking({
    this.id,
    this.referenceNumber,
    this.subsidiaryId,
    this.bookingTypeId,
    this.bookingStatusId,
    this.journeyTypeId,
    this.accountId,
    this.customerId,
    this.employeeId,
    this.pickup,
    this.dropoff,
    this.pickupDate,
    this.pickupTime,
    this.dropoffDate,
    this.dropoffTime,
    this.pickupDoorNumber,
    this.dropoffDoorNumber,
    this.pickupPlot,
    this.dropoffPlot,
    this.pickupLocationTypeId,
    this.dropoffLocationTypeId,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.viapoints,
    this.restrictedDrivers,
    this.flightNumber,
    this.arrivingFrom,
    this.vehicleTypeId,
    this.vehicleId,
    this.driverId,
    this.passengers,
    this.luggages,
    this.handLuggages,
    this.childSeat,
    this.name,
    this.email,
    this.mobile,
    this.telephone,
    this.leadTime,
    this.notes,
    this.specialInstructions,
    this.paymentTypeId,
    this.companyPrice,
    this.fares,
    this.totalCharges,
    this.parkingCharges,
    this.waitingCharges,
    this.extraDropCharges,
    this.creditCardCharges,
    this.congestionCharges,
    this.miles,
    this.meetAndGreet,
    this.department,
    this.escortId,
    this.orderNumber,
    this.bookedBy,
    this.addReturnFare,
    this.fareMeterStatus,
    this.fareMeter,
    this.quotation,
    this.quoted,
    this.dispatch,
    this.dispatchAs,
    this.sms,
    this.emailflag,
    this.trash,
    this.hidden,
    this.multiBookingId,
    this.associatedBooking,
    this.invoiceStatus,
    this.commissionStatus,
    this.commission,
    this.skippedBookings,
    this.permanent,
    this.toggleDriverText,
    this.togglePassengerText,
    this.cancelledReason,
    this.bookingSource,
    this.onRoute,
    this.arrived,
    this.passengerOnBoard,
    this.completed,
    this.controllerCompleted,
    this.driverWaitingTime,
    this.dispatchedAt,
    this.bookedAt,
    this.stripeCustomerId,
    this.stripePaymentId,
    this.invoiceNumber,
    this.initialSubsidiaryId,
    this.createdAt,
    this.updatedAt,
    this.eta,
    this.fob,
    this.bookingStatus,
    this.bookingType,
    this.journeyType,
    this.subsidiary,
    this.vehicleType,
    this.paymentType,
    this.account,
    this.driver,
    this.customer,
    this.employee,
    this.airport,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    referenceNumber: json["reference_number"],
    subsidiaryId: json["subsidiary_id"],
    bookingTypeId: json["booking_type_id"],
    bookingStatusId: json["booking_status_id"],
    journeyTypeId: json["journey_type_id"],
    accountId: json["account_id"],
    customerId: json["customer_id"],
    employeeId: json["employee_id"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    pickupDate: json["pickup_date"],
    pickupTime: json["pickup_time"],
    dropoffDate: json["dropoff_date"],
    dropoffTime: json["dropoff_time"],
    pickupDoorNumber: json["pickup_door_number"],
    dropoffDoorNumber: json["dropoff_door_number"],
    pickupPlot: json["pickup_plot"],
    dropoffPlot: json["dropoff_plot"],
    pickupLocationTypeId: json["pickup_location_type_id"],
    dropoffLocationTypeId: json["dropoff_location_type_id"],
    pickupLatitude: json["pickup_latitude"],
    pickupLongitude: json["pickup_longitude"],
    dropoffLatitude: json["dropoff_latitude"],
    dropoffLongitude: json["dropoff_longitude"],
    viapoints: json["viapoints"] == null ? [] : List<dynamic>.from(json["viapoints"]!.map((x) => x)),
    restrictedDrivers: json["restricted_drivers"] == null ? [] : List<dynamic>.from(json["restricted_drivers"]!.map((x) => x)),
    flightNumber: json["flight_number"],
    arrivingFrom: json["arriving_from"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleId: json["vehicle_id"],
    driverId: json["driver_id"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    handLuggages: json["hand_luggages"],
    childSeat: json["child_seat"] == null ? [] : List<dynamic>.from(json["child_seat"]!.map((x) => x)),
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    leadTime: json["lead_time"],
    notes: json["notes"] == null ? [] : List<dynamic>.from(json["notes"]!.map((x) => x)),
    specialInstructions: json["special_instructions"],
    paymentTypeId: json["payment_type_id"],
    companyPrice: json["company_price"],
    fares: json["fares"],
    totalCharges: json["total_charges"],
    parkingCharges: json["parking_charges"],
    waitingCharges: json["waiting_charges"],
    extraDropCharges: json["extra_drop_charges"],
    creditCardCharges: json["credit_card_charges"],
    congestionCharges: json["congestion_charges"],
    miles: json["miles"],
    meetAndGreet: json["meet_and_greet"],
    department: json["department"],
    escortId: json["escort_id"],
    orderNumber: json["order_number"],
    bookedBy: json["booked_by"],
    addReturnFare: json["add_return_fare"],
    fareMeterStatus: json["fare_meter_status"],
    fareMeter: json["fare_meter"],
    quotation: json["quotation"],
    quoted: json["quoted"],
    dispatch: json["dispatch"],
    dispatchAs: json["dispatch_as"],
    sms: json["sms"],
    emailflag: json["emailflag"],
    trash: json["trash"],
    hidden: json["hidden"],
    multiBookingId: json["multi_booking_id"],
    associatedBooking: json["associated_booking"],
    invoiceStatus: json["invoice_status"],
    commissionStatus: json["commission_status"],
    commission: json["commission"],
    skippedBookings: json["skipped_bookings"] == null ? [] : List<dynamic>.from(json["skipped_bookings"]!.map((x) => x)),
    permanent: json["permanent"],
    toggleDriverText: json["toggle_driver_text"],
    togglePassengerText: json["toggle_passenger_text"],
    cancelledReason: json["cancelled_reason"],
    bookingSource: json["booking_source"],
    onRoute: json["on_route"],
    arrived: json["arrived"],
    passengerOnBoard: json["passenger_on_board"],
    completed: json["completed"],
    controllerCompleted: json["controller_completed"],
    driverWaitingTime: json["driver_waiting_time"],
    dispatchedAt: json["dispatched_at"],
    bookedAt: json["booked_at"],
    stripeCustomerId: json["stripe_customer_id"],
    stripePaymentId: json["stripe_payment_id"],
    invoiceNumber: json["invoice_number"],
    initialSubsidiaryId: json["initial_subsidiary_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    eta: json["eta"],
    fob: json["fob"],
    bookingStatus: json["booking_status"] == null ? null : LogsBookingStatus.fromJson(json["booking_status"]),
    bookingType: json["booking_type"] == null ? null : LogBookingType.fromJson(json["booking_type"]),
    journeyType: json["journey_type"] == null ? null : JourneyType.fromJson(json["journey_type"]),
    subsidiary: json["subsidiary"] == null ? null : Subsidiary.fromJson(json["subsidiary"]),
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
    paymentType: json["payment_type"] == null ? null : PaymentType.fromJson(json["payment_type"]),
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    employee: json["employee"] == null ? null : LogsEmployee.fromJson(json["employee"]),
    airport: json["airport"] == null ? null : Airport.fromJson(json["airport"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_number": referenceNumber,
    "subsidiary_id": subsidiaryId,
    "booking_type_id": bookingTypeId,
    "booking_status_id": bookingStatusId,
    "journey_type_id": journeyTypeId,
    "account_id": accountId,
    "customer_id": customerId,
    "employee_id": employeeId,
    "pickup": pickup,
    "dropoff": dropoff,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "dropoff_date": dropoffDate,
    "dropoff_time": dropoffTime,
    "pickup_door_number": pickupDoorNumber,
    "dropoff_door_number": dropoffDoorNumber,
    "pickup_plot": pickupPlot,
    "dropoff_plot": dropoffPlot,
    "pickup_location_type_id": pickupLocationTypeId,
    "dropoff_location_type_id": dropoffLocationTypeId,
    "pickup_latitude": pickupLatitude,
    "pickup_longitude": pickupLongitude,
    "dropoff_latitude": dropoffLatitude,
    "dropoff_longitude": dropoffLongitude,
    "viapoints": viapoints == null ? [] : List<dynamic>.from(viapoints!.map((x) => x)),
    "restricted_drivers": restrictedDrivers == null ? [] : List<dynamic>.from(restrictedDrivers!.map((x) => x)),
    "flight_number": flightNumber,
    "arriving_from": arrivingFrom,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_id": vehicleId,
    "driver_id": driverId,
    "passengers": passengers,
    "luggages": luggages,
    "hand_luggages": handLuggages,
    "child_seat": childSeat == null ? [] : List<dynamic>.from(childSeat!.map((x) => x)),
    "name": name,
    "email": email,
    "mobile": mobile,
    "telephone": telephone,
    "lead_time": leadTime,
    "notes": notes == null ? [] : List<dynamic>.from(notes!.map((x) => x)),
    "special_instructions": specialInstructions,
    "payment_type_id": paymentTypeId,
    "company_price": companyPrice,
    "fares": fares,
    "total_charges": totalCharges,
    "parking_charges": parkingCharges,
    "waiting_charges": waitingCharges,
    "extra_drop_charges": extraDropCharges,
    "credit_card_charges": creditCardCharges,
    "congestion_charges": congestionCharges,
    "miles": miles,
    "meet_and_greet": meetAndGreet,
    "department": department,
    "escort_id": escortId,
    "order_number": orderNumber,
    "booked_by": bookedBy,
    "add_return_fare": addReturnFare,
    "fare_meter_status": fareMeterStatus,
    "fare_meter": fareMeter,
    "quotation": quotation,
    "quoted": quoted,
    "dispatch": dispatch,
    "dispatch_as": dispatchAs,
    "sms": sms,
    "emailflag": emailflag,
    "trash": trash,
    "hidden": hidden,
    "multi_booking_id": multiBookingId,
    "associated_booking": associatedBooking,
    "invoice_status": invoiceStatus,
    "commission_status": commissionStatus,
    "commission": commission,
    "skipped_bookings": skippedBookings == null ? [] : List<dynamic>.from(skippedBookings!.map((x) => x)),
    "permanent": permanent,
    "toggle_driver_text": toggleDriverText,
    "toggle_passenger_text": togglePassengerText,
    "cancelled_reason": cancelledReason,
    "booking_source": bookingSource,
    "on_route": onRoute,
    "arrived": arrived,
    "passenger_on_board": passengerOnBoard,
    "completed": completed,
    "controller_completed": controllerCompleted,
    "driver_waiting_time": driverWaitingTime,
    "dispatched_at": dispatchedAt,
    "booked_at": bookedAt,
    "stripe_customer_id": stripeCustomerId,
    "stripe_payment_id": stripePaymentId,
    "invoice_number": invoiceNumber,
    "initial_subsidiary_id": initialSubsidiaryId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "eta": eta,
    "fob": fob,
    "booking_status": bookingStatus?.toJson(),
    "booking_type": bookingType?.toJson(),
    "journey_type": journeyType?.toJson(),
    "subsidiary": subsidiary?.toJson(),
    "vehicle_type": vehicleType?.toJson(),
    "payment_type": paymentType?.toJson(),
    "account": account?.toJson(),
    "driver": driver?.toJson(),
    "customer": customer?.toJson(),
    "employee": employee?.toJson(),
    "airport": airport?.toJson(),
  };
}

class Account {
  dynamic id;
  dynamic name;
  dynamic backgroundColor;
  dynamic foregroundColor;
  dynamic hasVat;
  dynamic bankInformation;
  dynamic fareController;
  dynamic accountFeesType;
  dynamic accountFees;
  dynamic accountFeesVat;

  Account({
    this.id,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
    this.hasVat,
    this.bankInformation,
    this.fareController,
    this.accountFeesType,
    this.accountFees,
    this.accountFeesVat,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    name: json["name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    hasVat: json["has_vat"],
    bankInformation: json["bank_information"],
    fareController: json["fare_controller"],
    accountFeesType: json["account_fees_type"],
    accountFees: json["account_fees"],
    accountFeesVat: json["account_fees_vat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "has_vat": hasVat,
    "bank_information": bankInformation,
    "fare_controller": fareController,
    "account_fees_type": accountFeesType,
    "account_fees": accountFees,
    "account_fees_vat": accountFeesVat,
  };
}

class Airport {
  Dropoff? pickup;
  Dropoff? dropoff;

  Airport({
    this.pickup,
    this.dropoff,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
    pickup: json["pickup"] == null ? null : Dropoff.fromJson(json["pickup"]),
    dropoff: json["dropoff"] == null ? null : Dropoff.fromJson(json["dropoff"]),
  );

  Map<String, dynamic> toJson() => {
    "pickup": pickup?.toJson(),
    "dropoff": dropoff?.toJson(),
  };
}

class Dropoff {
  dynamic id;
  dynamic name;
  LocationType? locationType;

  Dropoff({
    this.id,
    this.name,
    this.locationType,
  });

  factory Dropoff.fromJson(Map<String, dynamic> json) => Dropoff(
    id: json["id"],
    name: json["name"],
    locationType: json["location_type"] == null ? null : LocationType.fromJson(json["location_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type": locationType?.toJson(),
  };
}

class LocationType {
  dynamic id;
  dynamic name;
  dynamic backgroundColor;
  dynamic foregroundColor;

  LocationType({
    this.id,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) => LocationType(
    id: json["id"],
    name: json["name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class LogsBookingStatus {
  String? bookingStatus;

  LogsBookingStatus({
    this.bookingStatus,
  });

  factory LogsBookingStatus.fromJson(Map<String, dynamic> json) => LogsBookingStatus(
    bookingStatus: json["booking_status"],
  );

  Map<String, dynamic> toJson() => {
    "booking_status": bookingStatus,
  };
}

class LogBookingType {
  String? bookingType;

  LogBookingType({
    this.bookingType,
  });

  factory LogBookingType.fromJson(Map<String, dynamic> json) => LogBookingType(
    bookingType: json["booking_type"],
  );

  Map<String, dynamic> toJson() => {
    "booking_type": bookingType,
  };
}

class Customer {
  dynamic doorNumber;
  dynamic address1;
  dynamic address2;
  dynamic blacklist;

  Customer({
    this.doorNumber,
    this.address1,
    this.address2,
    this.blacklist,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    doorNumber: json["door_number"],
    address1: json["address1"],
    address2: json["address2"],
    blacklist: json["blacklist"],
  );

  Map<String, dynamic> toJson() => {
    "door_number": doorNumber,
    "address1": address1,
    "address2": address2,
    "blacklist": blacklist,
  };
}

class Driver {
  int? id;
  String? username;
  String? name;
  dynamic mobileDeviceId;
  dynamic phcVehicleNumber;
  dynamic phcDriverNumber;
  int? vehicleId;
  int? driverCommission;
  String? sessionStatus;
  Vehicle? vehicle;

  Driver({
    this.id,
    this.username,
    this.name,
    this.mobileDeviceId,
    this.phcVehicleNumber,
    this.phcDriverNumber,
    this.vehicleId,
    this.driverCommission,
    this.sessionStatus,
    this.vehicle,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    mobileDeviceId: json["mobile_device_id"],
    phcVehicleNumber: json["phc_vehicle_number"],
    phcDriverNumber: json["phc_driver_number"],
    vehicleId: json["vehicle_id"],
    driverCommission: json["driver_commission"],
    sessionStatus: json["session_status"],
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "mobile_device_id": mobileDeviceId,
    "phc_vehicle_number": phcVehicleNumber,
    "phc_driver_number": phcDriverNumber,
    "vehicle_id": vehicleId,
    "driver_commission": driverCommission,
    "session_status": sessionStatus,
    "vehicle": vehicle?.toJson(),
  };
}

class Vehicle {
  String? make;
  String? model;
  String? color;
  String? vehicleNumber;

  Vehicle({
    this.make,
    this.model,
    this.color,
    this.vehicleNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    make: json["make"],
    model: json["model"],
    color: json["color"],
    vehicleNumber: json["vehicle_number"],
  );

  Map<String, dynamic> toJson() => {
    "make": make,
    "model": model,
    "color": color,
    "vehicle_number": vehicleNumber,
  };
}

class LogsEmployee {
  String? username;
  int? roleId;

  LogsEmployee({
    this.username,
    this.roleId,
  });

  factory LogsEmployee.fromJson(Map<String, dynamic> json) => LogsEmployee(
    username: json["username"],
    roleId: json["role_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "role_id": roleId,
  };
}

class JourneyType {
  String? journeyType;

  JourneyType({
    this.journeyType,
  });

  factory JourneyType.fromJson(Map<String, dynamic> json) => JourneyType(
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "journey_type": journeyType,
  };
}

class PaymentType {
  int? id;
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  PaymentType({
    this.id,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
    id: json["id"],
    name: json["name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}

class Subsidiary {
  int? id;
  String? name;
  String? telephoneNumber;

  Subsidiary({
    this.id,
    this.name,
    this.telephoneNumber,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    id: json["id"],
    name: json["name"],
    telephoneNumber: json["telephone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "telephone_number": telephoneNumber,
  };
}

class VehicleType {
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  VehicleType({
    this.name,
    this.backgroundColor,
    this.foregroundColor,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    name: json["name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
  };
}
