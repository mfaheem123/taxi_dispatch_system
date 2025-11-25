

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/textStyle.dart';

class DashboardF8Alert {
  static void show() {

    // int? editingIndex;

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: StatefulBuilder(
            builder: (context, setState) {


              return Container(
                width: Get.width * 0.7,
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
                        Text("SHORTCUTS",
                          style: mozillaTextRegularText(fontSize: 16,color: DynamicColors.textClr),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.close),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static Widget customContainer({key, double? width}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: kToolbarHeight/2,
        width: width ?? 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: DynamicColors.textClr,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(key,
              style: mozillaTextRegularText(
                  color: DynamicColors.whiteClr,
                  fontSize: 13
              ),
            ),
          ),
        ),
      ),
    );
  }
}