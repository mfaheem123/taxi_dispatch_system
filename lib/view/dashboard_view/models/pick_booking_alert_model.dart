String? _parseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List) {
    if (value.isEmpty) return null;
    return value.map((e) {
      if (e is Map) {
        return e['address'] ?? e['via'] ?? e['name'] ?? e['value'] ?? e['viapoint'] ?? e.toString();
      }
      return e.toString();
    }).join(', ');
  }
  return value.toString();
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool? _parseBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return null;
}

class PickBookingModel {
  bool? status;
  int? count;
  List<Bookings>? bookings;

  PickBookingModel({this.status, this.count, this.bookings});

  PickBookingModel.fromJson(Map<String, dynamic> json) {
    status = _parseBool(json['status']);
    count = _parseInt(json['count']);
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      if (json['bookings'] is List) {
        for (var v in (json['bookings'] as List)) {
          if (v is Map<String, dynamic>) {
            bookings!.add(Bookings.fromJson(v));
          } else if (v is Map) {
            bookings!.add(Bookings.fromJson(Map<String, dynamic>.from(v)));
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookings {
  String? id;
  String? referenceNumber;
  int? subsidiaryId;
  int? bookingTypeId;
  int? bookingStatusId;
  int? journeyTypeId;
  int? accountId;
  int? customerId;
  int? employeeId;
  String? pickup;
  String? dropoff;
  String? pickupDate;
  String? pickupTime;
  String? dropoffDate;
  String? dropoffTime;
  String? pickupDoorNumber;
  String? dropoffDoorNumber;
  String? pickupPlot;
  String? dropoffPlot;
  int? pickupLocationTypeId;
  int? dropoffLocationTypeId;
  String? pickupLatitude;
  String? pickupLongitude;
  String? dropoffLatitude;
  String? dropoffLongitude;
  String? viapoints;
  dynamic via;
  String? restrictedDrivers;
  String? flightNumber;
  String? arrivingFrom;
  int? vehicleTypeId;
  int? vehicleId;
  int? driverId;
  int? passengers;
  int? luggages;
  int? handLuggages;
  String? childSeat;
  String? name;
  String? email;
  String? mobile;
  String? telephone;
  String? leadTime;
  String? notes;
  String? specialInstructions;
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
  String? department;
  int? escortId;
  String? orderNumber;
  String? bookedBy;
  bool? addReturnFare;
  bool? fareMeterStatus;
  bool? fareMeter;
  bool? quotation;
  bool? quoted;
  bool? dispatch;
  String? dispatchAs;
  bool? sms;
  bool? emailflag;
  bool? trash;
  bool? hidden;
  int? multiBookingId;
  dynamic associatedBooking;
  String? invoiceStatus;
  String? commissionStatus;
  bool? commission;
  String? skippedBookings;
  bool? permanent;
  String? toggleDriverText;
  String? togglePassengerText;
  String? cancelledReason;
  String? bookingSource;
  bool? onRoute;
  bool? arrived;
  bool? passengerOnBoard;
  bool? completed;
  bool? controllerCompleted;
  String? driverWaitingTime;
  String? dispatchedAt;
  String? bookedAt;
  String? stripeCustomerId;
  String? stripePaymentId;
  String? invoiceNumber;
  int? initialSubsidiaryId;
  String? createdAt;
  String? updatedAt;
  String? eta;
  bool? fob;
  bool? future;
  BookingStatus? bookingStatus;
  BookingType? bookingType;
  JourneyType? journeyType;
  Subsidiary? subsidiary;
  VehicleType? vehicleType;
  PaymentType? paymentType;
  Account? account;
  Driver? driver;
  Customer? customer;
  Employee? employee;
  Airport? airport;

  Bookings({
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
    this.via,
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
    this.future,
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

  Bookings.fromJson(Map<String, dynamic> json) {
    id = _parseString(json['id']);
    referenceNumber = _parseString(json['reference_number']);
    subsidiaryId = _parseInt(json['subsidiary_id']);
    bookingTypeId = _parseInt(json['booking_type_id']);
    bookingStatusId = _parseInt(json['booking_status_id']);
    journeyTypeId = _parseInt(json['journey_type_id']);
    accountId = _parseInt(json['account_id']);
    customerId = _parseInt(json['customer_id']);
    employeeId = _parseInt(json['employee_id']);
    pickup = _parseString(json['pickup']);
    dropoff = _parseString(json['dropoff']);
    pickupDate = _parseString(json['pickup_date']);
    pickupTime = _parseString(json['pickup_time']);
    dropoffDate = _parseString(json['dropoff_date']);
    dropoffTime = _parseString(json['dropoff_time']);
    pickupDoorNumber = _parseString(json['pickup_door_number']);
    dropoffDoorNumber = _parseString(json['dropoff_door_number']);
    pickupPlot = _parseString(json['pickup_plot']);
    dropoffPlot = _parseString(json['dropoff_plot']);
    pickupLocationTypeId = _parseInt(json['pickup_location_type_id']);
    dropoffLocationTypeId = _parseInt(json['dropoff_location_type_id']);
    pickupLatitude = _parseString(json['pickup_latitude']);
    pickupLongitude = _parseString(json['pickup_longitude']);
    dropoffLatitude = _parseString(json['dropoff_latitude']);
    dropoffLongitude = _parseString(json['dropoff_longitude']);
    viapoints = _parseString(json['viapoints']);
    via = json['via'] ?? json['viapoints'];
    restrictedDrivers = _parseString(json['restricted_drivers']);
    flightNumber = _parseString(json['flight_number']);
    arrivingFrom = _parseString(json['arriving_from']);
    vehicleTypeId = _parseInt(json['vehicle_type_id']);
    vehicleId = _parseInt(json['vehicle_id']);
    driverId = _parseInt(json['driver_id']);
    passengers = _parseInt(json['passengers']);
    luggages = _parseInt(json['luggages']);
    handLuggages = _parseInt(json['hand_luggages']);
    childSeat = _parseString(json['child_seat']);
    name = _parseString(json['name']);
    email = _parseString(json['email']);
    mobile = _parseString(json['mobile']);
    telephone = _parseString(json['telephone']);
    leadTime = _parseString(json['lead_time']);
    notes = _parseString(json['notes']);
    specialInstructions = _parseString(json['special_instructions']);
    paymentTypeId = _parseInt(json['payment_type_id']);
    companyPrice = _parseString(json['company_price']);
    fares = _parseString(json['fares']);
    totalCharges = _parseString(json['total_charges']);
    parkingCharges = _parseString(json['parking_charges']);
    waitingCharges = _parseString(json['waiting_charges']);
    extraDropCharges = _parseString(json['extra_drop_charges']);
    creditCardCharges = _parseString(json['credit_card_charges']);
    congestionCharges = _parseString(json['congestion_charges']);
    miles = _parseString(json['miles']);
    meetAndGreet = _parseString(json['meet_and_greet']);
    department = _parseString(json['department']);
    escortId = _parseInt(json['escort_id']);
    orderNumber = _parseString(json['order_number']);
    bookedBy = _parseString(json['booked_by']);
    addReturnFare = _parseBool(json['add_return_fare']);
    fareMeterStatus = _parseBool(json['fare_meter_status']);
    fareMeter = _parseBool(json['fare_meter']);
    quotation = _parseBool(json['quotation']);
    quoted = _parseBool(json['quoted']);
    dispatch = _parseBool(json['dispatch']);
    dispatchAs = _parseString(json['dispatch_as']);
    sms = _parseBool(json['sms']);
    emailflag = _parseBool(json['emailflag']);
    trash = _parseBool(json['trash']);
    hidden = _parseBool(json['hidden']);
    multiBookingId = _parseInt(json['multi_booking_id']);
    associatedBooking = json['associated_booking'];
    invoiceStatus = _parseString(json['invoice_status']);
    commissionStatus = _parseString(json['commission_status']);
    commission = _parseBool(json['commission']);
    skippedBookings = _parseString(json['skipped_bookings']);
    permanent = _parseBool(json['permanent']);
    toggleDriverText = _parseString(json['toggle_driver_text']);
    togglePassengerText = _parseString(json['toggle_passenger_text']);
    cancelledReason = _parseString(json['cancelled_reason']);
    bookingSource = _parseString(json['booking_source']);
    onRoute = _parseBool(json['on_route']);
    arrived = _parseBool(json['arrived']);
    passengerOnBoard = _parseBool(json['passenger_on_board']);
    completed = _parseBool(json['completed']);
    controllerCompleted = _parseBool(json['controller_completed']);
    driverWaitingTime = _parseString(json['driver_waiting_time']);
    dispatchedAt = _parseString(json['dispatched_at']);
    bookedAt = _parseString(json['booked_at']);
    stripeCustomerId = _parseString(json['stripe_customer_id']);
    stripePaymentId = _parseString(json['stripe_payment_id']);
    invoiceNumber = _parseString(json['invoice_number']);
    initialSubsidiaryId = _parseInt(json['initial_subsidiary_id']);
    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);
    eta = _parseString(json['eta']);
    fob = _parseBool(json['fob']);
    future = _parseBool(json['future']);
    bookingStatus = json['booking_status'] is Map
        ? BookingStatus.fromJson(Map<String, dynamic>.from(json['booking_status']))
        : null;
    bookingType = json['booking_type'] is Map
        ? BookingType.fromJson(Map<String, dynamic>.from(json['booking_type']))
        : null;
    journeyType = json['journey_type'] is Map
        ? JourneyType.fromJson(Map<String, dynamic>.from(json['journey_type']))
        : null;
    subsidiary = json['subsidiary'] is Map
        ? Subsidiary.fromJson(Map<String, dynamic>.from(json['subsidiary']))
        : null;
    vehicleType = json['vehicle_type'] is Map
        ? VehicleType.fromJson(Map<String, dynamic>.from(json['vehicle_type']))
        : null;
    paymentType = json['payment_type'] is Map
        ? PaymentType.fromJson(Map<String, dynamic>.from(json['payment_type']))
        : null;
    account = json['account'] is Map
        ? Account.fromJson(Map<String, dynamic>.from(json['account']))
        : null;
    driver = json['driver'] is Map
        ? Driver.fromJson(Map<String, dynamic>.from(json['driver']))
        : null;
    customer = json['customer'] is Map
        ? Customer.fromJson(Map<String, dynamic>.from(json['customer']))
        : null;
    employee = json['employee'] is Map
        ? Employee.fromJson(Map<String, dynamic>.from(json['employee']))
        : null;
    airport = json['airport'] is Map
        ? Airport.fromJson(Map<String, dynamic>.from(json['airport']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference_number'] = referenceNumber;
    data['subsidiary_id'] = subsidiaryId;
    data['booking_type_id'] = bookingTypeId;
    data['booking_status_id'] = bookingStatusId;
    data['journey_type_id'] = journeyTypeId;
    data['account_id'] = accountId;
    data['customer_id'] = customerId;
    data['employee_id'] = employeeId;
    data['pickup'] = pickup;
    data['dropoff'] = dropoff;
    data['pickup_date'] = pickupDate;
    data['pickup_time'] = pickupTime;
    data['dropoff_date'] = dropoffDate;
    data['dropoff_time'] = dropoffTime;
    data['pickup_door_number'] = pickupDoorNumber;
    data['dropoff_door_number'] = dropoffDoorNumber;
    data['pickup_plot'] = pickupPlot;
    data['dropoff_plot'] = dropoffPlot;
    data['pickup_location_type_id'] = pickupLocationTypeId;
    data['dropoff_location_type_id'] = dropoffLocationTypeId;
    data['pickup_latitude'] = pickupLatitude;
    data['pickup_longitude'] = pickupLongitude;
    data['dropoff_latitude'] = dropoffLatitude;
    data['dropoff_longitude'] = dropoffLongitude;
    data['viapoints'] = viapoints;
    data['via'] = via;
    data['restricted_drivers'] = restrictedDrivers;
    data['flight_number'] = flightNumber;
    data['arriving_from'] = arrivingFrom;
    data['vehicle_type_id'] = vehicleTypeId;
    data['vehicle_id'] = vehicleId;
    data['driver_id'] = driverId;
    data['passengers'] = passengers;
    data['luggages'] = luggages;
    data['hand_luggages'] = handLuggages;
    data['child_seat'] = childSeat;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['telephone'] = telephone;
    data['lead_time'] = leadTime;
    data['notes'] = notes;
    data['special_instructions'] = specialInstructions;
    data['payment_type_id'] = paymentTypeId;
    data['company_price'] = companyPrice;
    data['fares'] = fares;
    data['total_charges'] = totalCharges;
    data['parking_charges'] = parkingCharges;
    data['waiting_charges'] = waitingCharges;
    data['extra_drop_charges'] = extraDropCharges;
    data['credit_card_charges'] = creditCardCharges;
    data['congestion_charges'] = congestionCharges;
    data['miles'] = miles;
    data['meet_and_greet'] = meetAndGreet;
    data['department'] = department;
    data['escort_id'] = escortId;
    data['order_number'] = orderNumber;
    data['booked_by'] = bookedBy;
    data['add_return_fare'] = addReturnFare;
    data['fare_meter_status'] = fareMeterStatus;
    data['fare_meter'] = fareMeter;
    data['quotation'] = quotation;
    data['quoted'] = quoted;
    data['dispatch'] = dispatch;
    data['dispatch_as'] = dispatchAs;
    data['sms'] = sms;
    data['emailflag'] = emailflag;
    data['trash'] = trash;
    data['hidden'] = hidden;
    data['multi_booking_id'] = multiBookingId;
    data['associated_booking'] = associatedBooking;
    data['invoice_status'] = invoiceStatus;
    data['commission_status'] = commissionStatus;
    data['commission'] = commission;
    data['skipped_bookings'] = skippedBookings;
    data['permanent'] = permanent;
    data['toggle_driver_text'] = toggleDriverText;
    data['toggle_passenger_text'] = togglePassengerText;
    data['cancelled_reason'] = cancelledReason;
    data['booking_source'] = bookingSource;
    data['on_route'] = onRoute;
    data['arrived'] = arrived;
    data['passenger_on_board'] = passengerOnBoard;
    data['completed'] = completed;
    data['controller_completed'] = controllerCompleted;
    data['driver_waiting_time'] = driverWaitingTime;
    data['dispatched_at'] = dispatchedAt;
    data['booked_at'] = bookedAt;
    data['stripe_customer_id'] = stripeCustomerId;
    data['stripe_payment_id'] = stripePaymentId;
    data['invoice_number'] = invoiceNumber;
    data['initial_subsidiary_id'] = initialSubsidiaryId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['eta'] = eta;
    data['fob'] = fob;
    data['future'] = future;
    if (bookingStatus != null) {
      data['booking_status'] = bookingStatus!.toJson();
    }
    if (bookingType != null) {
      data['booking_type'] = bookingType!.toJson();
    }
    if (journeyType != null) {
      data['journey_type'] = journeyType!.toJson();
    }
    if (subsidiary != null) {
      data['subsidiary'] = subsidiary!.toJson();
    }
    if (vehicleType != null) {
      data['vehicle_type'] = vehicleType!.toJson();
    }
    if (paymentType != null) {
      data['payment_type'] = paymentType!.toJson();
    }
    if (account != null) {
      data['account'] = account!.toJson();
    }
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (employee != null) {
      data['employee'] = employee!.toJson();
    }
    if (airport != null) {
      data['airport'] = airport!.toJson();
    }
    return data;
  }
}

class BookingStatus {
  String? bookingStatus;

  BookingStatus({this.bookingStatus});

  BookingStatus.fromJson(Map<String, dynamic> json) {
    bookingStatus = _parseString(json['booking_status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_status'] = bookingStatus;
    return data;
  }
}

class BookingType {
  String? bookingType;

  BookingType({this.bookingType});

  BookingType.fromJson(Map<String, dynamic> json) {
    bookingType = _parseString(json['booking_type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_type'] = bookingType;
    return data;
  }
}

class JourneyType {
  String? journeyType;

  JourneyType({this.journeyType});

  JourneyType.fromJson(Map<String, dynamic> json) {
    journeyType = _parseString(json['journey_type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['journey_type'] = journeyType;
    return data;
  }
}

class Subsidiary {
  int? id;
  String? name;
  String? telephoneNumber;

  Subsidiary({this.id, this.name, this.telephoneNumber});

  Subsidiary.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = _parseString(json['name']);
    telephoneNumber = _parseString(json['telephone_number']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['telephone_number'] = telephoneNumber;
    return data;
  }
}

class VehicleType {
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  VehicleType({this.name, this.backgroundColor, this.foregroundColor});

  VehicleType.fromJson(Map<String, dynamic> json) {
    name = _parseString(json['name']);
    backgroundColor = _parseString(json['background_color']);
    foregroundColor = _parseString(json['foreground_color']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['background_color'] = backgroundColor;
    data['foreground_color'] = foregroundColor;
    return data;
  }
}

class PaymentType {
  int? id;
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  PaymentType({this.id, this.name, this.backgroundColor, this.foregroundColor});

  PaymentType.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = _parseString(json['name']);
    backgroundColor = _parseString(json['background_color']);
    foregroundColor = _parseString(json['foreground_color']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['background_color'] = backgroundColor;
    data['foreground_color'] = foregroundColor;
    return data;
  }
}

class Account {
  int? id;
  String? name;
  String? backgroundColor;
  String? foregroundColor;
  bool? hasVat;
  String? bankInformation;
  String? fareController;
  String? accountFeesType;
  String? accountFees;
  String? accountFeesVat;

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

  Account.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = _parseString(json['name']);
    backgroundColor = _parseString(json['background_color']);
    foregroundColor = _parseString(json['foreground_color']);
    hasVat = _parseBool(json['has_vat']);
    bankInformation = _parseString(json['bank_information']);
    fareController = _parseString(json['fare_controller']);
    accountFeesType = _parseString(json['account_fees_type']);
    accountFees = _parseString(json['account_fees']);
    accountFeesVat = _parseString(json['account_fees_vat']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['background_color'] = backgroundColor;
    data['foreground_color'] = foregroundColor;
    data['has_vat'] = hasVat;
    data['bank_information'] = bankInformation;
    data['fare_controller'] = fareController;
    data['account_fees_type'] = accountFeesType;
    data['account_fees'] = accountFees;
    data['account_fees_vat'] = accountFeesVat;
    return data;
  }
}

class Driver {
  int? id;
  String? username;
  String? name;
  String? mobileDeviceId;
  String? phcVehicleNumber;
  String? phcDriverNumber;
  int? vehicleId;
  String? driverCommission;
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

  Driver.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    username = _parseString(json['username']);
    name = _parseString(json['name']);
    mobileDeviceId = _parseString(json['mobile_device_id']);
    phcVehicleNumber = _parseString(json['phc_vehicle_number']);
    phcDriverNumber = _parseString(json['phc_driver_number']);
    vehicleId = _parseInt(json['vehicle_id']);
    driverCommission = _parseString(json['driver_commission']);
    sessionStatus = _parseString(json['session_status']);
    vehicle = json['vehicle'] is Map
        ? Vehicle.fromJson(Map<String, dynamic>.from(json['vehicle']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['mobile_device_id'] = mobileDeviceId;
    data['phc_vehicle_number'] = phcVehicleNumber;
    data['phc_driver_number'] = phcDriverNumber;
    data['vehicle_id'] = vehicleId;
    data['driver_commission'] = driverCommission;
    data['session_status'] = sessionStatus;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}

class Vehicle {
  String? make;
  String? model;
  String? color;
  String? vehicleNumber;

  Vehicle({this.make, this.model, this.color, this.vehicleNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    make = _parseString(json['make']);
    model = _parseString(json['model']);
    color = _parseString(json['color']);
    vehicleNumber = _parseString(json['vehicle_number']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['make'] = make;
    data['model'] = model;
    data['color'] = color;
    data['vehicle_number'] = vehicleNumber;
    return data;
  }
}

class Customer {
  String? doorNumber;
  String? address1;
  String? address2;
  bool? blacklist;

  Customer({this.doorNumber, this.address1, this.address2, this.blacklist});

  Customer.fromJson(Map<String, dynamic> json) {
    doorNumber = _parseString(json['door_number']);
    address1 = _parseString(json['address1']);
    address2 = _parseString(json['address2']);
    blacklist = _parseBool(json['blacklist']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['door_number'] = doorNumber;
    data['address1'] = address1;
    data['address2'] = address2;
    data['blacklist'] = blacklist;
    return data;
  }
}

class Employee {
  String? username;
  int? roleId;

  Employee({this.username, this.roleId});

  Employee.fromJson(Map<String, dynamic> json) {
    username = _parseString(json['username']);
    roleId = _parseInt(json['role_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['role_id'] = roleId;
    return data;
  }
}

class Airport {
  Pickup? pickup;
  Pickup? dropoff;

  Airport({this.pickup, this.dropoff});

  Airport.fromJson(Map<String, dynamic> json) {
    pickup = json['pickup'] is Map
        ? Pickup.fromJson(Map<String, dynamic>.from(json['pickup']))
        : null;
    dropoff = json['dropoff'] is Map
        ? Pickup.fromJson(Map<String, dynamic>.from(json['dropoff']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickup != null) {
      data['pickup'] = pickup!.toJson();
    }
    if (dropoff != null) {
      data['dropoff'] = dropoff!.toJson();
    }
    return data;
  }
}

class Pickup {
  int? id;
  String? name;
  LocationType? locationType;

  Pickup({this.id, this.name, this.locationType});

  Pickup.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = _parseString(json['name']);
    locationType = json['location_type'] is Map
        ? LocationType.fromJson(Map<String, dynamic>.from(json['location_type']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (locationType != null) {
      data['location_type'] = locationType!.toJson();
    }
    return data;
  }
}

class LocationType {
  int? id;
  String? name;
  String? backgroundColor;
  String? foregroundColor;

  LocationType({
    this.id,
    this.name,
    this.backgroundColor,
    this.foregroundColor,
  });

  LocationType.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = _parseString(json['name']);
    backgroundColor = _parseString(json['background_color']);
    foregroundColor = _parseString(json['foreground_color']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['background_color'] = backgroundColor;
    data['foreground_color'] = foregroundColor;
    return data;
  }
}
