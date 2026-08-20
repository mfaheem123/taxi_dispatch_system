import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/customer/model/getCustomer.dart';
import 'package:dashboard_new1/view/customer/model/restricDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../dashboard_view/models/users_phone_numbers_model.dart';
import '../model/get_complaint_model.dart' hide Booking, Customer;
import '../model/get_customer_booking_model.dart' hide Driver;
import '../model/get_driver_dropdown.dart';
import '../model/get_lost_property_model.dart';
import '../model/lost_property_getById__model.dart';
import '../model/search_customer_by_mobile.dart';

class CustomerController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo adding customer functionality
  RxBool enableSms = false.obs;

  /// text fields controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final telController = TextEditingController();
  final doorController = TextEditingController();
  final noteController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();

  RestricDriverModel? restricDriverModel;
  RxBool restricDriverLoader = false.obs;

  void clearForm() {
    enableSms.value = false;
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    telController.clear();
    doorController.clear();
    noteController.clear();
    address1Controller.clear();
    address2Controller.clear();
    updateCustomerValue(false);
    customerUpdateId.value = 0;
    update();
  }

  List<Map<String, dynamic>> get apiDriversList {
    if (restricDriverModel == null || restricDriverModel!.drivers!.isEmpty) {
      return [];
    }
    return restricDriverModel!.drivers!.map((d) {
      return {
        'id': d.id,
        'username': d.username,
        'name': d.name,
      };
    }).toList();
  }

  getRestricDriver() async {
    restricDriverLoader(true);
    var response = await Api().get("drivers/get", sendCompanyId: true,);
    if (response.statusCode == 200) {
      restricDriverModel = RestricDriverModel.fromJson(response.data);
      restricDriverLoader(false);
      update();
    }
  }

  RxBool postCustomerLoad = false.obs;
  postCustomer() async {
    postCustomerLoad(true);

    var formData = {
      "name": nameController.text,
      "email": emailController.text,
      "mobile": mobileController.text,
      "telephone": telController.text,
      "door_number": doorController.text,
      "notes": noteController.text,
      "address1": address1Controller.text,
      "address2": address2Controller.text,
      "restricted_drivers": apiDriversList,
      "sms_flag" : enableSms.value,
    };
    print(formData);
    var response = await Api().post(
      formData,
      updateCustomerValue.value == false
          ? "customers/add"
          : 'customers/edit/${customerUpdateId.value}',
      auth: true,
      sendCompanyId: true,
    );
    if (response.statusCode == 200) {
      BotToast.showText(
          text: updateCustomerValue.value
              ? "CUSTOMER UPDATED SUCCESSFULLY"
              : 'CUSTOMER ADDED SUCCESSFULLY');

      print("✅ Account Created Successfully=== $response" );
      enableSms.value = false;
      nameController.clear();
      emailController.clear();
      mobileController.clear();
      telController.clear();
      doorController.clear();
      noteController.clear();
      address1Controller.clear();
      address2Controller.clear();
      updateCustomerValue(false);
      update();
    } else {
      print("❌ Error Creating Account");
      print(response);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo adding customer functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  GetCustomerModel? getCustomerModel;
  RxBool customerLoader = false.obs;
  String? selectFilterType;
  RxBool blackList = false.obs;

  ///--------------------- Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  final int limit = 20;

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<Customer> customerListAll = <Customer>[].obs;
  RxList<Customer> filteredCustomer = <Customer>[].obs;
  RxString searchName = ''.obs;
  RxString searchMobile = ''.obs;
  RxString searchTele = ''.obs;
  RxString searchEmail = ''.obs;
  RxString searchAddress = ''.obs;

  /// text fields controllers
  final keyWordsController = TextEditingController();
  getCustomer() async {
    customerLoader(true);
    var response = await Api().get("customers/get?", queryParameters: {
      'page': currentPage.value,
      'blacklist': blackList.value,
      'limit': limit,
      "name": searchName.value.toLowerCase(),
      "mobile": searchMobile.value.toLowerCase(),
      "telephone": searchTele.value.toLowerCase(),
      "email": searchEmail.value.toLowerCase(),
      "address1": searchAddress.value.toLowerCase(),
    },
sendCompanyId: true,    
    );
    if (response.statusCode == 200) {
      getCustomerModel = GetCustomerModel.fromJson(response.data);
      totalPages.value = getCustomerModel?.totalPages ?? 1;
      customerListAll.value = getCustomerModel?.customers ?? [];
      filteredCustomer.value = customerListAll;
      customerLoader(false);
      update();
    }
  }

  // -----------Search changes function
  void onSearchCustomer() {
    currentPage.value = 1;
    getCustomer();
  }

  /// ------- pagination function
  void onPageCustomer(int page) {
    currentPage.value = page;
    getCustomer();
  }

  RxBool updateCustomerValue = false.obs;
  RxInt customerUpdateId = 0.obs;
  customerUpdate({Customer? customerUpdate}) async {
    customerUpdateId.value = customerUpdate!.id!;
    enableSms.value= customerUpdate.smsFlag!;
    nameController.text = customerUpdate.name!;
    emailController.text = customerUpdate.email!;
    mobileController.text = customerUpdate.mobile!;
    telController.text = customerUpdate.telephone!;
    doorController.text = customerUpdate.doorNumber!;
    noteController.text = customerUpdate.notes!;
    address1Controller.text = customerUpdate.address1!;
    address2Controller.text = customerUpdate.address2!;
    updateCustomerValue(true);
  }

  deleteCustomer(int? id) async {
    var response = await Api().delete("customers/delete/$id");
    if (response.statusCode == 200) {
      getCustomer();
      BotToast.showText(text: "CUSTOMER DELETED SUCCESSFULLY!");
      print(json.encode(response.data));
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  /// text fields controllers
  final detailOfPropertyController = TextEditingController();
  final methodOfDespositionController = TextEditingController();
  final checkedByController = TextEditingController();
  final enquiryController = TextEditingController();
  final resultController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality

  /// int variables
  int bookingRadio = 0;

  /// String variables
  String? selectDriver;

  /// text fields controllers
  final refNoController = TextEditingController();
  final regController = TextEditingController();
  final complaintController = TextEditingController();
  final howDealWithController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo customers list functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create lost property functionality

  final propertyNameController = TextEditingController();
  final propertyMobileController = TextEditingController();
  final propertyAddressController = TextEditingController();


  int? updateBookingId;
  int? updateCustomerId;
  final ScrollController listScrollController = ScrollController();

  void scrollToIndex(int index) {
    if (listScrollController.hasClients) {
      double itemHeight = 45.0;
      double targetOffset = index * itemHeight;
      double currentScroll = listScrollController.offset;
      double viewportHeight = 300.0;
      if (targetOffset + itemHeight > currentScroll + viewportHeight) {
        listScrollController.animateTo(
          (targetOffset - viewportHeight + itemHeight) + 40,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      } else if (targetOffset < currentScroll) {
        listScrollController.animateTo(
          targetOffset - 20,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  String reportDateController = "";
  String lostDateController = "";

  SearchCustomerByMobileModel? getPhoneNumbersModel;
  bool dataLoader = false;
  int selectedIndex = -1;

  getCustomerNumbers(String mobile) async {
    dataLoader = true;
    var response = await Api().get("customers/search-data?mobile=$mobile",sendCompanyId: true,);
    if (response.statusCode == 200) {
      getPhoneNumbersModel =
          SearchCustomerByMobileModel.fromJson(response.data);
      dataLoader = false;
      update();
    }
  }

  var selectedBookingForLostProperty;
  //  Get Bookings (Alert Screen)
  GetCustomerBookingModel? getCustomerBookingModel;
  bool bookingsLoader = false;

  getCustomerJobs(String query) async {
    bookingsLoader = true;

    try {
      String param = int.tryParse(query) != null ? "mobile" : "name";
      var response = await Api().get("bookings/customer-jobs?$param=$query", sendCompanyId: true);
      if (response.statusCode == 200) {
        getCustomerBookingModel =
            GetCustomerBookingModel.fromJson(response.data);
        print("Data Loaded: ${response.data}");
      } else {
        print("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      bookingsLoader = false;
      update();
    }
  }



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo create lost property functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo list of lost property functionality

  GetLostPropertyModel? lostPropertyModel;
  RxBool lostPropertyLoader = false.obs;

  /// >>>>>>>>>>>>>>>>>>>>> Search Work
  RxList<LostProperty> lostPropertyAll = <LostProperty>[].obs;
  RxList<LostProperty> filteredLostProperty = <LostProperty>[].obs;
  RxString searchLostNumber = ''.obs;
  RxString searchReportDate = ''.obs;
  RxString searchLostDate = ''.obs;
  RxString searchCustomer = ''.obs;
  RxString searchItemDescription = ''.obs;

  ///--------------------- Pagination
  var currentPageLostProperty = 1.obs;
  var totalPagesLostProperty = 1.obs;
  final int limitLostProperty = 20;

  getAllLostProperty() async {
    lostPropertyLoader(true);
    var response = await Api().get("lost-property/get", queryParameters: {
      "lost_number": searchLostNumber.value.toLowerCase(),
      "report_date": searchReportDate.value.toLowerCase(),
      "lost_date": searchLostDate.value.toLowerCase(),
      "item_description": searchItemDescription.value.toLowerCase(),
      "name": searchCustomer.value.toLowerCase(),
    }, sendCompanyId: true,);
    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Raw Data: ${response.data}");
      lostPropertyModel = GetLostPropertyModel.fromJson(response.data);
      totalPagesLostProperty.value = lostPropertyModel?.totalPages ?? 1;
      lostPropertyAll.value = lostPropertyModel?.lostProperties ?? [];
      filteredLostProperty.value = lostPropertyAll;
      print("Total Items Received: ${lostPropertyAll.length}");
      lostPropertyLoader(false);
      update();
    }
  }

  /// -----------Search changes function
  void onSearchLostProperty() {
    currentPageLostProperty.value = 1;
    getAllLostProperty();
  }

  /// ------- pagination function
  void onPageLostProperty(int page) {
    currentPageLostProperty.value = page;
    getAllLostProperty();
  }
  // Save Api
  bool saveLostPropertyLoad = false;

  saveLostProperty() async {
    if (selectedBookingForLostProperty == null) {
      BotToast.showText(text: "PLEASE SELECT A BOOKING FIRST!");
      return;
    }

      saveLostPropertyLoad = true;
      update();

    bool isUpdating = lostPropertyValue.value || lostPropertyUpdateId.value != 0;

      var formData = {
        // "booking_id": selectedBookingForLostProperty?.id.toString(),
        // "customer_id": selectedBookingForLostProperty?.customerId.toString(),
        "booking_id":
        (updateBookingId ?? selectedBookingForLostProperty?.id).toString(),
        "customer_id":
        (updateCustomerId ?? selectedBookingForLostProperty?.customerId)
            .toString(),
        "item_description": detailOfPropertyController.text,
        "inquiry": enquiryController.text,
        "checked_by": checkedByController.text,
        "method_desposition": methodOfDespositionController.text,
        "result": resultController.text,
        "lost_date": lostDateController,
        "report_date": reportDateController,
      };
      print("Sending Data: $formData");

      var response = await Api().post(
          formData,
          isUpdating
              ? "lost-property/update/${lostPropertyUpdateId.value}"
              : "lost-property/add",
          sendCompanyId: true,  auth: true);
      if (response.statusCode == 200) {
        BotToast.showText(
            text: isUpdating
                ? "LOST PROPERTY UPDATED SUCCESSFULLY"
                : 'LOST PROPERTY ADDED SUCCESSFULLY');
        refreshFields();
      }

    saveLostPropertyLoad = false;
    update();
  }

  refreshFields() {
    lostPropertyModel = null;
    selectedBookingForLostProperty = null;
    updateBookingId = null;
    updateCustomerId = null;

    lostPropertyUpdateId.value = 0;
    lostPropertyValue(false);

    detailOfPropertyController.clear();
    methodOfDespositionController.clear();
    propertyNameController.clear();
    propertyMobileController.clear();
    propertyAddressController.clear();
    enquiryController.clear();
    checkedByController.clear();
    resultController.clear();

    reportDateController = "";
    lostDateController = "";

    update();
    // lostPropertyValue(false);
  }
  RxBool lostPropertyValue = false.obs;
  RxInt lostPropertyUpdateId = 0.obs;

  // lostPropertyUpdate({dynamic lostPropertyUpdate}) async {
  //   print("--- BINDING START ---");
  //
  //   lostPropertyUpdateId.value = lostPropertyUpdate?.id;
  //   nameController.text = lostPropertyUpdate?.customer?.name ?? "";
  //   detailOfPropertyController.text = lostPropertyUpdate?.itemDescription ?? "";
  //   lostDateController = lostPropertyUpdate?.lostDate != null
  //       ? lostPropertyUpdate.lostDate.toString().split(' ')[0]
  //       : "";
  //   reportDateController = lostPropertyUpdate?.reportDate != null
  //       ? lostPropertyUpdate.reportDate.toString().split(' ')[0]
  //       : "";
  //
  //   lostPropertyValue(true);
  //   update();
  //
  //   try {
  //     print("Calling API for ID: ${lostPropertyUpdate.id}");
  //
  //     final response =
  //         await Api().get("lost-property/getbyid/${lostPropertyUpdate.id}",sendCompanyId: true);
  //     print("API Raw Data: ${response.data}");
  //
  //     if (response != null && response.data != null) {
  //       var apiModel = LostPropertyGetByIdModel.fromJson(response.data);
  //       var detail = apiModel.lostProperty;
  //
  //       if (detail != null) {
  //         updateBookingId = detail.bookingId;
  //         updateCustomerId = detail.customerId;
  //         mobileController.text = detail.mobile ?? "";
  //         address1Controller.text = detail.address1?.toString() ??
  //             detail.customer?.address1?.toString() ??
  //             "";
  //         // address1Controller.text = detail.address1 ?? "";
  //         checkedByController.text = detail.checkedBy ?? "";
  //         enquiryController.text = detail.inquiry ?? "";
  //         resultController.text = detail.result ?? "";
  //         methodOfDespositionController.text = detail.methodDesposition ?? "";
  //
  //         if (detail.booking != null) {
  //           selectedBookingForLostProperty = detail.booking;
  //         } else {
  //           selectedBookingForLostProperty = BookingGetById(
  //             referenceNumber: detail.referenceNumber,
  //             pickupDate: detail.pickupDate,
  //             pickupTime: detail.pickupTime,
  //             pickup: detail.pickup,
  //             dropoff: detail.dropoff,
  //             vehicleType: VehicleTypeGetById(name: detail.vehicleTypeName),
  //           );
  //         }
  //
  //         print(
  //             "Table Data Bound: ${selectedBookingForLostProperty?.referenceNumber}");
  //       }
  //     }
  //   } catch (e) {
  //     print("Caught Error in Controller: $e");
  //   }
  //
  //   update();
  //   print("--- BINDING END ---");
  // }
  lostPropertyUpdate({dynamic lostPropertyUpdate}) async {
    print("--- BINDING START ---");

    if (lostPropertyUpdate == null) {
      print("Error: lostPropertyUpdate object is null");
      return;
    }

    lostPropertyUpdateId.value = lostPropertyUpdate.id ?? 0;
    lostPropertyValue(true);
    update();

    //  Form fields  binding
    propertyNameController.text = lostPropertyUpdate.customer?.name ?? "";
    detailOfPropertyController.text = lostPropertyUpdate.itemDescription ?? "";

    lostDateController = lostPropertyUpdate.lostDate != null
        ? lostPropertyUpdate.lostDate.toString().split(' ')[0]
        : "";
    reportDateController = lostPropertyUpdate.reportDate != null
        ? lostPropertyUpdate.reportDate.toString().split(' ')[0]
        : "";

    try {
      print("Calling API for ID: ${lostPropertyUpdate.id}");

      final response = await Api().get("lost-property/getbyid/${lostPropertyUpdate.id}", sendCompanyId: true);
      print("API Raw Data: ${response?.data}");

      if (response != null && response.data != null) {
        var apiModel = LostPropertyGetByIdModel.fromJson(response.data);
        var detail = apiModel.lostProperty;

        if (detail != null) {
          updateBookingId = detail.bookingId ?? lostPropertyUpdate.bookingId;
          updateCustomerId = detail.customerId ?? lostPropertyUpdate.customerId;
          propertyMobileController.text = detail.mobile ?? "";

          propertyAddressController.text = detail.address1?.toString() ??
              detail.customer?.address1?.toString() ??
              "";

          checkedByController.text = detail.checkedBy ?? "";
          enquiryController.text = detail.inquiry ?? "";
          resultController.text = detail.result ?? "";
          methodOfDespositionController.text = detail.methodDesposition ?? "";

          if (detail.booking != null) {
            selectedBookingForLostProperty = detail.booking;
          } else {
            selectedBookingForLostProperty = BookingGetById(
              referenceNumber: detail.referenceNumber,
              pickupDate: detail.pickupDate,
              pickupTime: detail.pickupTime,
              pickup: detail.pickup,
              dropoff: detail.dropoff,
              vehicleType: VehicleTypeGetById(name: detail.vehicleTypeName),
            );
          }
          print("Table Data Bound: ${selectedBookingForLostProperty?.referenceNumber}");
        }
      }
    } catch (e) {
      print("Caught Error in Controller API Call: $e");
      // Agar API fail bhi ho jaye, tab bhi update mode true hi rehna chahiye
    }

    // Final UI sync
    update();
    print("--- BINDING END ---");
  }
  deleteLostProperty(int? id) async {
    var response = await Api().delete("lost-property/delete/$id");
    if (response.statusCode == 200) {
      getAllLostProperty();
      BotToast.showText(text: "LOST PROPERTY DELETED SUCCESSFULLY");
      print("Lost Property Deleted successfully!");
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo list of lost property functionality

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Working on create complain


  final customerMobileController = TextEditingController();
  final customerNameController = TextEditingController();
  final incidentedController = TextEditingController();
  final customerNoteController = TextEditingController();
  final customerRefNoController = TextEditingController();
  final complainDateController = TextEditingController(  text: DateTime.now().toIso8601String().split("T").first,);
  String pickupAddress = "";
  String dropoffAddress = "";


  final FocusNode complaintFocusNode = FocusNode();
  SearchCustomerByMobileModel? complaintPhoneNumbersModel;
  int complaintSelectedIndex = -1;

  var selectedBookingForComplaint;

  getComplaintCustomerNumbers(String mobile) async {
    var response = await Api().get(
      "customers/search-data?mobile=$mobile",
      sendCompanyId: true,
    );

    if (response.statusCode == 200) {
      complaintPhoneNumbersModel =
          SearchCustomerByMobileModel.fromJson(response.data);

      update();
    }
  }
  void fillComplaintFromBooking(dynamic booking) {
    if (booking == null) return;

    final Booking b = booking as Booking;

    customerNameController.text = (b.name ?? "").toUpperCase();
    customerMobileController.text = (b.mobile ?? "").toUpperCase();
    customerRefNoController.text = (b.referenceNumber ?? "").toUpperCase();

    // ✅ FIXED VEHICLE PATH
    regController.text = (b.driver?.vehicle?.vehicleNumber ?? "").toUpperCase();

    final notes = jsonDecode(b.notes.toString());

    customerNoteController.text =
    notes.isNotEmpty ? notes.first["note"] ?? "" : "";

    // if (b.notes != null && b.notes is List) {
    //   customerNoteController.text =
    //       (b.notes as List).map((e) => e.toString()).join(", ");
    // } else {
    //   customerNoteController.text = "";
    // }

    incidentedController.text = b.pickupDate ?? "";

    pickupAddress =( b.pickup)?.toUpperCase() ?? "";
    dropoffAddress = (b.dropoff)?.toUpperCase() ?? "";

    selectedBookingForComplaint = b;

    update();
  }
  GetDriverDropdown? getDriverDropdownModel;
  List<Driver> driverList = [];

  Driver? selectedDriver;

  bool driverLoader = false;
//driver dropdown api
  getDriversDropdown() async {
    driverLoader = true;
    update();

    try {
      var response = await Api().get(
        "drivers/get",
        sendCompanyId: true,
      );

      if (response.statusCode == 200) {
        getDriverDropdownModel =
            GetDriverDropdown.fromJson(response.data);

        driverList = getDriverDropdownModel?.drivers ?? [];

        // 👇 IMPORTANT
        if (selectedDriver != null) {
          selectedDriver = driverList.firstWhereOrNull(
                (e) => e.id.toString() == selectedDriver!.id.toString(),
          );
        }

        print("Drivers loaded: ${driverList.length}");
      }
    } catch (e) {
      print(e);
    }

    driverLoader = false;
    update();
  }

 String capitalizeWords(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toUpperCase()}'
        : '')
        .join(' ');
  }
  bool complaintLoader = false;

  postComplaintLoad(bool value) {
    complaintLoader = value;
    update();
  }

  postComplaint() async {
    postComplaintLoad(true);

    var formData = {
      "complain_date": complainDateController.text,
      "incident_date": incidentedController.text,

      "customer_id": complaintValue.value
          ? updateComplainCustomerId
          : selectedBookingForComplaint?.customerId,

      "booking_id": complaintValue.value
          ? updateComplainBookingId
          : selectedBookingForComplaint?.id,

      "complaint": complaintController.text,
      "dealt_with": howDealWithController.text,
      "result": resultController.text,

      "driver_id": selectedDriver?.id,
    };

    print(formData);

    var response = await Api().post(
      formData,
      complaintValue.value
          ? "complaint/update/${complaintUpdateId.value}"
          : "complaint/add",
      auth: true,
      sendCompanyId: true,
    );

    if (response != null &&
        (response.statusCode == 200 ||
            response.statusCode == 201)) {
      BotToast.showText(
        text: complaintValue.value
            ? "COMPLAINT UPDATED SUCCESSFULLY"
            : "COMPLAINT ADDED SUCCESSFULLY",
      );

      // Reset edit mode
      complaintValue.value = false;
      complaintUpdateId.value = 0;
      updateCustomerId = null;
      updateBookingId = null;

      // Clear Controllers
      // complainDateController.text =
      //     DateTime.now().toIso8601String().split("T").first;
      complainDateController.clear();
      incidentedController.clear();
      customerNameController.clear();
      customerMobileController.clear();
      customerRefNoController.clear();
      customerNoteController.clear();
      regController.clear();


      complaintController.clear();
      howDealWithController.clear();
      resultController.clear();


      pickupAddress = "";
      dropoffAddress = "";

      selectedBookingForComplaint = null;
      selectedDriver = null;

      await getCustomerComplaints();

      update();
    } else {
      BotToast.showText(
        text: complaintValue.value
            ? "FAILED TO UPDATE COMPLAINT"
            : "FAILED TO ADD COMPLAINT",
      );

      print(response?.data);
    }

    postComplaintLoad(false);
  }

  void clearComplaintForm() {
    complaintValue.value = false;
    complaintUpdateId.value = 0;
    updateCustomerId = null;
    updateBookingId = null;

    // Clear Controllers
    // complainDateController.text =
    //     DateTime.now().toIso8601String().split("T").first;
    complainDateController.clear();
    incidentedController.clear();
    customerNameController.clear();
    customerMobileController.clear();
    customerRefNoController.clear();
    customerNoteController.clear();
    regController.clear();
    complaintController.clear();
    howDealWithController.clear();
    resultController.clear();
    pickupAddress = "";
    dropoffAddress = "";
    selectedBookingForComplaint = null;
    selectedDriver = null;
    update();
  }


  GetCustomerComplainsModel? getCustomerComplainsModel;
  RxBool complaintsLoader = false.obs;

  /// Search Work
  RxList<Complaint> complaintsAll = <Complaint>[].obs;
  RxList<Complaint> filteredComplaints = <Complaint>[].obs;

  RxString searchReferenceNumber = ''.obs;
  RxString searchComplainDate = ''.obs;
  RxString searchCustomerName = ''.obs;
  RxString searchComplaint = ''.obs;

  /// Pagination
  var currentPageComplaints = 1.obs;
  var totalPagesComplaints = 1.obs;
  final int limitComplaints = 20;

  Future<void> getCustomerComplaints() async {
    complaintsLoader(true);

    try {
      var response = await Api().get(
        "complaint/get", sendCompanyId: true,auth: true,
      );

      print("Status Code => ${response.statusCode}");
      print("Response => ${response.data}");

      if (response.statusCode == 200) {
        getCustomerComplainsModel = GetCustomerComplainsModel.fromJson(response.data);

        complaintsAll.value = getCustomerComplainsModel?.complaints ?? [];

        filteredComplaints.value = List<Complaint>.from(complaintsAll);

        print("Total Complaints => ${filteredComplaints.length}");

        update();
      }
    } catch (e, s) {
      print("Get Complaints Error => $e");
      print(s);
    } finally {
      complaintsLoader(false);
      update();
    }
  }



  void searchComplaints() {
    filteredComplaints.value = complaintsAll.where((item) {
      final ref = (item.referenceNumber ?? "").toLowerCase();

      final date = item.complainDate == null
          ? ""
          : "${item.complainDate!.day}/${item.complainDate!.month}/${item.complainDate!.year}"
          .toLowerCase();

      final customer = (item.customer?.name ?? "").toLowerCase();

      return ref.contains(searchReferenceNumber.value.toLowerCase()) &&
          date.contains(searchComplainDate.value.toLowerCase()) &&
          customer.contains(searchCustomerName.value.toLowerCase());
    }).toList();

    update();
  }





  void clearComplaintsSearch() {
    searchReferenceNumber.value = "";
    searchComplainDate.value = "";
    searchCustomerName.value = "";

    filteredComplaints.value = List<Complaint>.from(complaintsAll);

    update();
  }

// complaint edit
  RxBool complaintValue = false.obs;
  RxInt complaintUpdateId = 0.obs;
  int? updateComplainCustomerId;
  int? updateComplainBookingId;

  Future<void> complaintUpdate({required int complaintId}) async {
    complaintValue.value = true;
    complaintUpdateId.value = complaintId;

    try {
      // Load drivers first
      if (driverList.isEmpty) {
        await getDriversDropdown();
      }

      var response = await Api().get(
        "complaint/getbyid/?id=$complaintId",
        sendCompanyId: true,
      );

      if (response.statusCode == 200 && response.data["status"] == true) {
        final detail = response.data["complaint"];

        updateComplainCustomerId = detail["customer_id"];
        updateComplainBookingId = detail["booking_id"];

        customerNameController.text =
            (detail["customer"]?["name"] ?? "").toString().toUpperCase();

        customerMobileController.text =
            (detail["customer"]?["mobile"] ?? "").toString().toUpperCase();

        customerRefNoController.text =
            (detail["booking"]?["reference_number"] ?? "")
                .toString()
                .toUpperCase();

        complainDateController.text =
            (detail["complain_date"] ?? "").toString().toUpperCase();

        incidentedController.text =
            (detail["incident_date"] ?? "").toString().toUpperCase();

        complaintController.text =
            (detail["complaint"] ?? "").toString().toUpperCase();

        howDealWithController.text =
            (detail["dealt_with"] ?? "").toString().toUpperCase();

        resultController.text =
            (detail["result"] ?? "").toString().toUpperCase();

        final notes = jsonDecode(detail["booking"]["notes"] ?? "[]");

        customerNoteController.text = notes.isNotEmpty
            ? (notes.first["note"] ?? "").toString().toUpperCase()
            : "";

        pickupAddress =
            (detail["booking"]?["pickup"] ?? "").toString().toUpperCase();

        dropoffAddress =
            (detail["booking"]?["dropoff"] ?? "").toString().toUpperCase();

        // Driver Select
        final driverId = detail["driver_id"];

        print("Complaint Driver ID => $driverId");
        print(
          "Driver List => ${driverList.map((e) => "${e.id}-${e.name}").toList()}",
        );

        if (driverId != null && driverId.toString().isNotEmpty && driverId.toString() != "null") {
          selectedDriver = driverList.firstWhereOrNull(
                (e) => e.id.toString().trim() == driverId.toString().trim(),
          );
        } else {
          selectedDriver = null;
        }

        print("Selected Driver => ${selectedDriver?.name}");

        update();
      }
    } catch (e) {
      print("Complaint Update Error: $e");
    }
  }

 deleteComplaint(int? id) async {
    var response = await Api().delete(
      "complaint/delete/$id",
    );

    if (response.statusCode == 200) {
      getCustomerComplaints();
      BotToast.showText(
        text: "COMPLAINT DELETED SUCCESSFULLY",
      );
      print("Complaint Deleted Successfully!");
    }
  }
}
