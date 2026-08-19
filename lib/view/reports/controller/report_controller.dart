import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../component/networks/api.dart';
import '../../administration/model/list_subsDiary.dart';
import '../../administration/model/user_model.dart';
import '../../customer/model/restricDriver.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../dashboard_view/models/account_darshboard_model.dart';
import '../../dashboard_view/models/dashboard_model.dart';
import '../driver_booking_view/model/booking_graph_model.dart';
import '../driver_booking_view/model/booking_list_model.dart';
import '../driver_reports_view/models/earning_and_info_model.dart';
import '../driver_reports_view/models/list_driver_logs_model.dart';
import '../driver_reports_view/models/list_driver_report_login_model.dart';
import '../employee_reports_view/activity_model.dart';
import '../income_report_view/model/company_income_model.dart';
import '../income_report_view/model/income_model.dart';

class ReportController extends GetxController {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver login functionality

  /// drivers get

  RestricDriverModel? allDriverData;
  DriverObject? selectDriverObject;
  bool isLoadingDriver = false;
  getAllDrivers() async {
    isLoadingDriver = true;
    update();
    try {
      var response = await Api().get("drivers/get", sendCompanyId: true);
      if (response.statusCode == 200) {
        allDriverData = RestricDriverModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching drivers: $e");
    } finally {
      isLoadingDriver = false;
      update();
    }
  }
  /// DRIVER LOGIN LIST
  var loginFromDate = Rxn<DateTime>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var loginToDate = Rxn<DateTime>(DateTime.now());
  final loginStartTimeController = TextEditingController();
  final loginEndTimeController = TextEditingController();

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<DriverShiftHistory> driverShiftHistoryAll = <DriverShiftHistory>[].obs;
  RxList<DriverShiftHistory> driverHistoryFiltered = <DriverShiftHistory>[].obs;
  RxString searchDrivers = ''.obs;
  RxString searchBookings = ''.obs;
  RxString searchLoginDate = ''.obs;
  RxString searchLoginTime = ''.obs;
  RxString searchLogoutDate = ''.obs;
  RxString searchLogoutTime = ''.obs;

  DriverLoginReportListModel? driverLoginReportListModel;
  RxBool isLoadingShift = false.obs;

  getDriverShiftHistory() async {
    if(selectDriverObject == null) {
      BotToast.showText(text: "PLEASE SELECT A DRIVER");
      return;
    }
    isLoadingShift(true);
      try{
      String formattedFromDate = loginFromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(loginFromDate.value!)
          : "";
      String toDateFormate = loginToDate.value != null
          ? DateFormat('yyyy-MM-dd').format(loginToDate.value!)
          : "";
      var response = await Api().get("driver_shift_history/login",
          queryParameters: {
            "driver_id": selectDriverObject?.id.toString(),
            "from_date": formattedFromDate,
            "to_date" : toDateFormate,
            "driver_name": searchDrivers.value.toLowerCase(),
            "booking": searchBookings.value.toLowerCase(),
            "login_date": searchLoginDate.value.toLowerCase(),
            "login_time": searchLoginTime.value.toLowerCase(),
            "logout_date": searchLogoutDate.value.toLowerCase(),
            "logout_time": searchLogoutTime.value.toLowerCase(),
          }
      );
      if (response.statusCode == 200) {
        driverLoginReportListModel = DriverLoginReportListModel.fromJson(response.data);
        driverShiftHistoryAll.value = driverLoginReportListModel?.driverShiftHistories ?? [];
        driverHistoryFiltered.value = driverShiftHistoryAll;
        print("Shift History Data: ${response.data}");
        if (driverLoginReportListModel?.driverShiftHistories == null ||
            driverLoginReportListModel!.driverShiftHistories!.isEmpty) {
          BotToast.showText(
            text: "No Data Found!",
          );
        }
      }
    } catch (e) {
      print("Error fetching shift history: $e");
    } finally {
      isLoadingShift(false);
      update();
    }
  }
  // -----------Search function
  void onSearchDriverShift() {
    getDriverShiftHistory();
  }

  void clearLoginData() {
    selectDriverObject = null;
    driverLoginReportListModel = null;
    isLoadingShift(false);
    loginFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    loginToDate.value = DateTime.now();
    loginStartTimeController.clear();
    loginEndTimeController.clear();
    driverShiftHistoryAll.clear();
    driverHistoryFiltered.clear();
    update();
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver login functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver logs functionality
  var fromDate = Rxn<DateTime>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var toDate = Rxn<DateTime>(DateTime.now());
  final logStartTimeController = TextEditingController(text: "00:00");
  final logEndTimeController = TextEditingController(text: "23:59");

  DriverLogsReportListModel? driverLogsData;
  RxBool isLoadingLogs = false.obs;


  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<DriverLogsBooking> logsBookingAll = <DriverLogsBooking>[].obs;
  RxList<DriverLogsBooking> logsBookingFiltered = <DriverLogsBooking>[].obs;
  RxString searchLogsRef = ''.obs;
  RxString searchLogsDateTime = ''.obs;
  RxString searchLogsVehicle = ''.obs;
  RxString searchLogsPickup = ''.obs;
  RxString searchLogsDropoff = ''.obs;
  RxString searchLogsFares = ''.obs;

  getDriverLogs() async {
    if(selectDriverObject == null) {
      BotToast.showText(text: "PLEASE SELECT A DRIVER");
      return;
    }
    isLoadingLogs(true);

    try{
      String formattedFromDate = fromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(fromDate.value!)
          : "";

      String formattedToDate = toDate.value != null
          ? DateFormat('yyyy-MM-dd').format(toDate.value!)
          : "";
      var response = await Api().get("bookings/driver-logs",
          queryParameters: {
            "driver_id": selectDriverObject?.id.toString(),
            "from_date": formattedFromDate,
            "to_date": formattedToDate,
            "from_time": logStartTimeController.text,
            "to_time": logEndTimeController.text,

            "ref": searchLogsRef.value.toLowerCase(),
            "datetime": searchLogsDateTime.value.toLowerCase(),
            "vehicle": searchLogsVehicle.value.toLowerCase(),
            "pickup": searchLogsPickup.value.toLowerCase(),
            "dropoff": searchLogsDropoff.value.toLowerCase(),
            "fares": searchLogsFares.value.toLowerCase(),
          }
      );
      if (response.statusCode == 200) {
        driverLogsData = DriverLogsReportListModel.fromJson(response.data);
        logsBookingAll.value = driverLogsData?.bookings ?? [];
        logsBookingFiltered.value = logsBookingAll;
        // print("Driver Logs Data Fetched: ${driverLogsData?.count}");
        print("Driver Logs Data: ${response.data}");
      }
    } catch (e) {
      debugPrint("Error fetching driver logs: $e");
    } finally {
      isLoadingLogs(false);
      update();
    }
  }

  // -----------Search function
  void onSearchDriverLogs() {
    getDriverLogs();
  }

  void clearLogsData() {
    selectDriverObject = null;
    driverLogsData = null;
    isLoadingLogs(false);
    fromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    toDate.value = DateTime.now();
    logStartTimeController.text = "00:00";
    logEndTimeController.text = "23:59";
    logsBookingAll.clear();
    logsBookingFiltered.clear();
    update();
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver logs functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver earning and info functionality
  var earningFromDate = Rxn<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  var earningToDate = Rxn<DateTime>(DateTime.now());
  var selectedDate = Rxn<DateTime>(DateTime.now());
  String reportViewType = "daily";
  EarningInfoListModel? earningInfoListModel;
  bool isLoadingEarning = false;

  getAllDriversEarnings({String? viewType}) async {
    if (selectDriverObject == null) {
      print("No driver selected");
      return;
    }
    isLoadingEarning = true;
    update();

    if (viewType != null) {
      reportViewType = viewType;
    }

    try {
      String formattedFromDate = earningFromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(earningFromDate.value!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now());

      String formattedToDate = earningToDate.value != null
          ? DateFormat('yyyy-MM-dd').format(earningToDate.value!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now());

      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      print("Fetching earnings for Driver ID: ${selectDriverObject?.id}, FromDate: $formattedFromDate, ToDate: $formattedToDate,  View: $reportViewType, Date: $currentDate");

      var response = await Api().get("bookings/booking-driver-statistics",
          queryParameters: {
            "driver_id": selectDriverObject?.id.toString(),
            "from_date": formattedFromDate,
            "to_date": formattedToDate,
            "view": reportViewType,
            "date": currentDate,
          });

      if(response.statusCode == 200) {
        earningInfoListModel = EarningInfoListModel.fromJson(response.data);

        print("Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");
        print("==================================================");
        print("Driver Earning Data Loaded Successfully");
      }
    } catch (e) {
      print("Error fetching statistics: $e");
    } finally {
      isLoadingEarning = false;
      update();
    }
  }

  void clearEarningData() {
    selectDriverObject = null;
    earningInfoListModel = null;
    reportViewType = "daily";
    earningFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    earningToDate.value = DateTime.now();
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo driver earning and info functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report booking functionality

  /// text editing controller
  final customerController = TextEditingController();
  final mobileController = TextEditingController();
  final phoneController = TextEditingController();
  final pickUpController = TextEditingController();
  final dropOffController = TextEditingController();
  final orderNumberController = TextEditingController();
  final bookedByController = TextEditingController();

  ///focusNode value of checkBox
  final FocusNode creditCardPaidNode = FocusNode();

  final bookingStartTimeController = TextEditingController();
  final bookingEndTimeController = TextEditingController();
  Rx<DateTime> bookingFromDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  Rx<DateTime> bookingToDate = DateTime.now().obs;


  bool isLoadingPostcodes = false;

  Future<List<String>> getSearchPostcodes(String query) async {
    if (query.isEmpty || query.length < 3) return [];

    try {
      var response = await Api().get(
        "services/search",
        queryParameters: {
          "search": query,
        },
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData is Map && responseData.containsKey('result')) {
          List<dynamic> list = responseData['result'];

          return list.map((item) {
            String name = item['name'] ?? '';
            String postcode = item['postcode'] ?? '';
            return "$name - $postcode";
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error Searching Postcode: $e");
      return [];
    }
  }

  DashboardDataModel? apiDashboardData;
  bool isLoadingData = false;

  BookingStatus? apiSelectedBookingStatus;
  PaymentStatus? apiSelectedPaymentStatus;
  PaymentTypeObject? apiSelectedPaymentType;
  dynamic apiSelectedSubsidiary;

  List<int> apiSelectedPaymentTypeIds = [];

  RxBool isFiltered = false.obs;
  var totalBookings = 0.obs;
  var totalEarnings = 0.0.obs;
  var totalAccountEarnings = 0.0.obs;

  getData() async {
    isLoadingData = true;
    update();

    try{
      var response = await Api().get("enumerations/get", sendCompanyId: true,
      );
      if (response.statusCode == 200) {
        apiDashboardData = DashboardDataModel.fromJson(response.data);

        if (apiDashboardData?.subsidiaries != null && apiDashboardData!.subsidiaries!.isNotEmpty) {
          apiSelectedSubsidiary = apiDashboardData!.subsidiaries!.first;
        }
      } else {
        print("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Dashboard API: $e");
    } finally {
      isLoadingData = false;
      update();
    }
  }

  // booking status id func
  String selectedBookingStatusIds = "1,3,4,5,6,8,10,11,12,13,14,15";
  void setSelectedStatusByName(String name) {
    switch (name.toUpperCase()) {
      case "ALL":
        selectedBookingStatusIds = "1,3,4,5,6,8,10,11,12,13,14,15";
        break;
      case "COMPLETED":
        selectedBookingStatusIds = "11";
        break;
      case "INCOMPLETE":
        selectedBookingStatusIds = "1,3,4,5,6,8,10,12,13,14,15";
        break;
      case "MISSED":
        selectedBookingStatusIds = "4";
        break;
      case "DECLINED":
        selectedBookingStatusIds = "5";
        break;
      case "CANCELLED":
        selectedBookingStatusIds = "12";
        break;
      default:
        selectedBookingStatusIds = "1,3,4,5,6,8,10,11,12,13,14,15";
    }
    update();
  }

  void toggleApiPaymentType(int id) {
    if (apiSelectedPaymentTypeIds.contains(id)) {
      apiSelectedPaymentTypeIds.remove(id);
    } else {
      apiSelectedPaymentTypeIds.add(id);
    }
    update();
  }
// employee drop down Api
  UserModel? userModel;
  Employee? apiSelectedEmployee;

  getEmployeeData() async {
    try{
      var response = await Api().get("employees/get", sendCompanyId: true);
      if (response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);
        if(userModel?.employees?.isNotEmpty ?? false) {
          apiSelectedEmployee = null;
        }
      }
    } catch(e) {
      print("Error Fetching Employee Data: $e");
    }
    update();
  }
// account api
  DashboardAccountModel? dashboardAccountModel;
  DashboardAccountObject? apiSelectedAccount;
  List<DepartmentObject> accountDepartmentsList = [];
  DepartmentObject? apiSelectedDepartment;

  getAccountData(int subsidiaryId) async {
    try{
      dashboardAccountModel = null;
      update();

      var response = await Api().get("accounts/subsidiary/$subsidiaryId", sendCompanyId: true,
      );
      if (response.statusCode == 200) {
        dashboardAccountModel = DashboardAccountModel.fromJson(response.data);
      }
    }catch(e) {
      print("Error Fetching accounts: $e");
    } finally {
      update();
    }
  }

  // filter api
  String? selectRefNumber = "REFERENCE NUMBER";
  String? selectAscending = "ASCENDING";

  BookingStatisticsModel? bookingStatisticsModel;
  bool isLoadingStatistics = false;

  RxString searchReferenceNo = ''.obs;
  RxString searchInvoiceNo = ''.obs;
  RxString searchDateTime = ''.obs;
  RxString searchCustomer = ''.obs;
  RxString searchPickup = ''.obs;
  RxString searchDropOff = ''.obs;
  RxString searchFare = ''.obs;
  RxString searchAccFare = ''.obs;
  RxString searchAcc = ''.obs;
  RxString searchOrderNO = ''.obs;
  RxString searchPaymentType = ''.obs;
  RxString searchJourneyType = ''.obs;
  RxString searchDriver = ''.obs;
  RxString searchVehicle = ''.obs;
  RxString searchSubsidiary = ''.obs;
  RxString searchStatus = ''.obs;

  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 20;

  getBookingStatistics() async {
    try {
      isLoadingStatistics = true;
      update();

      String formattedFromDate = "";
      String formattedToDate = "";

      formattedFromDate = DateFormat('yyyy-MM-dd').format(bookingFromDate.value);
      formattedToDate = DateFormat('yyyy-MM-dd').format(bookingToDate.value);

      String startTime = bookingStartTimeController.text.isNotEmpty ? bookingStartTimeController.text.trim() : "";
      String endTime = bookingEndTimeController.text.isNotEmpty ? bookingEndTimeController.text.trim() : "";
      String paymentTypeIdsString = apiSelectedPaymentTypeIds.isNotEmpty ? apiSelectedPaymentTypeIds.join(",") : "";
      String apiSortOrder = (selectAscending == "ASCENDING") ? "ASC" : "DESC";
      String apiSortBy = "";
      if (selectRefNumber != null) {
        apiSortBy = selectRefNumber!.toLowerCase().replaceAll(" ", "_");
      }

      var response = await Api().get(
        "bookings/booking-statistics",
        queryParameters: {
          "page": currentPage.value,
          "limit": limit,
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
          "from_time": startTime,
          "to_time": endTime,

          "reference_number": searchReferenceNo.value,
          "invoice_number": searchInvoiceNo.value,
          "pickup": searchPickup.value,
          "dropoff": searchDropOff.value,
          "customer": searchCustomer.value,
          "mobile": mobileController.text,
          "telephone": phoneController.text,
          "order_number": searchOrderNO.value,
          "fares": searchFare.value,
          "company_price": searchAccFare.value,
          "booked_by": bookedByController.text,
          "account_id": apiSelectedAccount?.id?.toString() ?? "",
          "employee_id": apiSelectedEmployee?.id?.toString() ?? "",
          "subsidiary_id": apiSelectedSubsidiary?.id?.toString() ?? "",
          "driver": searchDriver.value,
          "driver_id": selectDriverObject?.id?.toString() ?? "",
          "payment_type_id": paymentTypeIdsString,
          "booking_status_id": selectedBookingStatusIds,
          "sort_order": apiSortOrder,
          "sort_by": apiSortBy
        },
      );

      if (response.statusCode == 200) {
        bookingStatisticsModel = BookingStatisticsModel.fromJson(response.data);
        print("Total Statistics Bookings Found: ${bookingStatisticsModel?.totals?.totalBookings}");

        totalPages.value = bookingStatisticsModel?.totalPages ?? 1;

        totalBookings.value = bookingStatisticsModel?.totals?.totalBookings ?? 0;
        totalEarnings.value = bookingStatisticsModel?.totals?.totalEarnings ?? 0.0;
        totalAccountEarnings.value = bookingStatisticsModel?.totals?.totalAccountEarnings ?? 0.0;
      }
    } catch (e, stackTrace) {
      print("=================== API ERROR LOG ===================");
      print("Error fetching booking statistics: $e");
      print("Detailed StackTrace: $stackTrace");
      print("=====================================================");
    }
    finally {
      isLoadingStatistics = false;
      update();
    }
  }

  void onBookingSearchChanged() {
    currentPage.value = 1;
    getBookingStatistics();
  }

  void onBookingPageChange(int page) {
    currentPage.value = page;
    getBookingStatistics();
  }

  /// EDIT FARE
  bool isFareLoading = false;

  updateBookingFare(dynamic bookingId, String fare, int index) async {
    if (fare.isEmpty) {
      BotToast.showText(text: "PLEASE ENTER FARE AMOUNT");
      return;
    }
    isFareLoading = true;
    update();

    try {
      var formData = {
        "total_charges": fare,
      };
      var response = await Api().post(
        formData,
        "bookings/dashboard-fares/$bookingId",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: "FARE UPDATED SUCCESSFULLY");

        if (bookingStatisticsModel?.data != null) {
          bookingStatisticsModel!.data![index].fares = fare;
        }
        editingRowIndex.value = null;
      } else {
        BotToast.showText(text: "FAILED TO UPDATE FARE");
      }
    } catch (e) {
      print("Error updating fare: $e");
      BotToast.showText(text: "SOMETHING WENT WRONG");
    } finally {
      isFareLoading = false;
      update();
    }
  }

  final RxnInt editingRowIndex = RxnInt();
  final TextEditingController fareController = TextEditingController();

  // booking graph
  bool isLoadingGraph = false;
  int totalGraphBookings = 0;
  double totalGraphFares = 0.0;

  BookingGraph? bookingGraphModel;

  getBookingStatisticsGraph({String? statusId}) async {
    try {
      isLoadingGraph = true;
      update();

      String formattedFromDate = DateFormat('yyyy-MM-dd').format(bookingFromDate.value);
      String formattedToDate = DateFormat('yyyy-MM-dd').format(bookingToDate.value);

      print("=================== GRAPH API REQUEST LOG ===================");
      print("Status ID: $statusId");
      print("From Date: $formattedFromDate | To Date: $formattedToDate");
      print("=============================================================");

      var response = await Api().get("bookings/booking-statistics-graph",
          queryParameters: {
            "booking_status_id": statusId ?? "",
            "from_date": formattedFromDate,
            "to_date": formattedToDate,
          });

      if (response.statusCode == 200) {
        print("RAW GRAPH API RESPONSE: ${json.encode(response.data)}");

        bookingGraphModel = BookingGraph.fromJson(response.data);

        int tempBookings = 0;
        double tempFares = 0.0;

        print("=================== GRAPH DATA PARSING LOGS ===================");
        if (bookingGraphModel?.data != null && bookingGraphModel!.data!.isNotEmpty) {
          print("Total Dates Found in Graph Data: ${bookingGraphModel!.data!.length}");

          for (var datum in bookingGraphModel!.data!) {
            print("Date: ${datum.date}");
            if (datum.payments != null && datum.payments!.isNotEmpty) {
              for (var payment in datum.payments!) {
                print("  -> Payment Type from API: '${payment.paymentType}' | Bookings: ${payment.totalBookings} | Fares: ${payment.totalFares}");

                tempBookings += payment.totalBookings ?? 0;
                tempFares += (payment.totalFares ?? 0).toDouble();
              }
            } else {
              print("  -> No payments list found for this date.");
            }
          }
        } else {
          print("WARNING: bookingGraphModel?.data is NULL or EMPTY!");
        }
        print("===============================================================");

        totalGraphBookings = tempBookings;
        totalGraphFares = tempFares;
      } else {
        print("Server Error Graph API: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("=================== GRAPH API ERROR LOG ===================");
      print("Error fetching booking statistics graph: $e");
      print("Detailed StackTrace: $stackTrace");
      print("=====================================================");
    } finally {
      isLoadingGraph = false;
      update();
    }
  }

  void clearDropdowns() {
    if (apiDashboardData?.subsidiaries != null && apiDashboardData!.subsidiaries!.isNotEmpty) {
      apiSelectedSubsidiary = apiDashboardData!.subsidiaries!.first;
    } else {
      apiSelectedSubsidiary = null;
    }
    apiSelectedAccount = null;
    apiSelectedDepartment = null;
    apiSelectedEmployee = null;
    dashboardAccountModel = null;
    accountDepartmentsList.clear();
    update();
  }


  /// todo mobile search api

  SearchCustomerByMobileModel? searchCustomerByMobile;
  bool isSearchingCustomer = false;

  getCustomer(String mobile) async {
    isSearchingCustomer = true;
    var response = await Api().get(
      "customers/search-data?mobile=$mobile",
      sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      searchCustomerByMobile =
          SearchCustomerByMobileModel.fromJson(response.data);
      isSearchingCustomer = false;
      update();
    }
  }

void clearBookingReportData() {
  customerController.clear();
  mobileController.clear();
  phoneController.clear();
  pickUpController.clear();
  dropOffController.clear();
  orderNumberController.clear();
  bookedByController.clear();
  bookingStartTimeController.clear();
  bookingEndTimeController.clear();
  bookingFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
  bookingToDate.value = DateTime.now();
  bookingStatisticsModel = null;
  bookingGraphModel = null;
  apiSelectedEmployee = null;
  apiSelectedAccount = null;
  apiSelectedDepartment = null;
  apiSelectedPaymentTypeIds.clear();
  totalBookings.value = 0;
  totalEarnings.value = 0.0;
  totalAccountEarnings.value = 0.0;
  update();
}

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report booking functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report employee functionality

  RxBool isLoadingActivity = false.obs;
  EmployeeReportModel? employeeReportModel;
  // List<EmployeeShiftHistory> employeeActivityList = [];

  int totalCreated = 0;
  int totalDispatched = 0;
  int totalCancelled = 0;
  int totalCalls = 0;
  String totalWorkingHours = "";

  final activityStartTimeController = TextEditingController(text: "00:00");
  final activityEndTimeController = TextEditingController(text: "23:59");

  var activityFromDate = Rxn<DateTime>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var activityToDate = Rxn<DateTime>(DateTime.now());
  // var activityToDate = Rxn<DateTime>(DateTime.now().add(const Duration(days: 1)));

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<EmployeeShiftHistory> employeeShiftHistoryAll = <EmployeeShiftHistory>[].obs;
  RxList<EmployeeShiftHistory> employeeHistoryFiltered = <EmployeeShiftHistory>[].obs;
  RxString searchLoginDateTime = ''.obs;
  RxString searchLogoutDateTime = ''.obs;
  RxString searchBookingsCreated = ''.obs;
  RxString searchBookingsDispatched = ''.obs;
  RxString searchBookingsCancelled = ''.obs;
  RxString searchCallsAnswered = ''.obs;


  getEmployeeActivity() async {
    if (apiSelectedEmployee == null) {
      BotToast.showText(text: "PLEASE SELECT AN EMPLOYEE");
      return;
    }
    isLoadingActivity(true);

    try {
      String formattedFromDate = activityFromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(activityFromDate.value!)
          : "";
      String formattedToDate = activityToDate.value != null
          ? DateFormat('yyyy-MM-dd').format(activityToDate.value!)
          : "";

      String fromTime = activityStartTimeController.text.trim();
      String toTime = activityEndTimeController.text.trim();

      print("================== API REQUEST PARAMS ==================");
      print("employee_id : ${apiSelectedEmployee?.id}");
      print("from_date   : $formattedFromDate");
      print("to_date     : $formattedToDate");
      print("from_time   : $fromTime");
      print("to_time     : $toTime");
      print("========================================================");

      var response = await Api().get(
        "employee_shift_history/activity",
        queryParameters: {
          "employee_id": apiSelectedEmployee?.id.toString(),
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
          "from_time": fromTime,
          "to_time": toTime,

          "search_login": searchLoginDateTime.value.toLowerCase(),
          "search_logout": searchLogoutDateTime.value.toLowerCase(),
          "search_bookings_created": searchBookingsCreated.value.toLowerCase(),
          "search_bookings_dispatched": searchBookingsDispatched.value.toLowerCase(),
          "search_bookings_cancelled": searchBookingsCancelled.value.toLowerCase(),
          "search_calls_answered": searchCallsAnswered.value.toLowerCase(),
        },
      );

      if (response.statusCode == 200) {
        employeeReportModel = EmployeeReportModel.fromJson(response.data);
        // final fetchedList = employeeReportModel?.employeeShiftHistory ?? [];
        // employeeShiftHistoryAll.value = fetchedList;
        // employeeHistoryFiltered.value = fetchedList;
        //
        // if (fetchedList.isEmpty) {
        //   BotToast.showText(text: "No Data Found!");
        // }
        employeeShiftHistoryAll.value = employeeReportModel?.employeeShiftHistory ?? [];
        employeeHistoryFiltered.value = employeeShiftHistoryAll;

        if (employeeReportModel?.employeeShiftHistory == null ||
            employeeReportModel!.employeeShiftHistory!.isEmpty) {
          BotToast.showText(text: "No Data Found!");
        }

        print("Status Code: ${response.statusCode}");
        print("Response Data: ${response.data}");
        // employeeReportModel = employeeReportModel?.employeeShiftHistory ?? [];
        totalCreated = 0;
        totalDispatched = 0;
        totalCancelled = 0;
        totalCalls = 0;

        double calculatedTotalSeconds = 0;

        for (var item in employeeShiftHistoryAll) {
          totalCreated += item.bookingsCreated ?? 0;
          totalDispatched += item.bookingsDispatched ?? 0;
          totalCancelled += item.bookingsCancelled ?? 0;
          totalCalls += item.callsAnswered ?? 0;

          if (item.workingHours != null && item.workingHours!.isNotEmpty) {
            double milliSeconds = double.tryParse(item.workingHours!) ?? 0;
            calculatedTotalSeconds += (milliSeconds / 1000);
          }
        }

        int totalHours = calculatedTotalSeconds ~/ 3600;
        int totalMinutes = ((calculatedTotalSeconds % 3600) ~/ 60).toInt();

        if (totalHours > 0 && totalMinutes > 0) {
          totalWorkingHours = "$totalHours hours $totalMinutes minutes";
        } else if (totalHours > 0) {
          totalWorkingHours = "$totalHours hours";
        } else {
          totalWorkingHours = "$totalMinutes minutes";
        }
      }

      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
    } catch (e) {
      print("Error fetching employee activity: $e");
    } finally {
      isLoadingActivity(false);
      update();
    }
  }

  // -----------Search function
  void onSearchActivity() {
    getEmployeeActivity();
  }

  void clearActivityData() {
    employeeReportModel = null;
    apiSelectedEmployee = null;
    employeeShiftHistoryAll.clear();
    employeeHistoryFiltered.clear();
    activityFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    activityToDate.value = DateTime.now();
    activityStartTimeController.text = "00:00";
    activityEndTimeController.text = "23:59";
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report employee functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report income functionality

  // subsidiary
  SubsDiaryModel? subsDiaryModel;
  bool isLoadingSubsidiary = false;

  getSubsidiary() async {
    isLoadingSubsidiary = true;
    update();

    try {
      var response = await Api().get('subsidiaries/get', sendCompanyId: true);
      if (response.statusCode == 200) {
        subsDiaryModel = SubsDiaryModel.fromJson(response.data);
        if (subsDiaryModel?.subsidiaries?.isNotEmpty ?? false) {
          var defaultSubsidiary = subsDiaryModel!.subsidiaries!.first;
          apiSelectedSubsidiary = defaultSubsidiary;
          if (defaultSubsidiary.id != null) {
            getAccountData(defaultSubsidiary.id!);
          }
        }
      }
    } catch (e) {
      print("Error fetching subsidiary: $e");
    } finally {
      isLoadingSubsidiary = false;
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<IncomeBooking> incomeBookingAll = <IncomeBooking>[].obs;
  RxList<IncomeBooking> incomeBookingFiltered = <IncomeBooking>[].obs;
  RxString searchIncomeRef = ''.obs;
  RxString searchIncomeDateTime = ''.obs;
  RxString searchIncomePickup = ''.obs;
  RxString searchIncomeDropoff = ''.obs;
  RxString searchIncomeVehicle = ''.obs;
  RxString searchIncomeDriver = ''.obs;
  RxString searchIncomeAccount = ''.obs;
  RxString searchIncomeFares = ''.obs;
  RxString searchIncomeParking = ''.obs;
  RxString searchIncomeWaiting = ''.obs;
  RxString searchIncomeExtraDrop = ''.obs;
  RxString searchIncomeTotal = ''.obs;


  // filter
  var incomeFromDate = Rxn<DateTime>(DateTime(DateTime.now().year, DateTime.now().month, 1));
  var incomeToDate = Rxn<DateTime>(DateTime.now());
  IncomeModel? incomeModel;
  RxBool isLoadingIncome = false.obs;
  String selectedIncomePaymentType = "ALL";

  getIncome() async{
    isLoadingIncome(true);

    try {
      String formattedFromDate = incomeFromDate.value != null
          ? DateFormat('yyyy-MM-dd').format(incomeFromDate.value!)
          : "";

      String formattedToDate = incomeToDate.value != null
          ? DateFormat('yyyy-MM-dd').format(incomeToDate.value!)
          : "";

      String paymentTypeIdParam = "";
      if (selectedIncomePaymentType == "CASH") {
        paymentTypeIdParam = "1";
      } else if (selectedIncomePaymentType == "ACCOUNT") {
        paymentTypeIdParam = "3";
      }

      print("Selected Payment Type Text: $selectedIncomePaymentType");
      print("Sent payment_type_id to API: ${paymentTypeIdParam.isEmpty ? 'ALL (No ID Sent)' : paymentTypeIdParam}");

      var response = await Api().get("bookings/income-report",
        queryParameters: {
          "from_date": formattedFromDate,
          "to_date": formattedToDate,

          "search_ref": searchIncomeRef.value.toLowerCase(),
          "search_datetime": searchIncomeDateTime.value.toLowerCase(),
          "search_pickup": searchIncomePickup.value.toLowerCase(),
          "search_dropoff": searchIncomeDropoff.value.toLowerCase(),
          "search_vehicle": searchIncomeVehicle.value.toLowerCase(),
          "search_driver": searchIncomeDriver.value.toLowerCase(),
          "search_account": searchIncomeAccount.value.toLowerCase(),
          "search_fares": searchIncomeFares.value.toLowerCase(),
          "search_parking": searchIncomeParking.value.toLowerCase(),
          "search_waiting": searchIncomeWaiting.value.toLowerCase(),
          "search_extra_drop": searchIncomeExtraDrop.value.toLowerCase(),
          "search_total": searchIncomeTotal.value.toLowerCase(),

          if (selectDriverObject != null) "driver_id": selectDriverObject?.id.toString(),
        },
      );
      if (response.statusCode == 200) {
        incomeModel = IncomeModel.fromJson(response.data);
        incomeBookingAll.value = incomeModel?.bookings ?? [];
        incomeBookingFiltered.value = incomeBookingAll;
      }
    } catch (e) {
      debugPrint("Error fetching income report: $e");
    } finally {
      isLoadingIncome(false);
      update();
    }
  }

  // -----------Search function
  void onSearchIncome() {
    getIncome();
  }

  void clearIncomeData() {
    incomeModel = null;
    selectDriverObject = null;
    incomeFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    incomeToDate.value = DateTime.now();
    incomeBookingAll.clear();
    incomeBookingFiltered.clear();
    update();
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report income functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report company income functionality

  Rx<DateTime> companyFromDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  Rx<DateTime> companyToDate = DateTime.now().obs;

  CompanyIncomeModel? companyIncomeModel;
  RxBool companyLoader = false.obs;
  RxList<CompanyDatum> companyListAll = <CompanyDatum>[].obs;
  RxList<CompanyDatum> filteredCompany = <CompanyDatum>[].obs;

  RxString searchPickupDate = ''.obs;
  RxString searchPickupTime = ''.obs;
  RxString searchPc = ''.obs;
  RxString searchWc = ''.obs;
  RxString searchEdc = ''.obs;
  RxString searchMg = ''.obs;
  RxString searchCc = ''.obs;
  RxString searchTotal = ''.obs;

  var comTotalBookings = 0.obs;
  var comTotalEarnings = 0.0.obs;

  var comCurrentPage = 1.obs;
  var comTotalPages = 1.obs;
  final int comLimit = 20;

  getCompanyIncome() async {
    try {
      companyLoader(true);
      update();

      String formattedFromDate = "";
      String formattedToDate = "";

      formattedFromDate = DateFormat('yyyy-MM-dd').format(companyFromDate.value);
      formattedToDate = DateFormat('yyyy-MM-dd').format(companyToDate.value);

      var response = await Api().get(
        "bookings/booking-statistics",
        queryParameters: {
          "page": comCurrentPage.value,
          "limit": comLimit,
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
          "reference_number": searchReferenceNo.value,
          "pickup_date": searchPickupDate.value,
          "pickup_time": searchPickupTime.value,
          "pickup": searchPickup.value,
          "dropoff": searchDropOff.value,
          // "vehicle_type": searchVehicle.value,
          // "driver": searchDriver.value,
          // "account": searchAcc.value.toLowerCase(),
          // "fares": searchFare.value,
          // "parking_charges": searchPc.value,
          // "waiting_charges": searchWc.value,
          // "extra_drop_charges": searchEdc.value,
          // "meet_and_greet": searchMg.value,
          // "congestion_charges": searchCc.value,
          // "total_charges": searchTotal.value,
        },
      );

      if (response.statusCode == 200) {
        companyIncomeModel = CompanyIncomeModel.fromJson(response.data);
        comTotalPages.value = companyIncomeModel?.totalPages ?? 1;
        companyListAll.value = companyIncomeModel?.data ?? [];
        filteredCompany.value = companyListAll;

        comTotalBookings.value = companyIncomeModel?.totals?.totalBookings ?? 0;
        comTotalEarnings.value = companyIncomeModel?.totals?.totalEarnings ?? 0.0;
        print("Total Bookings Found: ${companyIncomeModel?.totals?.totalBookings}");
      }
    } catch (e, stackTrace) {
      print("=================== API ERROR LOG ===================");
      print("Error fetching booking statistics: $e");
      print("Detailed StackTrace: $stackTrace");
      print("=====================================================");
    }
    finally {
      companyLoader(false);
      update();
    }
  }
  void clearCompanyIncomeData() {
    companyIncomeModel = null;
    companyListAll.clear();
    filteredCompany.clear();
    companyFromDate.value = DateTime(DateTime.now().year, DateTime.now().month, 1);
    companyToDate.value = DateTime.now();
  }

  void onLocalSearchCompany() {
    if (searchVehicle.value.isEmpty &&
        searchDriver.value.isEmpty &&
        searchAcc.value.isEmpty &&
        searchFare.value.isEmpty &&
        searchPc.value.isEmpty &&
        searchWc.value.isEmpty &&
        searchEdc.value.isEmpty &&
        searchMg.value.isEmpty &&
        searchCc.value.isEmpty &&
        searchTotal.value.isEmpty) {

      filteredCompany.value = companyListAll;
    } else {
      filteredCompany.value = companyListAll.where((item) {
        final matchVehicle = item.vehicleType?.name?.toLowerCase().contains(searchVehicle.value.toLowerCase()) ?? true;
        final matchDriver = item.driver?.name?.toLowerCase().contains(searchDriver.value.toLowerCase()) ?? true;
        final matchAccount = item.account?.name?.toLowerCase().contains(searchAcc.value.toLowerCase()) ?? true;
        final matchFare = item.fares?.toLowerCase().contains(searchFare.value.toLowerCase()) ?? true;
        final matchPc = item.parkingCharges?.toLowerCase().contains(searchPc.value.toLowerCase()) ?? true;
        final matchWc = item.waitingCharges?.toLowerCase().contains(searchWc.value.toLowerCase()) ?? true;
        final matchEdc = item.extraDropCharges?.toLowerCase().contains(searchEdc.value.toLowerCase()) ?? true;
        final matchMg = item.meetAndGreet?.toLowerCase().contains(searchMg.value.toLowerCase()) ?? true;
        final matchCc = item.congestionCharges?.toLowerCase().contains(searchCc.value.toLowerCase()) ?? true;
        final matchTotal = item.totalCharges?.toLowerCase().contains(searchTotal.value.toLowerCase()) ?? true;

        return matchVehicle && matchDriver && matchAccount && matchFare &&
            matchPc && matchWc && matchEdc && matchMg && matchCc && matchTotal;
      }).toList();
    }
    update();
  }
  void onSearchCompany() {
    comCurrentPage.value = 1;
    getCompanyIncome();
  }

  void onPageCompany(int page) {
    comCurrentPage.value = page;
    getCompanyIncome();
  }


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo report company income functionality

  RxBool creditCardPaidValue = false.obs;
  /// booking in reports
  String? selectBookingDriver;
}