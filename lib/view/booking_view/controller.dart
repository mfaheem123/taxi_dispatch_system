


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../dashboard_view/Controller/dashboard_controller.dart';

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


}