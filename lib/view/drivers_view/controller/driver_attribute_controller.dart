import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../component/networks/api.dart';
import '../model/driver_attribute_model.dart';

class DriverAttributeController extends GetxController {
  RxBool isLoading = false.obs;
  DriverAttributeModel? driverAttributeModel;
  RxList<DriverAttribute> allAttributes = <DriverAttribute>[].obs;
  RxList<DriverAttribute> filteredAttributes = <DriverAttribute>[].obs;

  // Search Filter Strings
  RxString searchName = ''.obs;
  RxString searchShortName = ''.obs;

  // Controllers for Add/Edit Form
  final attributeNameController = TextEditingController();
  final shortNameController = TextEditingController();
  DriverAttribute? singleAttributeData;

  @override
  void onInit() {
    super.onInit();
    getDriverAttributes();
  }

  /// GET Driver Attributes API Call
   getDriverAttributes() async {
    try {
      isLoading.value = true;
      update();

      final response = await Api().get(
        'driver-attributes/get',
        sendCompanyId: true,
      );

      if (response.statusCode == 200) {
        driverAttributeModel = DriverAttributeModel.fromJson(response.data);
        allAttributes.value = driverAttributeModel?.driverAttributes ?? [];
        filterAttributes();
      }
    } catch (e) {
      debugPrint("Error fetching driver attributes: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Filter attributes locally based on search strings
  void filterAttributes() {
    final queryName = searchName.value.trim().toLowerCase();
    final queryShortName = searchShortName.value.trim().toLowerCase();

    filteredAttributes.value = allAttributes.where((item) {
      final nameMatches = queryName.isEmpty ||
          (item.attributeName ?? '').toLowerCase().contains(queryName);
      final shortNameMatches = queryShortName.isEmpty ||
          (item.shortName ?? '').toLowerCase().contains(queryShortName);
      return nameMatches && shortNameMatches;

    }).toList();
    update();
  }

  /// Reset form fields
  void clearForm() {
    attributeNameController.clear();
    shortNameController.clear();
    singleAttributeData = null;
    update();
  }

  /// Bind data when editing
  void bindData(DriverAttribute attribute) {
    singleAttributeData = attribute;
    attributeNameController.text = (attribute.attributeName ?? '').toUpperCase();
    shortNameController.text = (attribute.shortName ?? '').toUpperCase();
    update();
  }

  /// ADD or UPDATE Driver Attribute API Call (POST)
   saveDriverAttribute() async {
    final name = attributeNameController.text.trim().toUpperCase();
    final shortName = shortNameController.text.trim().toUpperCase();

    if (name.isEmpty || shortName.isEmpty) {
      BotToast.showText(text: "PLEASE FILL ALL REQUIRED FIELDS");
      return false;
    }

    try {
      isLoading.value = true;
      update();

      final formData = dio.FormData.fromMap({
        'attribute_name': name,
        'short_name': shortName,
      });

      final url = singleAttributeData != null
          ? 'driver-attributes/update/${singleAttributeData!.id}'
          : 'driver-attributes/add';

      final response = await Api().post(
        formData,
        url,
        auth: true,
        sendCompanyId: true,
      );

      if (response.statusCode == 200) {
        final msg = singleAttributeData != null
            ? "DRIVER ATTRIBUTE UPDATED SUCCESSFULLY"
            : "DRIVER ATTRIBUTE ADDED SUCCESSFULLY";
        BotToast.showText(text: msg);
        clearForm();
        await getDriverAttributes();
        return true;
      }
    } catch (e) {
      debugPrint("Error saving driver attribute: $e");
    } finally {
      isLoading.value = false;
      update();
    }
    return false;
  }

  /// DELETE Driver Attribute API Call
  Future<void> deleteDriverAttribute(int? id) async {
    if (id == null) return;
    try {
      final response = await Api().delete('driver-attributes/delete/$id');
      if (response.statusCode == 200) {
        BotToast.showText(text: "DRIVER ATTRIBUTE DELETED SUCCESSFULLY!");
        await getDriverAttributes();
      }
    } catch (e) {
      debugPrint("Error deleting driver attribute: $e");
    }
  }
}
