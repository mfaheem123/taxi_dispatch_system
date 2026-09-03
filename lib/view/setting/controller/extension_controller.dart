import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../model/getManageExtrntionModel.dart';

class ExtensionController extends GetxController {
  GetManageExtentionModel? getManageExtentionModel;

  RxBool getManageExtentionLoader = false.obs;
  getManageExtention() async {
    getManageExtentionLoader(true);
    var response =
        await Api().get("employeeextension/get", sendCompanyId: true);
    if (response.statusCode == 200) {
      getManageExtentionModel = GetManageExtentionModel.fromJson(response.data);
      // await getAllFareConfiguration();
      getManageExtentionLoader(false);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>> POST ADD EXTENSION

  final extensionNumberController = TextEditingController();
  dynamic selectedEmployee;
  bool permanentFlag = false;
  RxBool postExtensionLoader = false.obs;

  RxBool isUpdateExtension = false.obs;
  RxInt extensionUpdateId = 0.obs;

  saveExtension() async {
    if (selectedEmployee == null) {
      BotToast.showText(text: "PLEASE SELECT EMPLOYEE");
      return;
    }
    if (extensionNumberController.text.trim().isEmpty) {
      BotToast.showText(text: "PLEASE ENTER EXTENSION NUMBER");
      return;
    }

    postExtensionLoader(true);
    update();

    var formData = {
      "employee_id": selectedEmployee.id,
      "extension_number": extensionNumberController.text.trim(),
      "permanent_flag": permanentFlag,
    };

    var response = await Api().post(
        formData,
        isUpdateExtension.value
            ? "employeeextension/edit/${extensionUpdateId.value}"
            : "employeeextension/add",
        sendCompanyId: true);

    if (response.statusCode == 200) {
      BotToast.showText(
        text: isUpdateExtension.value
            ? "EXTENSION UPDATED SUCCESSFULLY!"
            : "EXTENSION ADDED SUCCESSFULLY!",
      );
      clearAddExtensionFields();
      await getManageExtention();
    } else {
      BotToast.showText(
        text: isUpdateExtension.value
            ? "FAILED TO UPDATE EXTENSION"
            : "FAILED TO ADD EXTENSION",
      );
    }

    postExtensionLoader(false);
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>> BIND EXTENSION (FOR EDITING)

  bindExtension(dynamic extensionData) {
    selectedEmployee = extensionData.employee;
    extensionNumberController.text = extensionData.extensionNumber ?? "";
    permanentFlag = extensionData.permanentFlag ?? false;

    isUpdateExtension(true);
    extensionUpdateId(extensionData.id!);

    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>> CLEAR FIELDS

  clearAddExtensionFields() {
    selectedEmployee = null;
    extensionNumberController.clear();
    permanentFlag = false;
    isUpdateExtension(false);
    extensionUpdateId(0);
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>> DELETE EXTENSION

  deleteExtension(int id) async {
    BotToast.showLoading();
    var response = await Api().delete("employeeextension/delete/$id");
    if (response.statusCode == 200) {
      BotToast.showText(text: "EXTENSION DELETED SUCCESSFULLY!");
      await getManageExtention();
    } else {
      BotToast.showText(text: "FAILED TO DELETE EXTENSION");
    }
  }


}
