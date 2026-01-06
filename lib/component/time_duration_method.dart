

/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> make function for mints and hours
String formatDuration(double minutes) {
  final int totalMinutes = minutes.round();
  final int hours = totalMinutes ~/ 60;
  final int remainingMinutes = totalMinutes % 60;

  if (hours > 0 && remainingMinutes > 0) {
    return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min${remainingMinutes > 1 ? 's' : ''}';
  } else if (hours > 0) {
    return '$hours hour${hours > 1 ? 's' : ''}';
  } else {
    return '$remainingMinutes min${remainingMinutes > 1 ? 's' : ''}';
  }
}

Future<void> getFares({miles, pickupDate, pickupTime, vehicleTypeId}) async{
  var formData = {
    "miles": miles,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "vehicle_type_id": vehicleTypeId,
  };
}