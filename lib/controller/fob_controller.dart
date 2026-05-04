import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';

import '../Model/fob_alert_model.dart';

class FobController extends GetxController{
  GetFobModel? getFobModel;
  var drivers = <Driver>[].obs;
  var isLoading = false.obs;

  getDispatchFob() async {
    try{
      isLoading(true);
      var response = await Api().get("drivers/fob-drivers");
      if (response.statusCode == 200) {
        getFobModel = GetFobModel.fromJson(response.data);
        drivers.value = getFobModel?.drivers ?? [];
      }
    }finally{
      isLoading(false);
    }
  }
}