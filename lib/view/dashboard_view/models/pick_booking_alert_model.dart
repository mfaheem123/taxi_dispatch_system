class PickBookingModel {
  bool? status;
  int? count;
  List<Bookings>? bookings;

  PickBookingModel({this.status, this.count, this.bookings});

  PickBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['bookings'] != null) {
      bookings = <Bookings>[];
      json['bookings'].forEach((v) {
        bookings!.add(Bookings.fromJson(v));
      });
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
    id = json['id']?.toString();
    referenceNumber = json['reference_number'];
    subsidiaryId = json['subsidiary_id'];
    bookingTypeId = json['booking_type_id'];
    bookingStatusId = json['booking_status_id'];
    journeyTypeId = json['journey_type_id'];
    accountId = json['account_id'];
    customerId = json['customer_id'];
    employeeId = json['employee_id'];
    pickup = json['pickup'];
    dropoff = json['dropoff'];
    pickupDate = json['pickup_date'];
    pickupTime = json['pickup_time'];
    dropoffDate = json['dropoff_date'];
    dropoffTime = json['dropoff_time'];
    pickupDoorNumber = json['pickup_door_number']?.toString();
    dropoffDoorNumber = json['dropoff_door_number']?.toString();
    pickupPlot = json['pickup_plot']?.toString();
    dropoffPlot = json['dropoff_plot']?.toString();
    pickupLocationTypeId = json['pickup_location_type_id'];
    dropoffLocationTypeId = json['dropoff_location_type_id'];
    pickupLatitude = json['pickup_latitude']?.toString();
    pickupLongitude = json['pickup_longitude']?.toString();
    dropoffLatitude = json['dropoff_latitude']?.toString();
    dropoffLongitude = json['dropoff_longitude']?.toString();
    viapoints = json['viapoints']?.toString();
    restrictedDrivers = json['restricted_drivers']?.toString();
    flightNumber = json['flight_number']?.toString();
    arrivingFrom = json['arriving_from']?.toString();
    vehicleTypeId = json['vehicle_type_id'];
    vehicleId = json['vehicle_id'];
    driverId = json['driver_id'];
    passengers = json['passengers'];
    luggages = json['luggages'];
    handLuggages = json['hand_luggages'];
    childSeat = json['child_seat']?.toString();
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    telephone = json['telephone'];
    leadTime = json['lead_time']?.toString();
    notes = json['notes'];
    specialInstructions = json['special_instructions']?.toString();
    paymentTypeId = json['payment_type_id'];
    companyPrice = json['company_price']?.toString();
    fares = json['fares']?.toString();
    totalCharges = json['total_charges']?.toString();
    parkingCharges = json['parking_charges']?.toString();
    waitingCharges = json['waiting_charges']?.toString();
    extraDropCharges = json['extra_drop_charges']?.toString();
    creditCardCharges = json['credit_card_charges']?.toString();
    congestionCharges = json['congestion_charges']?.toString();
    miles = json['miles']?.toString();
    meetAndGreet = json['meet_and_greet']?.toString();
    department = json['department']?.toString();
    escortId = json['escort_id'];
    orderNumber = json['order_number']?.toString();
    bookedBy = json['booked_by']?.toString();
    addReturnFare = json['add_return_fare'];
    fareMeterStatus = json['fare_meter_status'];
    fareMeter = json['fare_meter'];
    quotation = json['quotation'];
    quoted = json['quoted'];
    dispatch = json['dispatch'];
    dispatchAs = json['dispatch_as']?.toString();
    sms = json['sms'];
    emailflag = json['emailflag'];
    trash = json['trash'];
    hidden = json['hidden'];
    multiBookingId = json['multi_booking_id'];
    associatedBooking = json['associated_booking'];
    invoiceStatus = json['invoice_status']?.toString();
    commissionStatus = json['commission_status']?.toString();
    commission = json['commission'];
    skippedBookings = json['skipped_bookings']?.toString();
    permanent = json['permanent'];
    toggleDriverText = json['toggle_driver_text']?.toString();
    togglePassengerText = json['toggle_passenger_text']?.toString();
    cancelledReason = json['cancelled_reason']?.toString();
    bookingSource = json['booking_source'];
    onRoute = json['on_route'];
    arrived = json['arrived'];
    passengerOnBoard = json['passenger_on_board'];
    completed = json['completed'];
    controllerCompleted = json['controller_completed'];
    driverWaitingTime = json['driver_waiting_time']?.toString();
    dispatchedAt = json['dispatched_at']?.toString();
    bookedAt = json['booked_at'];
    stripeCustomerId = json['stripe_customer_id']?.toString();
    stripePaymentId = json['stripe_payment_id']?.toString();
    invoiceNumber = json['invoice_number']?.toString();
    initialSubsidiaryId = json['initial_subsidiary_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    eta = json['eta'];
    fob = json['fob'];
    future = json['future'];
    bookingStatus = json['booking_status'] != null
        ? BookingStatus.fromJson(json['booking_status'])
        : null;
    bookingType = json['booking_type'] != null
        ? BookingType.fromJson(json['booking_type'])
        : null;
    journeyType = json['journey_type'] != null
        ? JourneyType.fromJson(json['journey_type'])
        : null;
    subsidiary = json['subsidiary'] != null
        ? Subsidiary.fromJson(json['subsidiary'])
        : null;
    vehicleType = json['vehicle_type'] != null
        ? VehicleType.fromJson(json['vehicle_type'])
        : null;
    paymentType = json['payment_type'] != null
        ? PaymentType.fromJson(json['payment_type'])
        : null;
    account =
    json['account'] != null ? Account.fromJson(json['account']) : null;
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    employee = json['employee'] != null
        ? Employee.fromJson(json['employee'])
        : null;
    airport =
    json['airport'] != null ? Airport.fromJson(json['airport']) : null;
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
    bookingStatus = json['booking_status'];
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
    bookingType = json['booking_type'];
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
    journeyType = json['journey_type'];
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
    id = json['id'];
    name = json['name'];
    telephoneNumber = json['telephone_number'];
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
    name = json['name'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
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
    id = json['id'];
    name = json['name'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
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
    id = json['id'];
    name = json['name'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
    hasVat = json['has_vat'];
    bankInformation = json['bank_information']?.toString();
    fareController = json['fare_controller']?.toString();
    accountFeesType = json['account_fees_type']?.toString();
    accountFees = json['account_fees']?.toString();
    accountFeesVat = json['account_fees_vat']?.toString();
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
    id = json['id'];
    username = json['username'];
    name = json['name'];
    mobileDeviceId = json['mobile_device_id']?.toString();
    phcVehicleNumber = json['phc_vehicle_number']?.toString();
    phcDriverNumber = json['phc_driver_number']?.toString();
    vehicleId = json['vehicle_id'];
    driverCommission = json['driver_commission']?.toString();
    sessionStatus = json['session_status']?.toString();
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
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
    make = json['make']?.toString();
    model = json['model']?.toString();
    color = json['color']?.toString();
    vehicleNumber = json['vehicle_number']?.toString();
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
    doorNumber = json['door_number']?.toString();
    address1 = json['address1']?.toString();
    address2 = json['address2']?.toString();
    blacklist = json['blacklist'];
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
    username = json['username']?.toString();
    roleId = json['role_id'];
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
    pickup = json['pickup'] != null ? Pickup.fromJson(json['pickup']) : null;
    dropoff = json['dropoff'] != null ? Pickup.fromJson(json['dropoff']) : null;
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
    id = json['id'];
    name = json['name']?.toString();
    locationType = json['location_type'] != null
        ? LocationType.fromJson(json['location_type'])
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
    id = json['id'];
    name = json['name']?.toString();
    backgroundColor = json['background_color']?.toString();
    foregroundColor = json['foreground_color']?.toString();
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