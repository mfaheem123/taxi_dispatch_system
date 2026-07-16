import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttributeAlert {
  static void show() {
    String selectedAttrId = "";

    // Dummy attributes
    List<Map<String, String>> attributes = [
      {"id": "1", "name": "PET FRIENDLY", "shortCode": "PF"},
      {"id": "2", "name": "WHEEL CHAIR", "shortCode": "WC"},
    ];

    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.only(top: 40, left: 60, right: 60),
        backgroundColor: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 450,
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
                    Row(
                      children: [
                        Icon(Icons.local_offer, color: DynamicColors.primaryClr, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "ATTRIBUTES",
                          style: mozillaTextSemiBoldText(
                              fontSize: 15, color: DynamicColors.textClr),
                        ),
                      ],
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
                          flex: 1,
                          child: Text("#",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          flex: 3,
                          child: Text("ATTRIBUTE NAME",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          flex: 2,
                          child: Text("SHORT CODE",
                              style: mozillaTextSemiBoldText(
                                  fontSize: 12))),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Text("ACTION",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 12)),
                          )),
                    ],
                  ),
                ),
                
                // Table Body
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: attributes.map((attr) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(attr['id']!, style: mozillaTextSemiBoldText(fontSize: 12))),
                              Expanded(
                                  flex: 3,
                                  child: Text(attr['name']!, style: mozillaTextSemiBoldText(fontSize: 12))),
                              Expanded(
                                  flex: 2,
                                  child: Text(attr['shortCode']!, style: mozillaTextSemiBoldText(fontSize: 12))),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Radio<String>(
                                      value: attr['id']!,
                                      groupValue: selectedAttrId,
                                      activeColor: DynamicColors.primaryClr,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedAttrId = value!;
                                        });
                                      },
                                    ),
                                  )),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                ),
                const SizedBox(height: 20),
                
                // Footer
                Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                    width: 80,
                    height: 30,
                    verticalPadding: 0.0,
                    btnText: "CLOSE",
                    btnColor: Colors.grey.shade200,
                    borderRadius: 4,
                    onTap: () {
                      Get.back();
                    },
                    style: mozillaTextSemiBoldText(
                        fontSize: 12, color: DynamicColors.textClr),
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
