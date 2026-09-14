
class BookingModel {
  final String? id;
  final String? referenceNumber;
  final String? name;
  final String? email;
  final String? mobile;
  final String? telephone;
  final String? pickup;
  final String? dropoff;
  final String? pickupDate;
  final String? pickupTime;
  final String? fares;
  final VehicleType? vehicleType;
  final PaymentType? paymentType;
  final BookingStatus? bookingStatus;
  final Account? account;
  final Driver? driver;

  BookingModel({
    this.id,
    this.referenceNumber,
    this.name,
    this.email,
    this.mobile,
    this.telephone,
    this.pickup,
    this.dropoff,
    this.pickupDate,
    this.pickupTime,
    this.fares,
    this.vehicleType,
    this.paymentType,
    this.bookingStatus,
    this.account,
    this.driver,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString(),
      referenceNumber: json['reference_number'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      telephone: json['telephone'],
      pickup: json['pickup'],
      dropoff: json['dropoff'],
      pickupDate: json['pickup_date'],
      pickupTime: json['pickup_time'],
      fares: json['fares']?.toString(),
      vehicleType: json['vehicle_type'] != null
          ? VehicleType.fromJson(json['vehicle_type'])
          : null,
      paymentType: json['payment_type'] != null
          ? PaymentType.fromJson(json['payment_type'])
          : null,
      bookingStatus: json['booking_status'] != null
          ? BookingStatus.fromJson(json['booking_status'])
          : null,
      account: json['account'] != null ? Account.fromJson(json['account']) : null,
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }
}

class VehicleType {
  final String? name;

  VehicleType({this.name});

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      name: json['name'],
    );
  }
}

class PaymentType {
  final int? id;
  final String? name;

  PaymentType({this.id, this.name});

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class BookingStatus {
  final String? bookingStatus;

  BookingStatus({this.bookingStatus});

  factory BookingStatus.fromJson(Map<String, dynamic> json) {
    return BookingStatus(
      bookingStatus: json['booking_status'],
    );
  }
}

class Account {
  final int? id;
  final String? name;

  Account({this.id, this.name});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Driver {
  final int? id;
  final String? name;

  Driver({this.id, this.name});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
    );
  }
}