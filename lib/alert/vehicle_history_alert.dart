import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VehicleHistoryAlert {
  static void show() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: Get.width * 0.9,
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: Get.height * 0.8,
            ),
            padding: const EdgeInsets.all(14),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "VEHICLE HISTORY",
                      style: mozillaTextSemiBoldText(
                          fontSize: 15, color: DynamicColors.textClr),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.close,
                          size: 20, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("START DATE",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("END DATE",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("VEHICLE #",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("VEHICLE TYPE",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("OWNER",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("MAKE",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("MODEL",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          child: Text("LOG BOOK #",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          flex: 2,
                          child: Text("LOG BOOK DOCUMENT",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                    ],
                  ),
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
