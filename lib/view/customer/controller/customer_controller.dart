import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/customer/model/getCustomer.dart';
import 'package:dashboard_new1/view/customer/model/restricDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../dashboard_view/models/users_phone_numbers_model.dart';
import '../model/get_customer_booking_model.dart';
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
    var response = await Api().get("drivers/get");
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
  final int limit = 10;

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
      var response = await Api().get("bookings/customer-jobs?$param=$query");
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

  // Save Api
  bool saveLostPropertyLoad = false;

  saveLostProperty() async {
    if (selectedBookingForLostProperty == null) {
      BotToast.showText(text: "PLEASE SELECT A BOOKING FIRST!");
      return;
    }
    try {
      saveLostPropertyLoad = true;
      update();

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
          lostPropertyValue.value == false
              ? "lost-property/add"
              : "lost-property/update/${lostPropertyUpdateId.value}",
        sendCompanyId: true,  auth: true);
      if (response.statusCode == 200) {
        BotToast.showText(
            text: lostPropertyValue.value
                ? "LOST PROPERTY UPDATED SUCCESSFULLY"
                : 'LOST PROPERTY ADDED SUCCESSFULLY');
        refreshFields();
      }
    } catch (err) {
      print("Error: $err");
    }
    saveLostPropertyLoad = false;
    update();
  }

  refreshFields() {
    selectedBookingForLostProperty = null;
    detailOfPropertyController.clear();
    methodOfDespositionController.clear();
    nameController.clear();
    mobileController.clear();
    address1Controller.clear();
    enquiryController.clear();
    checkedByController.clear();
    resultController.clear();
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
  final int limitLostProperty = 10;

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

  RxBool lostPropertyValue = false.obs;
  RxInt lostPropertyUpdateId = 0.obs;

  lostPropertyUpdate({dynamic lostPropertyUpdate}) async {
    print("--- BINDING START ---");

    lostPropertyUpdateId.value = lostPropertyUpdate?.id;
    nameController.text = lostPropertyUpdate?.customer?.name ?? "";
    detailOfPropertyController.text = lostPropertyUpdate?.itemDescription ?? "";
    lostDateController = lostPropertyUpdate?.lostDate != null
        ? lostPropertyUpdate.lostDate.toString().split(' ')[0]
        : "";
    reportDateController = lostPropertyUpdate?.reportDate != null
        ? lostPropertyUpdate.reportDate.toString().split(' ')[0]
        : "";

    lostPropertyValue(true);
    update();

    try {
      print("Calling API for ID: ${lostPropertyUpdate.id}");

      final response =
          await Api().get("lost-property/getbyid/${lostPropertyUpdate.id}",sendCompanyId: true);
      print("API Raw Data: ${response.data}");

      if (response != null && response.data != null) {
        var apiModel = LostPropertyGetByIdModel.fromJson(response.data);
        var detail = apiModel.lostProperty;

        if (detail != null) {
          updateBookingId = detail.bookingId;
          updateCustomerId = detail.customerId;
          mobileController.text = detail.mobile ?? "";
          address1Controller.text = detail.address1?.toString() ??
              detail.customer?.address1?.toString() ??
              "";
          // address1Controller.text = detail.address1 ?? "";
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

          print(
              "Table Data Bound: ${selectedBookingForLostProperty?.referenceNumber}");
        }
      }
    } catch (e) {
      print("Caught Error in Controller: $e");
    }

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
  late var incidentedController = TextEditingController();
  final customerNoteController = TextEditingController();
  final customerRefNoController = TextEditingController();

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

    // 👇 Customer Info
    customerNameController.text = booking.name ?? "";
    customerMobileController.text = booking.mobile ?? "";

    // 👇 Booking Info
    refNoController.text = booking.referenceNumber ?? "";
    regController.text = booking.regNumber ?? "";

    // // 👇 Route
    // complaintController.text =
    // "Pickup: ${booking.pickup ?? ''}\nDropoff: ${booking.dropoff ?? ''}";

    // 👇 Date mapping
    // incident date = pickup date
    // complain date = today (optional)
    incidentedController = booking.pickupDate ?? "";

    // 👇 Notes / default fill (optional)
    customerNoteController.text = booking.notes ?? "";

    // store selected booking
    selectedBookingForComplaint = booking;

    update();
  }

}
