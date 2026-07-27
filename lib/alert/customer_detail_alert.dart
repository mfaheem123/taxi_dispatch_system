// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../component/color.dart';
// import '../component/customButton.dart';
// import '../component/textStyle.dart';
//
// class CustomerDetailsAlert extends StatelessWidget {
//   const CustomerDetailsAlert({super.key});
//
//   static void show() {
//     Get.dialog(
//       const CustomerDetailsAlert(),
//       barrierColor: Colors.black54,
//     );
//   }
//
//   Widget buildField(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title.toUpperCase(),
//             style: TextStyle(
//               fontSize: 15,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Text(
//               value.toUpperCase(),
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String pickup = "DHA PHASE 6";
//     String dropOff = "CLIFTON BLOCK 5";
//     String driverName = "MARK";
//     String vehicle = "SALOON";
//     String journeyType = "ONE WAY";
//
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         // constraints: const BoxConstraints(maxWidth: 600),
//         constraints: BoxConstraints(
//           maxWidth: 550,
//           maxHeight: MediaQuery.of(context).size.height * 0.7,
//         ),
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               Text(
//                 "CUSTOMER DETAILS",
//                 style: mozillaTextSemiBoldText(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//               buildField("Pickup Location", pickup),
//               buildField("Drop-off Location", dropOff),
//               Row(
//                 children: [
//                   Expanded(child: buildField("Driver Name", driverName)),
//                   const SizedBox(width: 5),
//                   Expanded(child: buildField("Vehicle", vehicle)),
//                   const SizedBox(width: 5),
//                   Expanded(child: buildField("Journey Type", journeyType)),
//
//                 ],
//               ),
//               // buildField("Journey Type", journeyType),
//
//               const SizedBox(height: 10),
//               const Divider(),
//
//               // BUTTON
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: CustomButton(
//                   height: 45,
//                   width: 120,
//                   btnText: "CLOSE",
//                   btnColor: DynamicColors.primaryClr,
//                   borderRadius: 8,
//                   style: mozillaTextSemiBoldText(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   onTap: () => Get.back(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/color.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';

class CustomerDetailsAlert extends StatelessWidget {
  const CustomerDetailsAlert({super.key});

  static void show() {
    Get.dialog(
      const CustomerDetailsAlert(),
      barrierColor: Colors.black54,
    );
  }

  Widget buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DRIVER",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              underline: const SizedBox(),
              value: "MARK",
              items:  [
                DropdownMenuItem(value: "MARK", child: Text("MARK", style: mozillaTextRegularText(fontWeight: FontWeight.w900))),
                DropdownMenuItem(value: "JOHN", child: Text("JOHN", style: mozillaTextRegularText(fontWeight: FontWeight.w900))),
              ],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String refNo = "REF-1023";
    String date = "02-05-2026";
    String time = "10:45 AM";

    String pickup = "DHA PHASE 6";
    String dropOff = "CLIFTON BLOCK 5";

    String vehicle = "SALOON";
    String journeyType = "ONE WAY";

    String customerName = "TEST";
    String mobile = "03001234567";

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxWidth: 650,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "CUSTOMER APP DETAILS",
                style: mozillaTextSemiBoldText(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: buildField("Reference No", refNo)),
                  const SizedBox(width: 8),
                  Expanded(child: buildField("Date", date)),
                  const SizedBox(width: 8),
                  Expanded(child: buildField("Time", time)),
                ],
              ),
              buildField("Pickup Location", pickup),
              buildField("Drop-off Location", dropOff),
              buildDropdown(),
              Row(
                children: [
                  Expanded(child: buildField("Vehicle", vehicle)),
                  const SizedBox(width: 8),
                  Expanded(child: buildField("Journey Type", journeyType)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildField("Customer Name", customerName)),
                  const SizedBox(width: 8),
                  Expanded(child: buildField("Mobile", mobile)),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  height: 45,
                  width: 120,
                  btnText: "CLOSE",
                  btnColor: DynamicColors.primaryClr,
                  borderRadius: 8,
                  style: mozillaTextSemiBoldText(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
