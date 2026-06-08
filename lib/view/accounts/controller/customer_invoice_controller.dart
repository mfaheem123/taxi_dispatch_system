import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/networks/api.dart';
import '../../drivers_view/model/driver_commission_payment_model.dart';

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

}