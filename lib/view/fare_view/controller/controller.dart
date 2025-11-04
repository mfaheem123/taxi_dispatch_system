

import 'package:dashboard_new1/component/networks/api.dart';
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

  /// TextEditingControllers
  final startingFareController = TextEditingController();
  final startingMilesController = TextEditingController();

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
  Account? accountValue;
  VehicleType? vehicleValue;
  FareGetVehicleTypeAccount? fareGetVehicleTypeAccount;
  RxBool getFareGetVehicleTypeAccountLoader = false.obs;
  getFareGetVehicleTypeAccount()async{
    getFareGetVehicleTypeAccountLoader(true);
    var response = await Api().get("combined/vehicle-type-accounts");
    if (response.statusCode == 200) {
      fareGetVehicleTypeAccount = FareGetVehicleTypeAccount.fromJson(response.data);
      getFareGetVehicleTypeAccountLoader(false);
      update();
    }
  }



  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo FARE CONFIGURATION functionality


}