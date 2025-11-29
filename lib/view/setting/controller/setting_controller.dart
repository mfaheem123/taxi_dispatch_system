import 'package:dashboard_new1/component/networks/api.dart';
import 'package:dashboard_new1/view/setting/model/getManageExtrntionModel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SettingController extends GetxController {



  GetManageExtentionModel? getManageExtentionModel;

  RxBool getManageExtentionLoader = false.obs;
  getManageExtention()
  async{
    getManageExtentionLoader(true);
    var response = await Api().get("employeeextension/get");
    if (response.statusCode == 200) {
      getManageExtentionModel = GetManageExtentionModel.fromJson(response.data);
      // await getAllFareConfiguration();
      getManageExtentionLoader(false);
      update();
    }
  }


}