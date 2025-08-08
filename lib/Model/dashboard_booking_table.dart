
class Booking {
  final int sno;

  final String ref;
  final String date;
  final String time;
  final String customerName;
  final String pickupPoint;
  final String dropoffPoint;
  final String phone;
  final String vehicle;
  final String status;
  final String driver;
  final String account;
  final double fares;

  Booking({
    required this.sno,
    required this.ref,
    required this.date,
    required this.time,
    required this.customerName,
    required this.pickupPoint,
    required this.dropoffPoint,
    required this.phone,
    required this.vehicle,
    required this.status,
    required this.driver,
    required this.account,
    required this.fares,
  });
}
