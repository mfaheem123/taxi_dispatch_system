


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

  DashboardTableModel? dashboardTableModelData;
  RxInt dashboardTableCurrentPage = 1.obs;
  RxInt dashboardTableTotalPages = 1.obs;
  final int dashboardTableLimit = 20;
  final int tableId = 2;
  getDashboardTableData() async{
    var response = await Api().get("bookings/getbytabs/${tableId}",
        queryParameters: {
          "page": dashboardTableCurrentPage.value,
          "limit": dashboardTableLimit,
        }
    );
    if(response.statusCode ==200){
      dashboardTableModelData = DashboardTableModel.fromJson(response.data);
      dashboardTableTotalPages.value = dashboardTableModelData!.total!;
      update();
    }
  }

  void dashboardTablePageChange(int page) {
    dashboardTableCurrentPage.value = page;
    getDashboardTableData();
  }






}