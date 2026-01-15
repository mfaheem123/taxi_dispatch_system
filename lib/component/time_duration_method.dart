

import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:intl/intl.dart';

import '../view/setting/company_configuration_view/alert_createbooking.dart';

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
  List<MultiReservation>? multiReservationList,
  int? journeyTypeId
}) async {
  // 1. Validation: Return "0" instead of null to match Future<String>
  if (miles == null || miles == "0" || miles == 0) {
    BotToast.showText(text: "Please add pickup and drop off location");
    return "0";
  }

  List<Map<String, dynamic>> multiReservationTemp = [];

  // 2. Safe Null Check for the list
  if (multiReservationList != null && multiReservationList.isNotEmpty) {
    for (var element in multiReservationList) {
      if (element.startDate != null) {
        try {
          // Parse and format date safely
          DateTime parsedDate = DateFormat('yyyy-M-d').parse(element.startDate!);
          String tempDateStore = DateFormat('yyyy-MM-dd').format(parsedDate);

          multiReservationTemp.add({
            "exclude": element.exclude,
            "day": element.day,
            "pickup_date": tempDateStore,
            "pickup_time": element.returnTime
          });
        } catch (e) {
          print("Date Parsing Error: $e");
        }
      }
    }
  }
  String tempMiles = journeyTypeId ==2?double.parse(miles.toString())*2: miles;
  // 3. Constructing Request Body
  // Using a Map<String, dynamic> and filtering nulls
  var formData = {
    if (miles != null) "miles": tempMiles,
    if (pickupDate != null) "pickup_date": pickupDate,
    if (pickupTime != null) "pickup_time": pickupTime,
    if (vehicleTypeId != null) "vehicle_type_id": vehicleTypeId,
    if (day != null) "day": day,
    if (pickUpPlotId != null) "pickup_plot_id": pickUpPlotId,
    if (dropoffPlotId != null) "dropoff_plot_id": dropoffPlotId,
    if (pickup != null) "pickup": pickup,
    if (dropOff != null) "dropoff": dropOff,
    "journey_type_id": journeyTypeId,


    // Priority: Use multiReservationList if processed, otherwise fallback to multiReservation parameter
    if (multiReservationTemp.isNotEmpty)
      "multi_reservation": jsonEncode(multiReservationTemp)
    else if (multiReservation != null)
      "multi_reservation": multiReservation,

    if (partingCharges != null) "parking_charges": partingCharges,
    if (congestionCharges != null) "congestion_charges": congestionCharges,
    if (meetGreet != null) "meet_and_greet": meetGreet,
    if (waitingCharges != null) "waiting_charges": waitingCharges,
    if (extraDropCharges != null) "extra_drop_charges": extraDropCharges,
    if (creditCardCharges != null) "credit_card_charges": creditCardCharges,
    if (companyPrice != null) "company_price": companyPrice,
    if (returnCompanyPrice != null) "return_company_price": returnCompanyPrice,
  };

  print(formData);

  try {
    var response = await Api().post(formData, "fares/calculate-fare");

    if (response != null && response.statusCode == 200) {
      // Check if data and total_fare exist to avoid null errors
      var fare = response.data['data']?['total_fare'];
      return fare?.toString() ?? "0";
    } else {
      print("API Error: ${response?.statusCode}");
      return "0";
    }
  } catch (e) {
    print("Connection Error: $e");
    return "0";
  }
}