

import 'package:dashboard_new1/component/networks/api.dart';

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


Future<String> getFares({
  dynamic miles,
  dynamic pickupDate,
  dynamic pickupTime,
  dynamic vehicleTypeId,
  List? multiReservation,
  dynamic day,
  dynamic pickUpPlotId,
  dynamic dropoffPlotId,
  String? pickup,
  String? dropOff,
  String? partingCharges,
  String? congestionCharges,
  String? meetGreet,
  String? waitingCharges,
  String? extraDropCharges,
  String? creditCardCharges,
  String? companyPrice,
  String? returnCompanyPrice,
}) async {
  var formData = {
    if (miles != null) "miles": miles,
    if (pickupDate != null) "pickup_date": pickupDate,
    if (pickupTime != null) "pickup_time": pickupTime,
    if (vehicleTypeId != null) "vehicle_type_id": vehicleTypeId,
    if (multiReservation != null) "multi_reservation": multiReservation,
    if (day != null) "day": day,
    if (pickUpPlotId != null) "pickup_plot_id": pickUpPlotId,
    if (dropoffPlotId != null) "dropoff_plot_id": dropoffPlotId,
    if (pickup != null) "pickup": pickup,
    if (dropOff != null) "dropoff": dropOff,

    if(partingCharges != null)"partingCharges": partingCharges,
    if(congestionCharges != null)"congestionCharges": congestionCharges,
    if(meetGreet != null)"meetGreet": meetGreet,
    if(waitingCharges != null)"waitingCharges": waitingCharges,
    if(extraDropCharges != null)"extraDropCharges": extraDropCharges,
    if(creditCardCharges != null)"creditCardCharges": creditCardCharges,
    if(companyPrice != null)"companyPrice": companyPrice,
    if(returnCompanyPrice != null)"returnCompanyPrice": returnCompanyPrice,

  };
  try {
    var response = await Api().post(formData, "fares/calculate-fare");

    if (response.statusCode == 200) {
      print("API Success: ${response.data}");
      // Ensure you convert the value to String using .toString()
      // in case the API returns it as a number (int/double).
      return response.data['data']['total_fare'].toString();
    } else {
      print("API Error: ${response.statusCode}");
      return "0"; // Return a default value or handle error
    }
  } catch (e) {
    print("Connection Error: $e");
    return "0"; // Return a default value if the request fails entirely
  }
}