


import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../view/auth/Controller/auth_controller.dart';

class AuthorizationAlert extends StatefulWidget {
  const AuthorizationAlert({super.key});

  @override
  State<AuthorizationAlert> createState() => _AuthorizationAlertState();
}

class _AuthorizationAlertState extends State<AuthorizationAlert> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hitRoleFunction();
  }

  hitRoleFunction() async{
    final sp = GetStorage();

    AuthController _controller = Get.find();
    var storedUser = sp.read('userData');
    print(storedUser['role_id']);
   await _controller.getRole(id: storedUser['role_id']);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Authorization", // Dynamic Title call ho raha hai yahan
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: 450,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            "Your Permission Has Been Updated By Super Admin",
            style: TextStyle(
                color: DynamicColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: DynamicColors.primaryClr),
          onPressed: (){

          },
          child: const Text("OK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
