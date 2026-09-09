import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/driver_sin_bin_setting_model.dart';
import '../model/get_driver_sinbin_model.dart';

class DriverSinBinController extends GetxController{

  // @override
  // void onInit() {
  //   super.onInit();
  //   getDriverSinBinSetting();
  // }

  final recoverJobController = TextEditingController();
  final rejectJobController = TextEditingController();
  final ignoreJobController = TextEditingController();

  bool isLoadingSinBinSetting = false;
  DriverSinBinSettingModel? driverSinBinSettingModel;

  getDriverSinBinSetting() async {
    isLoadingSinBinSetting = true;
    update();

    var response = await Api().get("sinbin/driver-sinbin-settings/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      driverSinBinSettingModel = DriverSinBinSettingModel.fromJson(response.data);

      if(driverSinBinSettingModel?.sinbin != null) {
        recoverJobController.text = driverSinBinSettingModel?.sinbin?.recoverjob.toString() ?? "";
        rejectJobController.text = driverSinBinSettingModel?.sinbin?.rejectjob.toString() ?? "";
        ignoreJobController.text = driverSinBinSettingModel?.sinbin?.ignorejob?.toString() ?? "";
      }
    }
    print("API Response: ${response.data}");
    isLoadingSinBinSetting = false;
    update();
  }



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>post sinBinSetting

  bool isAddSinBin = false;

  saveSinBinSetting() async {
    isAddSinBin = true;
    update();

    var formData = {
      "ignoreJob": ignoreJobController.text,
      "rejectJob": rejectJobController.text,
      "recoverJob": recoverJobController.text,
    };

    print("Submitting Payload: $formData");
    
    var response = await Api().post(
        formData,
        "sinbin/driver-sinbin-settings", sendCompanyId: true, auth: true);

    if (response.statusCode == 200) {
      BotToast.showText(text: "DRIVER SINBIN ADDED SUCCESSFULLY!");
    }
    isAddSinBin = false;
    update();
  }


  void updateValue(TextEditingController textController, int change) {
    int currentVal = int.tryParse(textController.text) ?? 0;
    textController.text = (currentVal + change).toString();
    update();
  }

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>get all driver sinBin

  bool isLoadingGetSinBin = false;
  GetDriverSinBin? getDriverSinBinModel;
  List<Driver> sinBinDriversList = [];

  getDriverSinBin() async {
    isLoadingGetSinBin = true;
    update();
    
    var response = await Api().get("sinbin/sinbin-drivers/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getDriverSinBinModel = GetDriverSinBin.fromJson(response.data);
      sinBinDriversList = getDriverSinBinModel?.drivers ?? [];
    }
    isLoadingGetSinBin = false;
    update();
  }


///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>post driver sinBin

  bool isDriverSinBinLoading = false;

  addDriverSinBin(driverId, sinbinTime, {bool isActive = true}) async {
    isDriverSinBinLoading = true;
    update();

    var formData = {
      "driver_id": driverId,
      // "message": "You are in Sin Bin",
      "sinbin_time": sinbinTime,
      "is_active": isActive,
    };
    print("Submitting Payload: $formData");

    var response = await Api().post(
        formData,
        "sinbin/driver-sinbin/add", sendCompanyId: true, auth: true);

    if (response.statusCode == 200) {
      BotToast.showText(text: isActive ? "YOU ARE IN SINBIN" : "DRIVER REMOVED FROM SINBIN");
      getDriverSinBin();
    }

    isDriverSinBinLoading = false;
    update();
  }

}