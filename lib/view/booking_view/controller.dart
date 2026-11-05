


import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Reusable Tab Fetching API

  Future<DashboardTableModel?> fetchBookingTab({
    required int tabId,
    required RxBool loadRx,
    required RxInt totalPagesRx,
    required RxList<BookingObjectData> allListRx,
    required RxList<BookingObjectData> filteredListRx,
    required int page,
    required int limit,
    required Map<String, dynamic> queryParameters,
    String? customPath,
    bool auth = false,
  }) async {
    loadRx(true);
    String path = customPath ?? "bookings/getbytabs/$tabId";
    var response = await Api().get(
      path,
      sendCompanyId: true,
      queryParameters: queryParameters,
      auth: auth,
    );

    DashboardTableModel? modelData;
    if (response != null && response.statusCode == 200) {
      modelData = DashboardTableModel.fromJson(response.data);
      totalPagesRx.value = modelData.totalPages ?? 1;
      allListRx.value = modelData.data ?? [];
      filteredListRx.value = allListRx;
    }
    loadRx(false);
    update();
    return modelData;
  }

  Map<String, dynamic> _buildCommonQueryParams({
    required int page,
    required int limit,
    required TextEditingController refNum,
    required TextEditingController pDate,
    required TextEditingController pTime,
    required TextEditingController pName,
    required TextEditingController pPickup,
    required TextEditingController pDropOff,
    required TextEditingController pAccountName,
    required TextEditingController pDriverName,
    required TextEditingController pPaymentType,
    required TextEditingController pVehicleTypeName,
    required TextEditingController pNotes,
    required TextEditingController pFares,
    required TextEditingController pBookingStatus,
    required TextEditingController pJourneyType,
    required TextEditingController pSubsidiary,
    String? bookingSource,
  }) {
    final map = <String, dynamic>{
      "page": page,
      "limit": limit,
      "reference_number": refNum.text,
      "pickup_date": pDate.text,
      "pickup_time": pTime.text,
      "name": pName.text,
      "pickup": pPickup.text,
      "dropoff": pDropOff.text,
      "account_name": pAccountName.text,
      "driver_name": pDriverName.text,
      "payment_type": pPaymentType.text,
      "vehicle_type_name": pVehicleTypeName.text,
      "notes": pNotes.text,
      "fares": pFares.text,
      "booking_status": pBookingStatus.text,
      "journey_type": pJourneyType.text,
      "subsidiary": pSubsidiary.text,
    };
    if (bookingSource != null) {
      map["booking_source"] = bookingSource;
    }
    return map;
  }

  getDashboardTableData() async {
    dashboardTableModelData = await fetchBookingTab(
      tabId: tableId,
      loadRx: preBookingLoad,
      totalPagesRx: preBookingTotalPages,
      allListRx: preBookingAll,
      filteredListRx: preBookingFiltered,
      page: preBookingCurrentPage.value,
      limit: dashboardTableLimit,
      queryParameters: _buildCommonQueryParams(
        page: preBookingCurrentPage.value,
        limit: dashboardTableLimit,
        refNum: referenceNumber,
        pDate: pickupDate,
        pTime: pickupTime,
        pName: name,
        pPickup: pickup,
        pDropOff: dropOff,
        pAccountName: accountName,
        pDriverName: driverName,
        pPaymentType: paymentType,
        pVehicleTypeName: vehicleTypeName,
        pNotes: notes,
        pFares: fares,
        pBookingStatus: bookingStatus,
        pJourneyType: journeyType,
        pSubsidiary: subsidiary,
      ),
    );
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
    webBookingModelData = await fetchBookingTab(
      tabId: webBookId,
      loadRx: webBookingLoad,
      totalPagesRx: webBookingTotalPages,
      allListRx: webBookingAll,
      filteredListRx: webBookingFiltered,
      page: webBookingCurrentPage.value,
      limit: webBookingLimit,
      queryParameters: _buildCommonQueryParams(
        page: webBookingCurrentPage.value,
        limit: webBookingLimit,
        refNum: webreferenceNumber,
        pDate: webpickupDate,
        pTime: webpickupTime,
        pName: webname,
        pPickup: webpickup,
        pDropOff: webdropOff,
        pAccountName: webaccountName,
        pDriverName: webdriverName,
        pPaymentType: webpaymentType,
        pVehicleTypeName: webvehicleTypeName,
        pNotes: webnotes,
        pFares: webfares,
        pBookingStatus: webbookingStatus,
        pJourneyType: webjourneyType,
        pSubsidiary: websubsidiary,
      ),
    );
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
    completedBookingModelData = await fetchBookingTab(
      tabId: completedBookId,
      loadRx: completedBookingLoad,
      totalPagesRx: completedBookingTotalPages,
      allListRx: completedBookingAll,
      filteredListRx: completedBookingFiltered,
      page: completedBookingCurrentPage.value,
      limit: completedBookingLimit,
      queryParameters: _buildCommonQueryParams(
        page: completedBookingCurrentPage.value,
        limit: completedBookingLimit,
        refNum: completedreferenceNumber,
        pDate: completedpickupDate,
        pTime: completedpickupTime,
        pName: completedname,
        pPickup: completedpickup,
        pDropOff: completeddropOff,
        pAccountName: completedaccountName,
        pDriverName: completeddriverName,
        pPaymentType: completedpaymentType,
        pVehicleTypeName: completedvehicleTypeName,
        pNotes: completednotes,
        pFares: completedfares,
        pBookingStatus: completedbookingStatus,
        pJourneyType: completedjourneyType,
        pSubsidiary: completedsubsidiary,
        bookingSource: completedSource.text,
      ),
    );
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
    multiBookingModelData = await fetchBookingTab(
      tabId: multiBookId,
      loadRx: multiBookingLoad,
      totalPagesRx: multiBookingTotalPages,
      allListRx: multiBookingAll,
      filteredListRx: multiBookingFiltered,
      page: multiBookingCurrentPage.value,
      limit: multiBookingLimit,
      customPath: "bookings/multi-bookings",
      queryParameters: {
        "page": multiBookingCurrentPage.value,
        "limit": multiBookingLimit,
        "pickup_date": multipickupDate.text,
        "pickup_time": multipickupTime.text,
        "customer": multiCustomerName.text,
        "pickup": multipickup.text,
        "dropoff": multidropOff.text,
        "mobile": multiMobile.text,
      },
    );
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
    appBookingModelData = await fetchBookingTab(
      tabId: appBookId,
      loadRx: appBookingLoad,
      totalPagesRx: appBookingTotalPages,
      allListRx: appBookingAll,
      filteredListRx: appBookingFiltered,
      page: appBookingCurrentPage.value,
      limit: appBookingLimit,
      queryParameters: _buildCommonQueryParams(
        page: appBookingCurrentPage.value,
        limit: appBookingLimit,
        refNum: appreferenceNumber,
        pDate: apppickupDate,
        pTime: apppickupTime,
        pName: appname,
        pPickup: apppickup,
        pDropOff: appdropOff,
        pAccountName: appaccountName,
        pDriverName: appdriverName,
        pPaymentType: apppaymentType,
        pVehicleTypeName: appvehicleTypeName,
        pNotes: appnotes,
        pFares: appfares,
        pBookingStatus: appbookingStatus,
        pJourneyType: appjourneyType,
        pSubsidiary: appsubsidiary,
      ),
    );
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
    trashBookingModelData = await fetchBookingTab(
      tabId: trashBookId,
      loadRx: trashBookingLoad,
      totalPagesRx: trashBookingTotalPages,
      allListRx: trashBookingAll,
      filteredListRx: trashBookingFiltered,
      page: trashBookingCurrentPage.value,
      limit: trashBookingLimit,
      queryParameters: _buildCommonQueryParams(
        page: trashBookingCurrentPage.value,
        limit: trashBookingLimit,
        refNum: trashreferenceNumber,
        pDate: trashpickupDate,
        pTime: trashpickupTime,
        pName: trashname,
        pPickup: trashpickup,
        pDropOff: trashdropOff,
        pAccountName: trashaccountName,
        pDriverName: trashdriverName,
        pPaymentType: trashpaymentType,
        pVehicleTypeName: trashvehicleTypeName,
        pNotes: trashnotes,
        pFares: trashfares,
        pBookingStatus: trashbookingStatus,
        pJourneyType: trashjourneyType,
        pSubsidiary: trashsubsidiary,
      ),
    );
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
    pendingBookingModelData = await fetchBookingTab(
      tabId: pendingBookId,
      loadRx: pendingBookingLoad,
      totalPagesRx: pendingBookingTotalPages,
      allListRx: pendingBookingAll,
      filteredListRx: pendingBookingFiltered,
      page: pendingBookingCurrentPage.value,
      limit: pendingBookingLimit,
      auth: true,
      queryParameters: _buildCommonQueryParams(
        page: pendingBookingCurrentPage.value,
        limit: pendingBookingLimit,
        refNum: pendingreferenceNumber,
        pDate: pendingpickupDate,
        pTime: pendingpickupTime,
        pName: pendingname,
        pPickup: pendingpickup,
        pDropOff: pendingdropOff,
        pAccountName: pendingaccountName,
        pDriverName: pendingdriverName,
        pPaymentType: pendingpaymentType,
        pVehicleTypeName: pendingvehicleTypeName,
        pNotes: pendingnotes,
        pFares: pendingfares,
        pBookingStatus: pendingbookingStatus,
        pJourneyType: pendingjourneyType,
        pSubsidiary: pendingsubsidiary,
      ),
    );
  }

  void pendingBookingPageChange(int page) {
    pendingBookingCurrentPage.value = page;
    getPendingBookingData();
  }

  void pendingBookingonSearch() {
    pendingBookingCurrentPage.value = 1;
    getPendingBookingData();
  }


  deleteBooking(dynamic id) async {
    var response = await Api().delete("bookings/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "BOOKING DELETED SUCCESSFULLY!");
      print(json.encode(response.data));
    }
  }

  deleteTrashBooking(dynamic id) async {
    var response = await Api().delete("bookings/permenant-delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "BOOKING DELETED SUCCESSFULLY!");
      print(json.encode(response.data));
    }
  }

}