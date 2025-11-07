

import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/fare_view/fare_configuration_day/fare_configuration_model.dart';
import 'package:dashboard_new1/view/fare_view/model/getVehicleTypeAccountModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FareController extends GetxController {

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  final vehicleTypeController = TextEditingController();
  final fareController = TextEditingController();
  final fareDescriptionController = TextEditingController();
  final fareDescription2ndController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  /// TextEditingControllers
  final fareValueVehicleController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo Plot Fare functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality

  /// TextEditingControllers
  final  incrementValueVehicleController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE INCREMENT functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  /// TextEditingControllers
  final surChargesFareController = TextEditingController();
  final parkingFareController = TextEditingController();
  final postCodeFareController = TextEditingController();
  final extraDropOffFareController = TextEditingController();
  final congestionFareController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality

  /// bool
  final meteredSwitch = ValueNotifier<bool>(false);
  final autoWaitSwitch = ValueNotifier<bool>(false);

  /// TextEditingControllers
  final activeWaitingController = TextEditingController();

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo SURCHARGES functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality


  String? fromDayValue;
  String? toDayValue;
  String? startDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? endDate = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  String? fareConfiguration = "NORMAL";

  /// TextEditingControllers
  final fromDayController = TextEditingController(text: "09:08 AM");
  final toDayController = TextEditingController(text: "09:08 AM");
  final startingFareController = TextEditingController();
  final startingMilesController = TextEditingController();
  final titleController = TextEditingController();

  List<String> weekDayList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  Account? accountValue;
  VehicleType? vehicleValue;
  FareGetVehicleTypeAccount? fareGetVehicleTypeAccount;
  RxBool getFareGetVehicleTypeAccountLoader = false.obs;
  getFareGetVehicleTypeAccount()async{
    getFareGetVehicleTypeAccountLoader(true);
    var response = await Api().get("combined/vehicle-type-accounts");
    if (response.statusCode == 200) {
      fareGetVehicleTypeAccount = FareGetVehicleTypeAccount.fromJson(response.data);
     await getAllFareConfiguration();
      getFareGetVehicleTypeAccountLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create fare setting
  createFareSetting() async{
    var formData = {
      "vehicle_type_id": vehicleValue!.id,
      "account_id": accountValue!.id,
      "from_day": fromDayValue,
      "to_day": toDayValue,
      "from_time": fromDayController.text,
      "to_time": toDayController.text,
      "minimum_fares": startingFareController.text,
      "minimum_miles": startingMilesController.text,
     if(titleController.text.isNotEmpty && fareConfiguration != "NORMAL") "title": titleController.text,
     if(fareConfiguration != "NORMAL") "from_date": startDate,
      if(fareConfiguration != "NORMAL") "to_date": endDate,
    };
    print(formData);
    var response = await Api().post(formData, "faresconfiguration/add");
    if(response.statusCode == 200){
      getAllFareConfigurationData!.fareConfigurations!.insert(0, FareConfiguration.fromJson(response.data));
      print(response.data);
      BotToast.showText(text: "Fare configuration is successfully added");
      refreshCreateFareFields();
    }
  }

  refreshCreateFareFields() async{
    vehicleValue = null;
    accountValue = null;
    fromDayValue = null;
    toDayValue = null;
    fromDayController.clear();
    toDayController.clear();
    startingFareController.clear();
    startingMilesController.clear();
    titleController.clear();
    update();
  }
  
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all fare view 
  RxBool getAllFareViewLoader = false.obs;
  GetAllFareConfigurationModel? getAllFareConfigurationData;
  getAllFareConfiguration() async{
    getAllFareViewLoader(true);
    var response = await Api().get("faresconfiguration/get?title=$fareConfiguration");
    if(response.statusCode == 200){
      getAllFareConfigurationData = GetAllFareConfigurationModel.fromJson(response.data);
      getAllFareViewLoader(false);
      update();
    }
  }



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality


}