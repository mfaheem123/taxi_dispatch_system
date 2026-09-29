import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';

class VehicleHistoryAlert {
  static void show() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 1000,
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: Get.height * 0.8,
            ),
            // padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "VEHICLE HISTORY",
                      style: mozillaTextSemiBoldText(
                          fontSize: 15, color: DynamicColors.textClr),
                    ),
                    const Spacer(),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(999),
                      child: const AlertCloseButton(),
                    ),
                  ],
                )),
                const SizedBox(height: 20),
                
                // Table Header
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("START DATE", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("END DATE", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("VEHICLE #", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("VEHICLE TYPE", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("OWNER", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("MAKE", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("MODEL", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                        flex: 3,
                          child: Center(child: Text("LOG BOOK #", style: mozillaTextSemiBoldText(fontSize: 12)))),
                      VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Colors.grey.shade300),
                      Expanded(
                          flex: 3,
                          child: Center(child: Text("LOG BOOK DOCUMENT", style: mozillaTextSemiBoldText(fontSize: 12)))),
                    ],
                  ),
                ))
                    ),
                
                const SizedBox(height: 10),
                
                // Table Body (Empty for now)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("No vehicle history found.", style: mozillaTextRegularText(fontSize: 14, color: Colors.grey)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
