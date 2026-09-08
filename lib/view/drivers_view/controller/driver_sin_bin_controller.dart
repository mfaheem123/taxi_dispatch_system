import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/driver_sin_bin_setting_model.dart';

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
    
    var response = await Api().post(formData,
        "sinbin/driver-sinbin-settings", sendCompanyId: true, auth: true);

    if (response.statusCode == 200) {
      BotToast.showText(text: "DRIVER SINBIN ADDED SUCCESSFULLY!");
    }
    isAddSinBin = false;
    update();
  }

}