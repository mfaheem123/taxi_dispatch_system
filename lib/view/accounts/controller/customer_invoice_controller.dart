import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../customer/model/search_customer_by_mobile.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';
import '../model/customer_invoice_number_model.dart';

class CustomerInvoiceController extends GetxController{

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo CUSTOMER INVOICE functionality

  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerMobileController = TextEditingController();
  final customerTelephoneController = TextEditingController();

  DriverCommissionPaymentModel? paymentTypeModel;
  List<int> selectedPaymentTypeIds = [];
  bool isLoadingPayments = false;

  getPaymentTypes() async {
    isLoadingPayments = true;
    update();

    var response = await Api().get("enumerations/payment-types");
    if (response.statusCode == 200) {
      paymentTypeModel = DriverCommissionPaymentModel.fromJson(response.data);
      print("PAYMENT API DATA: ${response.data}");
    }
    isLoadingPayments = false;
    update();
  }

  /// todo mobile search api

  SearchCustomerByMobileModel? searchCustomerByMobileModel;
  bool isSearchingCustomer = false;

  getCustomer(String mobile) async {
    isSearchingCustomer = true;
    var response = await Api().get("customers/search-data?mobile=$mobile",sendCompanyId: true,);
    if (response.statusCode == 200) {
      searchCustomerByMobileModel =
          SearchCustomerByMobileModel.fromJson(response.data);
      isSearchingCustomer = false;
      update();
    }
  }
  
  /// todo invoice number
  CustomerInvoiceModel? customerInvoice;
  bool isCustomerInvoiceNumber = false;
  
  getCustomerInvoiceNumber() async {
    isCustomerInvoiceNumber = true;
    update();
    var response = await Api().get("customer-invoice/invoice-number");
    if(response.statusCode == 200) {
      customerInvoice = CustomerInvoiceModel.fromJson(response.data);
      isCustomerInvoiceNumber = false;
      update();
    }
  }

  /// todo filter Api

  String filterFromDate = "";
  String filterToDate = "";
  bool isFilteredLoading = false;

  getCustomerInvoiceByFilter() async {
    isFilteredLoading = true;
    update();


  }
}