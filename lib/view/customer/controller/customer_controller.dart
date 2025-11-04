import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/customer/model/getCustomer.dart';
import 'package:dashboard_new1/view/customer/model/restricDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
    if (restricDriverModel == null || restricDriverModel!.drivers.isEmpty) {
      return [];
    }
    return restricDriverModel!.drivers.map((d) {
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
      "customers/add",
      auth: true,
    );
    if (response.statusCode == 200) {
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
    try {
      customerLoader(true);
      var response =
          await Api().get("customers/get?",
           auth: true, 
           queryParameters: {
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
    } catch (e) {
      print("Error in GEt Customer $e");
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
  RxInt locationUpdateId = 0.obs;
  customerUpdate({Customer? customerUpdate}) async {
    locationUpdateId.value = customerUpdate!.id!;
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
}
