import 'dart:convert';
import 'package:dashboard_new1/component/networks/api.dart';
import 'package:get/get.dart';

import '../model/authorization_getById_model.dart';
import '../model/get_role_model.dart';

class AuthorizationController extends GetxController{

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo authorization screen functionality

  GetRoleModel? getRoleModel;
  bool rolesLoader = false;
  int? selectedRoleId;

  @override
  void onInit(){
    super.onInit();
    fetchRoles();
  }

  fetchRoles() async{
    rolesLoader = true;
    update();

    var response = await Api().get("roles");
    if (response.statusCode == 200) {
      getRoleModel = GetRoleModel.fromJson(response.data);
      rolesLoader = false;
      update();
    }
  }



  GetAuthorizationByRoleIdModel? getAuthorizationByRoleIdModel;
  bool authLoader = false;
  final Map<String, String> keyOverrides = {
    "read_company_information": "read_company_informations",
    "read_company_configuration": "read_company_configurations",
  };
  fetchPermissions(int roleId) async {
    authLoader = true;
    update();


      var response = await Api().get("authorizations/role/$roleId");
      if (response.statusCode == 200) {
        getAuthorizationByRoleIdModel = GetAuthorizationByRoleIdModel.fromJson(response.data);

        if(getAuthorizationByRoleIdModel?.permissions != null) {
          getAuthorizationByRoleIdModel!.permissions!.toJson().forEach((k, v) {
            if (v is bool) {
              String uiKey = keyOverrides[k] ?? k;
              localPermissions[uiKey] = v;
            }
              // localPermissions[k] = v;
          });
        }
      authLoader = false;
      update();
    }
  }

  Map<String, bool> localPermissions = {};

  void togglePermission(String uiKey, bool value) {
    localPermissions[uiKey] = value;

    if (getAuthorizationByRoleIdModel?.permissions != null) {
      String apiKey = keyOverrides.entries
          .firstWhere((e) => e.value == uiKey, orElse: () => MapEntry(uiKey, uiKey))
          .key;

      Map<String, dynamic> json = getAuthorizationByRoleIdModel!.permissions!.toJson();
      json[apiKey] = value;
      getAuthorizationByRoleIdModel!.permissions = Permissions.fromJson(json);
    }

    update();
    print("Toggle Key: $uiKey | New Value: $value");
  }
// void togglePermission(String key, bool value) {
//   if (getAuthorizationByRoleIdModel?.permissions == null) {
//     getAuthorizationByRoleIdModel = GetAuthorizationByRoleIdModel(
//       permissions: Permissions(roleId: selectedRoleId),
//     );
//   }
//     Map<String, dynamic> json = getAuthorizationByRoleIdModel!.permissions!.toJson();
//     json[key] = value;
//     getAuthorizationByRoleIdModel!.permissions = Permissions.fromJson(json);
//     update();
//   }
}
