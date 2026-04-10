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
    );
    if (response.statusCode == 200) {
      BotToast.showText(
          text: updateCustomerValue.value
              ? "'Customer Updated Successfully'"
              : 'Customer Added Successfully');

      print("✅ Account Created Successfully");
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
    });
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
      BotToast.showText(text: "Customer deleted successfully!");
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

  String reportDateController = "";
  String lostDateController = "";

  GetPhoneNumbersModel? getPhoneNumbersModel;
  bool dataLoader = false;
  int selectedIndex = -1;

  getCustomerNumbers(String mobile) async {
    dataLoader = true;
    var response = await Api().get("customers/search?mobile=$mobile");
    if (response.statusCode == 200) {
      getPhoneNumbersModel = GetPhoneNumbersModel.fromJson(response.data);
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
      BotToast.showText(text: "Please select a booking first!");
      return;
    }
    try {
      saveLostPropertyLoad = true;
      update();

      var formData = {
        "booking_id": selectedBookingForLostProperty?.id.toString(),
        "customer_id": selectedBookingForLostProperty?.customerId.toString(),
        "item_description": detailOfPropertyController.text,
        "inquiry": enquiryController.text,
        "checked_by": checkedByController.text,
        "method_desposition": methodOfDespositionController.text,
        "result": resultController.text,
        "lost_date": lostDateController,
        "report_date": reportDateController,
      };
      print("Sending Data: $formData");

      var response =
          await Api().post(formData, "lost-property/add", auth: true);
      if (response.statusCode == 200) {
        BotToast.showText(text: "Lost Property Added Successfully");
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
    print("Params: lost_number: ${searchLostNumber.value}, report_date: ${searchReportDate.value}");
    var response = await Api().get("lost-property/get", queryParameters: {
      "lost_number": searchLostNumber.value.toLowerCase(),
      "report_date": searchReportDate.value.toLowerCase(),
      "lost_date": searchLostDate.value.toLowerCase(),
      "item_description": searchItemDescription.value.toLowerCase(),
      "name": searchCustomer.value.toLowerCase(),
    });
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

// -----------Search changes function
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

    lostPropertyUpdateId.value = lostPropertyUpdate?.id ?? 0;
    nameController.text = lostPropertyUpdate?.customer?.name ?? "";
    detailOfPropertyController.text = lostPropertyUpdate?.itemDescription ?? "";

    lostPropertyValue(true);
    update();

    try {
      print("Calling API for ID: ${lostPropertyUpdate.id}");

      final response = await Api().get("lost-property/getbyid/${lostPropertyUpdate.id}");

      if (response != null && response.data != null) {
        var data = response.data;

        var detail = data['lost_property'];

        if (detail != null) {
          mobileController.text = (detail['mobile'] ?? "").toString();
          address1Controller.text = (detail['address1'] ?? "").toString();
          checkedByController.text = (detail['checked_by'] ?? "").toString();
          enquiryController.text = (detail['inquiry'] ?? "").toString();
          resultController.text = (detail['result'] ?? "").toString();
          methodOfDespositionController.text = (detail['method_desposition'] ?? "").toString();

          print("Binding Finished Successfully!");
        }
      }
    } catch (e) {
      print("Caught Error in Controller: $e");
    }

    update();
    print("--- BINDING END ---");
  }

  // lostPropertyUpdate({dynamic lostPropertyUpdate}) async {
  //   lostPropertyUpdateId.value = lostPropertyUpdate!.id!;
  //   nameController.text = lostPropertyUpdate.customer!.name!;
  //   mobileController.text = lostPropertyUpdate.customer!.mobile!;
  //   detailOfPropertyController.text = lostPropertyUpdate.itemDescription!;
  //   methodOfDespositionController.text = lostPropertyUpdate.methodDesposition!;
  //   address1Controller.text = lostPropertyUpdate.address1!;
  //   checkedByController.text = lostPropertyUpdate.checkedBy!;
  //   enquiryController.text = lostPropertyUpdate.inquiry!;
  //   resultController.text = lostPropertyUpdate.result!;
  //   lostPropertyValue(true);
  // }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo list of lost property functionality
}
