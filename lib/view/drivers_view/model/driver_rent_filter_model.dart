// To parse this JSON data, do
//
//     final driverRentFilterModel = driverRentFilterModelFromJson(jsonString);

import 'dart:convert';

DriverRentFilterModel driverRentFilterModelFromJson(String str) => DriverRentFilterModel.fromJson(json.decode(str));

String driverRentFilterModelToJson(DriverRentFilterModel data) => json.encode(data.toJson());

class DriverRentFilterModel {
  bool success;
  int count;
  List<RentBooking> bookings;

  DriverRentFilterModel({
    required this.success,
    required this.count,
    required this.bookings,
  });

  factory DriverRentFilterModel.fromJson(Map<String, dynamic> json) => DriverRentFilterModel(
    success: json["success"],
    count: json["count"],
    bookings: List<RentBooking>.from(json["bookings"].map((x) => RentBooking.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "bookings": List<dynamic>.from(bookings.map((x) => x.toJson())),
  };
}

class RentBooking {
  String id;
  String referenceNumber;
  int subsidiaryId;
  int bookingTypeId;
  int bookingStatusId;
  int journeyTypeId;
  dynamic accountId;
  int customerId;
  int employeeId;
  String pickup;
  String dropoff;
  String pickupDate;
  String pickupTime;
  dynamic dropoffDate;
  dynamic dropoffTime;
  String pickupDoorNumber;
  String dropoffDoorNumber;
  dynamic pickupPlot;
  dynamic dropoffPlot;
  dynamic pickupLocationTypeId;
  dynamic dropoffLocationTypeId;
  String pickupLatitude;
  String pickupLongitude;
  String dropoffLatitude;
  String dropoffLongitude;
  List<dynamic> viapoints;
  List<dynamic> restrictedDrivers;
  dynamic flightNumber;
  dynamic arrivingFrom;
  int vehicleTypeId;
  dynamic vehicleId;
  int driverId;
  dynamic passengers;
  dynamic luggages;
  dynamic handLuggages;
  List<dynamic> childSeat;
  String name;
  String email;
  String mobile;
  String telephone;
  dynamic leadTime;
  List<dynamic> notes;
  dynamic specialInstructions;
  int paymentTypeId;
  String companyPrice;
  String fares;
  String totalCharges;
  String parkingCharges;
  String waitingCharges;
  String extraDropCharges;
  String creditCardCharges;
  String congestionCharges;
  String miles;
  String meetAndGreet;
  dynamic department;
  dynamic escortId;
  dynamic orderNumber;
  dynamic bookedBy;
  bool addReturnFare;
  bool fareMeterStatus;
  bool fareMeter;
  bool quotation;
  bool quoted;
  bool dispatch;
  dynamic dispatchAs;
  bool sms;
  bool emailflag;
  bool trash;
  bool hidden;
  int multiBookingId;
  dynamic associatedBooking;
  String invoiceStatus;
  String commissionStatus;
  bool commission;
  List<dynamic> skippedBookings;
  bool permanent;
  dynamic toggleDriverText;
  dynamic togglePassengerText;
  dynamic cancelledReason;
  String bookingSource;
  bool onRoute;
  bool arrived;
  bool passengerOnBoard;
  bool completed;
  bool controllerCompleted;
  dynamic driverWaitingTime;
  dynamic dispatchedAt;
  String bookedAt;
  dynamic stripeCustomerId;
  dynamic stripePaymentId;
  dynamic invoiceNumber;
  dynamic initialSubsidiaryId;
  String createdAt;
  String updatedAt;
  String eta;
  BookingStatus bookingStatus;
  BookingType bookingType;
  JourneyType journeyType;
  Subsidiary subsidiary;
  VehicleType vehicleType;
  PaymentType paymentType;
  Account account;
  RentFilterDriver driver;
  Customer customer;
  Employee employee;
  Airport airport;

  RentBooking({
    required this.id,
    required this.referenceNumber,
    required this.subsidiaryId,
    required this.bookingTypeId,
    required this.bookingStatusId,
    required this.journeyTypeId,
    required this.accountId,
    required this.customerId,
    required this.employeeId,
    required this.pickup,
    required this.dropoff,
    required this.pickupDate,
    required this.pickupTime,
    required this.dropoffDate,
    required this.dropoffTime,
    required this.pickupDoorNumber,
    required this.dropoffDoorNumber,
    required this.pickupPlot,
    required this.dropoffPlot,
    required this.pickupLocationTypeId,
    required this.dropoffLocationTypeId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.viapoints,
    required this.restrictedDrivers,
    required this.flightNumber,
    required this.arrivingFrom,
    required this.vehicleTypeId,
    required this.vehicleId,
    required this.driverId,
    required this.passengers,
    required this.luggages,
    required this.handLuggages,
    required this.childSeat,
    required this.name,
    required this.email,
    required this.mobile,
    required this.telephone,
    required this.leadTime,
    required this.notes,
    required this.specialInstructions,
    required this.paymentTypeId,
    required this.companyPrice,
    required this.fares,
    required this.totalCharges,
    required this.parkingCharges,
    required this.waitingCharges,
    required this.extraDropCharges,
    required this.creditCardCharges,
    required this.congestionCharges,
    required this.miles,
    required this.meetAndGreet,
    required this.department,
    required this.escortId,
    required this.orderNumber,
    required this.bookedBy,
    required this.addReturnFare,
    required this.fareMeterStatus,
    required this.fareMeter,
    required this.quotation,
    required this.quoted,
    required this.dispatch,
    required this.dispatchAs,
    required this.sms,
    required this.emailflag,
    required this.trash,
    required this.hidden,
    required this.multiBookingId,
    required this.associatedBooking,
    required this.invoiceStatus,
    required this.commissionStatus,
    required this.commission,
    required this.skippedBookings,
    required this.permanent,
    required this.toggleDriverText,
    required this.togglePassengerText,
    required this.cancelledReason,
    required this.bookingSource,
    required this.onRoute,
    required this.arrived,
    required this.passengerOnBoard,
    required this.completed,
    required this.controllerCompleted,
    required this.driverWaitingTime,
    required this.dispatchedAt,
    required this.bookedAt,
    required this.stripeCustomerId,
    required this.stripePaymentId,
    required this.invoiceNumber,
    required this.initialSubsidiaryId,
    required this.createdAt,
    required this.updatedAt,
    required this.eta,
    required this.bookingStatus,
    required this.bookingType,
    required this.journeyType,
    required this.subsidiary,
    required this.vehicleType,
    required this.paymentType,
    required this.account,
    required this.driver,
    required this.customer,
    required this.employee,
    required this.airport,
  });

  factory RentBooking.fromJson(Map<String, dynamic> json) => RentBooking(
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
    viapoints: List<dynamic>.from(json["viapoints"].map((x) => x)),
    restrictedDrivers: List<dynamic>.from(json["restricted_drivers"].map((x) => x)),
    flightNumber: json["flight_number"],
    arrivingFrom: json["arriving_from"],
    vehicleTypeId: json["vehicle_type_id"],
    vehicleId: json["vehicle_id"],
    driverId: json["driver_id"],
    passengers: json["passengers"],
    luggages: json["luggages"],
    handLuggages: json["hand_luggages"],
    childSeat: List<dynamic>.from(json["child_seat"].map((x) => x)),
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    leadTime: json["lead_time"],
    notes: List<dynamic>.from(json["notes"].map((x) => x)),
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
    skippedBookings: List<dynamic>.from(json["skipped_bookings"].map((x) => x)),
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
    bookingStatus: BookingStatus.fromJson(json["booking_status"]),
    bookingType: BookingType.fromJson(json["booking_type"]),
    journeyType: JourneyType.fromJson(json["journey_type"]),
    subsidiary: Subsidiary.fromJson(json["subsidiary"]),
    vehicleType: VehicleType.fromJson(json["vehicle_type"]),
    paymentType: PaymentType.fromJson(json["payment_type"]),
    account: Account.fromJson(json["account"]),
    driver: RentFilterDriver.fromJson(json["driver"]),
    customer: Customer.fromJson(json["customer"]),
    employee: Employee.fromJson(json["employee"]),
    airport: Airport.fromJson(json["airport"]),
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
    "viapoints": List<dynamic>.from(viapoints.map((x) => x)),
    "restricted_drivers": List<dynamic>.from(restrictedDrivers.map((x) => x)),
    "flight_number": flightNumber,
    "arriving_from": arrivingFrom,
    "vehicle_type_id": vehicleTypeId,
    "vehicle_id": vehicleId,
    "driver_id": driverId,
    "passengers": passengers,
    "luggages": luggages,
    "hand_luggages": handLuggages,
    "child_seat": List<dynamic>.from(childSeat.map((x) => x)),
    "name": name,
    "email": email,
    "mobile": mobile,
    "telephone": telephone,
    "lead_time": leadTime,
    "notes": List<dynamic>.from(notes.map((x) => x)),
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
    "skipped_bookings": List<dynamic>.from(skippedBookings.map((x) => x)),
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
    "booking_status": bookingStatus.toJson(),
    "booking_type": bookingType.toJson(),
    "journey_type": journeyType.toJson(),
    "subsidiary": subsidiary.toJson(),
    "vehicle_type": vehicleType.toJson(),
    "payment_type": paymentType.toJson(),
    "account": account.toJson(),
    "driver": driver.toJson(),
    "customer": customer.toJson(),
    "employee": employee.toJson(),
    "airport": airport.toJson(),
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
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.hasVat,
    required this.bankInformation,
    required this.fareController,
    required this.accountFeesType,
    required this.accountFees,
    required this.accountFeesVat,
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
  Pickup pickup;
  Dropoff dropoff;

  Airport({
    required this.pickup,
    required this.dropoff,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
    pickup: Pickup.fromJson(json["pickup"]),
    dropoff: Dropoff.fromJson(json["dropoff"]),
  );

  Map<String, dynamic> toJson() => {
    "pickup": pickup.toJson(),
    "dropoff": dropoff.toJson(),
  };
}

class Dropoff {
  dynamic id;
  dynamic name;
  DropoffLocationType locationType;

  Dropoff({
    required this.id,
    required this.name,
    required this.locationType,
  });

  factory Dropoff.fromJson(Map<String, dynamic> json) => Dropoff(
    id: json["id"],
    name: json["name"],
    locationType: DropoffLocationType.fromJson(json["location_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type": locationType.toJson(),
  };
}

class DropoffLocationType {
  dynamic id;
  dynamic name;
  dynamic backgroundColor;
  dynamic foregroundColor;

  DropoffLocationType({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory DropoffLocationType.fromJson(Map<String, dynamic> json) => DropoffLocationType(
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

class Pickup {
  int? id;
  String? name;
  PickupLocationType locationType;

  Pickup({
    required this.id,
    required this.name,
    required this.locationType,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    id: json["id"],
    name: json["name"],
    locationType: PickupLocationType.fromJson(json["location_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type": locationType.toJson(),
  };
}

class PickupLocationType {
  int? id;
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  PickupLocationType({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory PickupLocationType.fromJson(Map<String, dynamic> json) => PickupLocationType(
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

class BookingStatus {
  String bookingStatus;

  BookingStatus({
    required this.bookingStatus,
  });

  factory BookingStatus.fromJson(Map<String, dynamic> json) => BookingStatus(
    bookingStatus: json["booking_status"],
  );

  Map<String, dynamic> toJson() => {
    "booking_status": bookingStatus,
  };
}

class BookingType {
  String bookingType;

  BookingType({
    required this.bookingType,
  });

  factory BookingType.fromJson(Map<String, dynamic> json) => BookingType(
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
    required this.doorNumber,
    required this.address1,
    required this.address2,
    required this.blacklist,
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

class RentFilterDriver {
  int id;
  String username;
  String name;
  dynamic mobileDeviceId;
  String phcVehicleNumber;
  String phcDriverNumber;
  int vehicleId;
  dynamic driverCommission;
  dynamic sessionStatus;
  Vehicle vehicle;

  RentFilterDriver({
    required this.id,
    required this.username,
    required this.name,
    required this.mobileDeviceId,
    required this.phcVehicleNumber,
    required this.phcDriverNumber,
    required this.vehicleId,
    required this.driverCommission,
    required this.sessionStatus,
    required this.vehicle,
  });

  factory RentFilterDriver.fromJson(Map<String, dynamic> json) => RentFilterDriver(
    id: json["id"],
    username: json["username"],
    name: json["name"],
    mobileDeviceId: json["mobile_device_id"],
    phcVehicleNumber: json["phc_vehicle_number"],
    phcDriverNumber: json["phc_driver_number"],
    vehicleId: json["vehicle_id"],
    driverCommission: json["driver_commission"],
    sessionStatus: json["session_status"],
    vehicle: Vehicle.fromJson(json["vehicle"]),
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
    "vehicle": vehicle.toJson(),
  };
}

class Vehicle {
  String make;
  String model;
  String color;
  String vehicleNumber;

  Vehicle({
    required this.make,
    required this.model,
    required this.color,
    required this.vehicleNumber,
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

class Employee {
  String username;
  int roleId;

  Employee({
    required this.username,
    required this.roleId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    username: json["username"],
    roleId: json["role_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "role_id": roleId,
  };
}

class JourneyType {
  String journeyType;

  JourneyType({
    required this.journeyType,
  });

  factory JourneyType.fromJson(Map<String, dynamic> json) => JourneyType(
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "journey_type": journeyType,
  };
}

class PaymentType {
  int id;
  String name;
  String backgroundColor;
  String foregroundColor;

  PaymentType({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
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
  int id;
  String name;
  String telephoneNumber;

  Subsidiary({
    required this.id,
    required this.name,
    required this.telephoneNumber,
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
  String name;
  String backgroundColor;
  String foregroundColor;

  VehicleType({
    required this.name,
    required this.backgroundColor,
    required this.foregroundColor,
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
