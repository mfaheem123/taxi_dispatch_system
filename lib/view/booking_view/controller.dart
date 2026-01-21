


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
      preBookingTotalPages.value = dashboardTableModelData!.totalPages ?? 1;
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
    webBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${webBookId}",
        queryParameters: {
          "page": webBookingCurrentPage.value,
          "limit": webBookingLimit,
          "reference_number": webreferenceNumber.text,
          "pickup_date": webpickupDate.text,
          "pickup_time": webpickupTime.text,
          "name": webname.text,
          "pickup": webpickup.text,
          "dropoff": webdropOff.text,
          "account_name": webaccountName.text,
          "driver_name": webdriverName.text,
          "payment_type": webpaymentType.text,
          "vehicle_type_name": webvehicleTypeName.text,
          "notes": webnotes.text,
          "fares": webfares.text,
          "booking_status": webbookingStatus.text,
          "journey_type": webjourneyType.text,
          "subsidiary" : websubsidiary.text,
        }
    );
    if(response.statusCode == 200){
      webBookingModelData = DashboardTableModel.fromJson(response.data);
      webBookingTotalPages.value = webBookingModelData?.totalPages ?? 1;
      webBookingAll.value = webBookingModelData?.data ?? [];
      webBookingFiltered.value = webBookingAll;
      webBookingLoad(false);
      update();

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




  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Completed Bookings

  RxList<BookingObjectData> completedBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> completedBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? completedBookingModelData;
  RxBool completedBookingLoad = false.obs;
  RxInt completedBookingCurrentPage = 1.obs;
  RxInt completedBookingTotalPages = 1.obs;
  final int completedBookingLimit = 20;

  final completedSource = TextEditingController();
  final completedreferenceNumber = TextEditingController();
  final completedpickupDate = TextEditingController();
  final completedpickupTime = TextEditingController();
  final completedname = TextEditingController();
  final completedpickup = TextEditingController();
  final completeddropOff = TextEditingController();
  final completedaccountName = TextEditingController();
  final completeddriverName = TextEditingController();
  final completednotes = TextEditingController();
  final completedfares = TextEditingController();
  final completedbookingStatus = TextEditingController();
  final completedjourneyType = TextEditingController();
  final completedpaymentType = TextEditingController();
  final completedvehicleTypeName = TextEditingController();
  final completedsubsidiary = TextEditingController();

  final int completedBookId = 4;
  getcompletedBookingData() async {
    webBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${completedBookId}",
        queryParameters: {
          "page": completedBookingCurrentPage.value,
          "limit": completedBookingLimit,
          "booking_source": completedSource.text,
          "reference_number": completedreferenceNumber.text,
          "pickup_date": completedpickupDate.text,
          "pickup_time": completedpickupTime.text,
          "name": completedname.text,
          "pickup": completedpickup.text,
          "dropoff": completeddropOff.text,
          "account_name": completedaccountName.text,
          "driver_name": completeddriverName.text,
          "payment_type": completedpaymentType.text,
          "vehicle_type_name": completedvehicleTypeName.text,
          "notes": completednotes.text,
          "fares": completedfares.text,
          "booking_status": completedbookingStatus.text,
          "journey_type": completedjourneyType.text,
          "subsidiary" : completedsubsidiary.text,
        }
    );
    if(response.statusCode == 200){
      completedBookingModelData = DashboardTableModel.fromJson(response.data);
      completedBookingTotalPages.value = completedBookingModelData?.totalPages ?? 1;
      completedBookingAll.value = completedBookingModelData?.data ?? [];
      completedBookingFiltered.value = completedBookingAll;
      completedBookingLoad(false);
      update();
    }
  }

  void completedBookingPageChange(int page) {
    completedBookingCurrentPage.value = page;
    getcompletedBookingData();
  }

  void completedBookingonSearch() {
    completedBookingCurrentPage.value = 1;
    getcompletedBookingData();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Multi Bookings

  RxList<BookingObjectData> multiBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> multiBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? multiBookingModelData;
  RxBool multiBookingLoad = false.obs;
  RxInt multiBookingCurrentPage = 1.obs;
  RxInt multiBookingTotalPages = 1.obs;
  final int multiBookingLimit = 20;


  final multipickupDate = TextEditingController();
  final multipickupTime = TextEditingController();
  final multiCustomerName = TextEditingController();
  final multipickup = TextEditingController();
  final multidropOff = TextEditingController();
  final multiMobile = TextEditingController();

  final int multiBookId = 9;
  getMultiBookingData() async {
    webBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${multiBookId}",
        queryParameters: {
          "page": multiBookingCurrentPage.value,
          "limit": multiBookingLimit,
          "pickup_date": multipickupDate.text,
          "pickup_time": multipickupTime.text,
          "customer": multiCustomerName.text,
          "pickup": multipickup.text,
          "dropoff": multidropOff.text,
          "mobile": multiMobile.text,
        }
    );
    if(response.statusCode == 200){
      multiBookingModelData = DashboardTableModel.fromJson(response.data);
      multiBookingTotalPages.value = multiBookingModelData?.totalPages ?? 1;
      multiBookingAll.value = multiBookingModelData?.data ?? [];
      multiBookingFiltered.value = multiBookingAll;
      multiBookingLoad(false);
      update();
    }
  }

  void multiBookingPageChange(int page) {
    multiBookingCurrentPage.value = page;
    getMultiBookingData();
  }

  void multiBookingonSearch() {
    multiBookingCurrentPage.value = 1;
    getMultiBookingData();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> App Bookings

  RxList<BookingObjectData> appBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> appBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? appBookingModelData;
  RxBool appBookingLoad = false.obs;
  RxInt appBookingCurrentPage = 1.obs;
  RxInt appBookingTotalPages = 1.obs;
  final int appBookingLimit = 20;

  final appreferenceNumber = TextEditingController();
  final apppickupDate = TextEditingController();
  final apppickupTime = TextEditingController();
  final appname = TextEditingController();
  final apppickup = TextEditingController();
  final appdropOff = TextEditingController();
  final appaccountName = TextEditingController();
  final appdriverName = TextEditingController();
  final appnotes = TextEditingController();
  final appfares = TextEditingController();
  final appbookingStatus = TextEditingController();
  final appjourneyType = TextEditingController();
  final apppaymentType = TextEditingController();
  final appvehicleTypeName = TextEditingController();
  final appsubsidiary = TextEditingController();


  final int appBookId = 8;
  getAppBookingData() async {
    appBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${appBookId}",
        queryParameters: {
          "page": appBookingCurrentPage.value,
          "limit": appBookingLimit,
          "reference_number": appreferenceNumber.text,
          "pickup_date": apppickupDate.text,
          "pickup_time": apppickupTime.text,
          "name": appname.text,
          "pickup": apppickup.text,
          "dropoff": appdropOff.text,
          "account_name": appaccountName.text,
          "driver_name": appdriverName.text,
          "payment_type": apppaymentType.text,
          "vehicle_type_name": appvehicleTypeName.text,
          "notes": appnotes.text,
          "fares": appfares.text,
          "booking_status": appbookingStatus.text,
          "journey_type": appjourneyType.text,
          "subsidiary" : appsubsidiary.text,
        }
    );
    if(response.statusCode == 200){
      appBookingModelData = DashboardTableModel.fromJson(response.data);
      appBookingTotalPages.value = appBookingModelData?.totalPages ?? 1;
      appBookingAll.value = appBookingModelData?.data ?? [];
      appBookingFiltered.value = appBookingAll;
      appBookingLoad(false);
      update();
    }
  }

  void appBookingPageChange(int page) {
    appBookingCurrentPage.value = page;
    getAppBookingData();
  }

  void appBookingonSearch() {
    appBookingCurrentPage.value = 1;
    getAppBookingData();
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Trash Bookings

  RxList<BookingObjectData> trashBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> trashBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? trashBookingModelData;
  RxBool trashBookingLoad = false.obs;
  RxInt trashBookingCurrentPage = 1.obs;
  RxInt trashBookingTotalPages = 1.obs;
  final int trashBookingLimit = 20;

  final trashreferenceNumber = TextEditingController();
  final trashpickupDate = TextEditingController();
  final trashpickupTime = TextEditingController();
  final trashname = TextEditingController();
  final trashpickup = TextEditingController();
  final trashdropOff = TextEditingController();
  final trashaccountName = TextEditingController();
  final trashdriverName = TextEditingController();
  final trashnotes = TextEditingController();
  final trashfares = TextEditingController();
  final trashbookingStatus = TextEditingController();
  final trashjourneyType = TextEditingController();
  final trashpaymentType = TextEditingController();
  final trashvehicleTypeName = TextEditingController();
  final trashsubsidiary = TextEditingController();


  final int trashBookId = 11;
  getTrashBookingData() async {
    appBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${trashBookId}",
        queryParameters: {
          "page": trashBookingCurrentPage.value,
          "limit": trashBookingLimit,
          "reference_number": trashreferenceNumber.text,
          "pickup_date": trashpickupDate.text,
          "pickup_time": trashpickupTime.text,
          "name": trashname.text,
          "pickup": trashpickup.text,
          "dropoff": trashdropOff.text,
          "account_name": trashaccountName.text,
          "driver_name": trashdriverName.text,
          "payment_type": trashpaymentType.text,
          "vehicle_type_name": trashvehicleTypeName.text,
          "notes": trashnotes.text,
          "fares": trashfares.text,
          "booking_status": trashbookingStatus.text,
          "journey_type": trashjourneyType.text,
          "subsidiary" : trashsubsidiary.text,
        }
    );
    if(response.statusCode == 200){
      trashBookingModelData = DashboardTableModel.fromJson(response.data);
      trashBookingTotalPages.value = trashBookingModelData?.totalPages ?? 1;
      trashBookingAll.value = trashBookingModelData?.data ?? [];
      trashBookingFiltered.value = trashBookingAll;
      trashBookingLoad(false);
      update();
    }
  }

  void trashBookingPageChange(int page) {
    trashBookingCurrentPage.value = page;
    getTrashBookingData();
  }

  void trashBookingonSearch() {
    trashBookingCurrentPage.value = 1;
    getTrashBookingData();
  }




  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Pending Bookings

  RxList<BookingObjectData> pendingBookingAll = <BookingObjectData>[].obs;
  RxList<BookingObjectData> pendingBookingFiltered = <BookingObjectData>[].obs;
  DashboardTableModel? pendingBookingModelData;
  RxBool pendingBookingLoad = false.obs;
  RxInt pendingBookingCurrentPage = 1.obs;
  RxInt pendingBookingTotalPages = 1.obs;
  final int pendingBookingLimit = 20;

  final pendingreferenceNumber = TextEditingController();
  final pendingpickupDate = TextEditingController();
  final pendingpickupTime = TextEditingController();
  final pendingname = TextEditingController();
  final pendingpickup = TextEditingController();
  final pendingdropOff = TextEditingController();
  final pendingaccountName = TextEditingController();
  final pendingdriverName = TextEditingController();
  final pendingnotes = TextEditingController();
  final pendingfares = TextEditingController();
  final pendingbookingStatus = TextEditingController();
  final pendingjourneyType = TextEditingController();
  final pendingpaymentType = TextEditingController();
  final pendingvehicleTypeName = TextEditingController();
  final pendingsubsidiary = TextEditingController();


  final int pendingBookId = 10;
  getPendingBookingData() async {
    pendingBookingLoad(true);
    var response = await Api().get("bookings/getbytabs/${pendingBookId}",
        queryParameters: {
          "page": pendingBookingCurrentPage.value,
          "limit": pendingBookingLimit,
          "reference_number": pendingreferenceNumber.text,
          "pickup_date": pendingpickupDate.text,
          "pickup_time": pendingpickupTime.text,
          "name": pendingname.text,
          "pickup": pendingpickup.text,
          "dropoff": pendingdropOff.text,
          "account_name": pendingaccountName.text,
          "driver_name": pendingdriverName.text,
          "payment_type": pendingpaymentType.text,
          "vehicle_type_name": pendingvehicleTypeName.text,
          "notes": pendingnotes.text,
          "fares": pendingfares.text,
          "booking_status": pendingbookingStatus.text,
          "journey_type": pendingjourneyType.text,
          "subsidiary" : pendingsubsidiary.text,
        }
    );
    if(response.statusCode == 200){
      pendingBookingModelData = DashboardTableModel.fromJson(response.data);
      pendingBookingTotalPages.value = pendingBookingModelData?.totalPages ?? 1;
      pendingBookingAll.value = pendingBookingModelData?.data ?? [];
      pendingBookingFiltered.value = pendingBookingAll;
      pendingBookingLoad(false);
      update();
    }
  }

  void pendingBookingPageChange(int page) {
    pendingBookingCurrentPage.value = page;
    getPendingBookingData();
  }

  void pendingBookingonSearch() {
    pendingBookingCurrentPage.value = 1;
    getPendingBookingData();
  }






}