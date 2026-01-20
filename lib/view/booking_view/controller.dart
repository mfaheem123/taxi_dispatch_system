


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../component/networks/api.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/dashboard_table_model.dart';

class BookingController extends GetxController{

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> menu bar controller

  DashboardController menuBarController = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo complete booking functionality

  /// bool variables
  ///
  RxBool completeValue = false.obs;
  RxBool cancelledValue = false.obs;
  RxBool incompleteValue = false.obs;
  RxBool missedValue = false.obs;
  RxBool declinedValue = false.obs;
  RxBool waitingValue = false.obs;
  RxBool preDispatchValue = false.obs;

  /// text fields editing controllers
  final enterKeyboardController = TextEditingController();


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo complete booking functionality




/// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Pre Booking

  RxList<BookingObjectData> preBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> preBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? dashboardTableModelData;
  RxBool preBookingLoad = false.obs;
  RxInt preBookingCurrentPage = 1.obs;
  RxInt preBookingTotalPages = 1.obs;
  final int dashboardTableLimit = 20;

  final referenceNumber = TextEditingController();
  final pickupDate = TextEditingController();
  final pickupTime = TextEditingController();
  final name = TextEditingController();
  final pickup = TextEditingController();
  final dropOff = TextEditingController();
  final accountName = TextEditingController();
  final driverName = TextEditingController();
  final notes = TextEditingController();
  final fares = TextEditingController();
  final bookingStatus = TextEditingController();
  final journeyType = TextEditingController();
  final paymentType = TextEditingController();
  final vehicleTypeName = TextEditingController();
  final subsidiary = TextEditingController();


  final int tableId = 2;
  getDashboardTableData() async {
    preBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${tableId}",
        queryParameters: {
          "page": preBookingCurrentPage.value,
          "limit": dashboardTableLimit,
          "reference_number": referenceNumber.text,
          "pickup_date": pickupDate.text,
          "pickup_time": pickupTime.text,
          "name": name.text,
          "pickup": pickup.text,
          "dropoff": dropOff.text,
          "account_name": accountName.text,
          "driver_name": driverName.text,
          "payment_type": paymentType.text,
          "vehicle_type_name": vehicleTypeName.text,
          "notes": notes.text,
          "fares": fares.text,
          "booking_status": bookingStatus.text,
          "journey_type": journeyType.text,
          "subsidiary" : subsidiary.text,


        }
    );
    if(response.statusCode == 200){
      dashboardTableModelData = DashboardTableModel.fromJson(response.data);
      preBookingTotalPages.value = dashboardTableModelData!.total ?? 1;
      preBookingAll.value = dashboardTableModelData?.data ?? [];
      preBookingFiltered.value = preBookingAll;
      update();
      preBookingLoad(false);

    }
  }

  void preBookingPageChange(int page) {
    preBookingCurrentPage.value = page;
    getDashboardTableData();
  }

  void onSearchpreBooking() {
    preBookingCurrentPage.value = 1;
    getDashboardTableData();
  }
///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> web Booking


  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Pre Booking

  RxList<BookingObjectData> webBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> webBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? webBookingModelData;
  RxBool webBookingLoad = false.obs;
  RxInt webBookingCurrentPage = 1.obs;
  RxInt webBookingTotalPages = 1.obs;
  final int webBookingLimit = 20;

  final webreferenceNumber = TextEditingController();
  final webpickupDate = TextEditingController();
  final webpickupTime = TextEditingController();
  final webname = TextEditingController();
  final webpickup = TextEditingController();
  final webdropOff = TextEditingController();
  final webaccountName = TextEditingController();
  final webdriverName = TextEditingController();
  final webnotes = TextEditingController();
  final webfares = TextEditingController();
  final webbookingStatus = TextEditingController();
  final webjourneyType = TextEditingController();
  final webpaymentType = TextEditingController();
  final webvehicleTypeName = TextEditingController();
  final websubsidiary = TextEditingController();


  final int webBookId = 7;
  getWebBookingData() async {
    preBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${webBookId}",
        queryParameters: {
          "page": preBookingCurrentPage.value,
          "limit": dashboardTableLimit,
          "reference_number": referenceNumber.text,
          "pickup_date": pickupDate.text,
          "pickup_time": pickupTime.text,
          "name": name.text,
          "pickup": pickup.text,
          "dropoff": dropOff.text,
          "account_name": accountName.text,
          "driver_name": driverName.text,
          "payment_type": paymentType.text,
          "vehicle_type_name": vehicleTypeName.text,
          "notes": notes.text,
          "fares": fares.text,
          "booking_status": bookingStatus.text,
          "journey_type": journeyType.text,
          "subsidiary" : subsidiary.text,
        }
    );
    if(response.statusCode == 200){
      webBookingModelData = DashboardTableModel.fromJson(response.data);
      webBookingTotalPages.value = webBookingModelData!.total ?? 1;
      webBookingAll.value = webBookingModelData?.data ?? [];
      webBookingFiltered.value = webBookingAll;
      update();
      webBookingLoad(false);

    }
  }

  void webBookingPageChange(int page) {
    webBookingCurrentPage.value = page;
    getWebBookingData();
  }

  void webBookingonSearch() {
    webBookingCurrentPage.value = 1;
    getWebBookingData();
  }



}