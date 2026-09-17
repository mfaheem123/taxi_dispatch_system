// import 'package:bot_toast/bot_toast.dart';
// import 'package:intl/intl.dart';
//
// import '../../../component/networks/api.dart';
// import '../models/jobs_details_model.dart';
// import 'dashboard_controller.dart';
// DashboardController deshController =Get.put(DashboardController());
// pickBookingBinding({
//   BookingObjectData? jobData,
//   id,
//   bool hitAddBooking = false,
//   bool cliHit = false,
//   String? swappedPickup,
//   String? swappedDropoff,
// }) async {
//   var response = await Api().get("bookings/getbyid/$id");
//
//   if (response.statusCode == 200) {
//     DateTime now = DateTime.now();
//     String currentDateStr = DateFormat('yyyy-MM-dd').format(now);
//     String currentTimeStr = DateFormat('HH:mm').format(now);
//
//     JobsDetailsJobs jobData = JobsDetailsJobs.fromJson(response.data);
//
//     if (jobData.booking.isEmpty) {
//       BotToast.showText(text: "BOOKING NOT FOUND");
//       return;
//     }
//
//     jobDetails = jobData.booking[0];
//     polyLineMarkerInfo.clear();
//     viaPoints.clear();
//     // Cleared with viaPoints, not separately: the two lists are read by
//     // index against each other below and in the via dialog, so leaving the
//     // controllers behind pairs the new points with the old booking's names.
//     viaTextEditingController.clear();
//     polylinePoints.clear();
//
//     // 1. SWAPPED ADDRESS OVERRIDE
//     if (cliHit && swappedPickup != null && swappedDropoff != null) {
//       pickupController.text = swappedPickup.toUpperCase();
//       dropOffController.text = swappedDropoff.toUpperCase();
//     } else {
//       pickupController.text = jobData.booking[0].pickup.toString().toUpperCase();
//       dropOffController.text = jobData.booking[0].dropoff.toString().toUpperCase();
//     }
//
//     //  COORDINATES & MAP POINTS HANDLE
//     double pLat = double.parse(jobData.booking[0].pickupLatitude!);
//     double pLng = double.parse(jobData.booking[0].pickupLongitude!);
//     double dLat = double.parse(jobData.booking[0].dropoffLatitude!);
//     double dLng = double.parse(jobData.booking[0].dropoffLongitude!);
//
//     // Agar swap hua ho toh polyline markers/points swap kar ke add karein
//     if (cliHit && swappedPickup != null) {
//       polylinePoints.add(LatLng(dLat, dLng));
//       polylinePoints.add(LatLng(pLat, pLng));
//
//       polyLineMarkerInfo.add(ViaPoint(
//         lat: dLat,
//         lng: dLng,
//         markerType: "PICKUP LOCATION",
//         address: '',
//       ));
//       polyLineMarkerInfo.add(ViaPoint(
//         lat: pLat,
//         lng: pLng,
//         markerType: "DROP LOCATION",
//         address: '',
//       ));
//     } else {
//       polylinePoints.add(LatLng(pLat, pLng));
//       polylinePoints.add(LatLng(dLat, dLng));
//
//       polyLineMarkerInfo.add(ViaPoint(
//         lat: pLat,
//         lng: pLng,
//         markerType: "PICKUP LOCATION",
//         address: '',
//       ));
//       polyLineMarkerInfo.add(ViaPoint(
//         lat: dLat,
//         lng: dLng,
//         markerType: "DROP LOCATION",
//         address: '',
//       ));
//     }
//
//     for (var item in jobData.booking[0].viapoints!) {
//       final p = LatLng(
//         double.parse(item.latitude.toString()),
//         double.parse(item.longitude.toString()),
//       );
//       polylinePoints.add(LatLng(p.latitude, p.longitude));
//
//       viaPoints.add(ViaPoint(
//         withReturnWay: 'via',
//         address: item.viapoint!,
//         lat: p.latitude,
//         lng: p.longitude,
//       ));
//       viaTextEditingController.add(ViaTextEditingControllerClass(
//         TextEditingController(text: item.name ?? ""),
//         TextEditingController(text: item.mobile ?? ""),
//       ));
//     }
//
//     fetchRouteFromOSRM();
//
//     nameController.text = jobData.booking[0].name!.toUpperCase();
//     emailController.text = jobData.booking[0].email!;
//     mobileController.text = jobData.booking[0].mobile!;
//     if (jobData.booking[0].telephone != null) {
//       telController.text = jobData.booking[0].telephone!;
//     }
//     totalTimeDuration.value = jobData.booking[0].eta.toString().toUpperCase();
//
//     if (cliHit == true) {
//       pickUpTimeController.text = DateFormat('HH:mm').format(DateTime.now());
//     } else {
//       pickUpTimeController.text = jobData.booking[0].pickupTime!;
//     }
//
//     pickUpTimePicked = true;
//
//     if (jobData.booking[0].pickupDate != null) {
//       if (cliHit == true) {
//         pickUpDate = DateTime.now();
//         pickUpDatePicked = true;
//       } else {
//         pickUpDate = jobData.booking[0].pickupDate;
//         pickUpDatePicked = true;
//       }
//     }
//
//     if(jobData.booking[0].flightNumber != null && jobData.booking[0].flightNumber != ""){
//       isAirportResponse.value = true;
//       selectAirportController.text = jobData.booking[0].flightNumber.toString();
//     }
//     if(jobData.booking[0].arrivingFrom != null && jobData.booking[0].arrivingFrom != ""){
//       isAirportResponse.value = true;
//       arrivalTimeController.text = jobData.booking[0].arrivingFrom.toString();
//     }
//
//     minController.text = jobData.booking[0].leadTime ?? "";
//
//     if (jobData.booking[0].passengers != null) {
//       passController.text = jobData.booking[0].passengers.toString();
//     }
//     if (jobData.booking[0].luggages != null) {
//       luggController.text = jobData.booking[0].luggages.toString();
//     }
//     if (jobData.booking[0].handLuggages != null) {
//       sluggController.text = jobData.booking[0].handLuggages.toString();
//     }
//     if (jobData.booking[0].parkingCharges != null) {
//       parkingChargesController.text = jobData.booking[0].parkingCharges.toString();
//     }
//     if (jobData.booking[0].congestionCharges != null) {
//       congestionChargesController.text = jobData.booking[0].congestionCharges.toString();
//     }
//     if (jobData.booking[0].meetAndGreet != null) {
//       meetGreetController.text = jobData.booking[0].meetAndGreet.toString();
//     }
//     if (jobData.booking[0].waitingCharges != null) {
//       waitingChargesController.text = jobData.booking[0].waitingCharges.toString();
//     }
//     if (jobData.booking[0].extraDropCharges != null) {
//       extraDropChargesController.text = jobData.booking[0].extraDropCharges.toString();
//     }
//     if (jobData.booking[0].creditCardCharges != null) {
//       creditCardChargesController.text = jobData.booking[0].creditCardCharges.toString();
//     }
//     if (jobData.booking[0].companyPrice != null) {
//       companyPriceController.text = jobData.booking[0].companyPrice.toString();
//     }
//     if (jobData.booking[0].specialInstructions != null) {
//       specialRequirementsController.text =
//           jobData.booking[0].specialInstructions.toString();
//     }
//     slugController.text = jobData.booking[0].fares.toString();
//
//     if (jobData.booking[0].pickupDoorNumber != null) {
//
//       pickUpNoteController.text = jobData.booking[0].pickupDoorNumber.toString();
//     }
//     if (jobData.booking[0].dropoffDoorNumber != null) {
//       dropUpNoteController.text = jobData.booking[0].dropoffDoorNumber.toString();
//     }
//
//     if (jobData.booking[0].childSeat!.isNotEmpty) {
//       for (var action in jobData.booking[0].childSeat!) {
//         childSeatAlert.add(ChildSeatClass(
//           sets: action.child,
//           age: action.age,
//         ));
//       }
//     }
//
//     if (jobData.booking[0].restrictedDrivers?.isNotEmpty ?? false) {
//       final restrictedIds =
//       jobData.booking[0].restrictedDrivers!.map((e) => e.id.toString()).toSet();
//       if(allDriverData != null && allDriverData!.drivers!.isNotEmpty){
//         driversList.addAll(allDriverData!.drivers!
//             .where((driver) => restrictedIds.contains(driver.id.toString())));
//       }else{
//         driversList.clear();
//       }
//     }
//
//     if (jobData.booking[0].subsidiaryId != null) {
//       selectSubsidiariesValue =
//           dashboardAllData?.subsidiaries?.firstWhereOrNull(
//                 (subsidiary) => subsidiary.id == jobData.booking[0].subsidiaryId,
//           );
//     }
//
//     await getAccountData(subsidiariesId: selectSubsidiariesValue!.id ?? 1);
//
//     selectAccountValue = dashboardAccountData?.accounts?.firstWhereOrNull(
//           (account) => account.id == jobData.booking[0].accountId,
//     );
//
//     selectDepartmentData = dashboardAccountData?.accounts
//         ?.expand((account) => account.departments ?? [])
//         .firstWhere(
//           (dept) => dept.id.toString() == jobData.booking[0].department.toString(),
//       orElse: () => null,
//     );
//
//     if (jobData.booking[0].paymentTypeId != null) {
//       selectPaymentTypeValue =
//           dashboardAllData?.paymentTypes?.firstWhereOrNull(
//                 (payment) => payment.id == jobData.booking[0].paymentTypeId,
//           );
//     }
//
//     // dashboardAllData!.journeyTypes
//     // selectJourneyTypeValue
//     // // journey_type_id
//
//     if (jobData.booking[0].journeyTypeId != null) {
//       selectJourneyTypeValue =
//           dashboardAllData?.journeyTypes?.firstWhereOrNull(
//                 (journey) => journey.id == jobData.booking[0].journeyTypeId,
//           );
//     }
//
//     if (jobData.booking[0].vehicleTypeId != null) {
//       selectVehicleValue = dashboardAllData?.vehicleTypes?.firstWhereOrNull(
//             (vehicle) => vehicle.id == jobData.booking[0].vehicleTypeId,
//       );
//     }
//     if (jobData.booking[0].driverId != null) {
//       selectDriverValue = dashboardAllData?.drivers?.firstWhereOrNull(
//             (vehicle) => vehicle.id == jobData.booking[0].driverId,
//       );
//     }
//
//     final LocationController _controller =
//     Get.isRegistered<LocationController>()
//         ? Get.find<LocationController>()
//         : Get.put(LocationController());
//
//     final zones = _controller.locationtypezoneModel?.zonesList;
//
//     if (zones != null) {
//       _controller.updateLocationValue.value == true;
//
//       if (jobData.booking[0].pickupPlot != null) {
//         dashboardZoneValue =
//             zones.firstWhereOrNull((z) => z.id == jobData.booking[0].pickupPlot);
//
//         _controller.zoneValue =
//             zones.firstWhereOrNull((z) => z.id == jobData.booking[0].pickupPlot);
//       }
//
//       if (jobData.booking[0].dropoffPlot != null) {
//
//         dashboardDZoneValue =
//             zones.firstWhereOrNull((z) => z.id == jobData.booking[0].dropoffPlot);
//
//         _controller.zoneDValue =
//             zones.firstWhereOrNull((z) => z.id == jobData.booking[0].dropoffPlot);
//       }
//
//       _controller.updateLocationValue.value == false;
//     }
//
//     if (jobData.booking.length > 1) {
//       jourValue = 'R/N';
//       selectJourneyTypeValue =
//           dashboardAllData?.journeyTypes?.firstWhereOrNull(
//                 (journey) => journey.id == jobData.booking[0].journeyTypeId,
//           );
//       fixedFare.value = (double.parse(jobData.booking[1].fares!)+ double.parse(jobData.booking[0].fares!)).toString();
//
//       if(jobData.booking[1].flightNumber != null && jobData.booking[1].flightNumber !=""){
//         isAirportResponse.value = true;
//         selectAirportControllerReturn.text = jobData.booking[1].flightNumber.toString();
//       }
//       if(jobData.booking[1].arrivingFrom != null && jobData.booking[1].arrivingFrom !=""){
//         isAirportResponse.value = true;
//         arrivalReturnTimeController.text = jobData.booking[1].arrivingFrom.toString();
//       }
//       withReturnDataBinding(jobData.booking[1]);
//     }else{
//       selectJourneyTypeValue =
//           dashboardAllData?.journeyTypes?.firstWhereOrNull(
//                 (journey) => journey.id == jobData.booking[0].journeyTypeId,
//           );
//       if(selectJourneyTypeValue!.id == 1){
//         jourValue = "O/W";
//       }else if (selectJourneyTypeValue!.id == 2){
//         jourValue = "W/R";
//       }
//       fixedFare.value = jobData.booking[0].fares.toString();
//
//       getFaresCalculation();
//     }
//
//     if (hitAddBooking == true) {
//       dashBoardApiValidation();
//     } else {
//       update();
//     }
//   }
// }
