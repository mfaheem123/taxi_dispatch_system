
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';
import '../model/getManageExtrntionModel.dart';

class ExtensionController extends GetxController {

  GetManageExtentionModel? getManageExtentionModel;

  RxBool getManageExtentionLoader = false.obs;
  getManageExtention()
  async{
    getManageExtentionLoader(true);
    var response = await Api().get("employeeextension/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getManageExtentionModel = GetManageExtentionModel.fromJson(response.data);
      // await getAllFareConfiguration();
      getManageExtentionLoader(false);
      update();
    }
  }
}
