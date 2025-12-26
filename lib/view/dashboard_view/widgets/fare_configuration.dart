


import '../models/dashboard_model.dart';

int dayToIndex(String day) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return days.indexOf(day);
}

int timeToMinutes(String time) {
  final parts = time.trim().split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}


Future<FareConfigurationObject?> getActiveFareForVehicle(
    List<FareConfigurationObject> fares,
    int vehicleId,
    ) async {

  final now = DateTime.now();
  final currentDayIndex = now.weekday - 1;
  final currentMinutes = now.hour * 60 + now.minute;

  for (final fare in fares) {

    // ✅ FILTER BY VEHICLE ID
    if (fare.vehicleTypeId != vehicleId) continue;

    if (fare.fromDay == null ||
        fare.toDay == null ||
        fare.fromTime == null ||
        fare.toTime == null) continue;

    // ---- DAY CHECK ----
    final fromDayIndex = dayToIndex(fare.fromDay!);
    final toDayIndex = dayToIndex(fare.toDay!);

    bool dayMatched;
    if (fromDayIndex <= toDayIndex) {
      dayMatched =
          currentDayIndex >= fromDayIndex &&
              currentDayIndex <= toDayIndex;
    } else {
      dayMatched =
          currentDayIndex >= fromDayIndex ||
              currentDayIndex <= toDayIndex;
    }

    if (!dayMatched) continue;

    // ---- TIME CHECK ----
    final fromTime = timeToMinutes(fare.fromTime!);
    final toTime = timeToMinutes(fare.toTime!);

    bool timeMatched;
    if (fromTime <= toTime) {
      timeMatched =
          currentMinutes >= fromTime &&
              currentMinutes <= toTime;
    } else {
      timeMatched =
          currentMinutes >= fromTime ||
              currentMinutes <= toTime;
    }

    if (timeMatched) {
      return fare; // ✅ FOUND
    }
  }

  return null;
}
