
import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';

class Prompts {
  alert(
      {required BuildContext context,
        required String index,
        required VoidCallback ontap}) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // insetPadding: EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 30),
                  Text(
                    'Are you sure you want to remove?',
                    // maxLines: 2,
                    style: TextStyle(
                      color: DynamicColors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: DynamicColors.primaryClr,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                              "No",style: TextStyle(
                              color:DynamicColors.whiteClr,
                              fontSize:
                              MediaQuery.of(context).size.width * 0.01)
                          ),
                              ),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: DynamicColors.primaryClr,
                          ),
                          onPressed: ontap,
                          child:
                          Text(
                              "Yes",style: TextStyle(
                              color:DynamicColors.whiteClr,
                              fontSize:
                              MediaQuery.of(context).size.width * 0.01)
                          ),
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  alertMobile(
      {required BuildContext context,
        required String index,
        required VoidCallback ontap}) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // insetPadding: EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Are you sure you want to remove?',
                    // maxLines: 2,
                    style: TextStyle(
                      color: DynamicColors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(

                            backgroundColor: DynamicColors.primaryClr,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:  Text(
                              "No",style: TextStyle(
                              color:DynamicColors.whiteClr,
                              fontSize:
                              MediaQuery.of(context).size.width * 0.01)
                          ),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: DynamicColors.primaryClr,

                          ),
                          onPressed: ontap,
                          child:  Text(
                              "Yes",style: TextStyle(
                              color:DynamicColors.whiteClr,
                              fontSize:
                              MediaQuery.of(context).size.width * 0.01)
                          ),
                      ),
                    ],
                  )
                ],
              ));
        });
  }



  void showToastMessage({required String msg, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg, style: TextStyle(color: Colors.white))));
  }

  void showErrorMessage({required String msg, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg, style: TextStyle(color: Colors.white))));
  }

  static Future<void> noInternetDialog(context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        // backgroundColor: pinchToastColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "No Internet Connection",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void showSnackBar(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        // backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            message,
            style: const TextStyle(
              color:Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
