// import 'package:dashboard_new1/component/color.dart';
// import 'package:dashboard_new1/component/customButton.dart';
// import 'package:dashboard_new1/component/textStyle.dart';
// import 'package:dashboard_new1/component/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// class LocationForm extends StatelessWidget {
//   const LocationForm({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isMobile = constraints.maxWidth < 600;
//
//           return SingleChildScrollView(
//             child: Container(
//               width: isMobile ? double.infinity : 800,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     color: Colors.grey.shade200,
//                     child: const Center(
//                       child: Text(
//                         "LOCATION",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   /// First Row (Location Name - Longitude)
//                   isMobile
//                       ? Column(
//                     children: [
//                       _buildField("LOCATION NAME"),
//                       const SizedBox(height: 10),
//                       _buildField("LONGITUDE"),
//                     ],
//                   )
//                       : Row(
//                     children: [
//                       Expanded(child: _buildField("LOCATION NAME")),
//                       const SizedBox(width: 10),
//                       Expanded(child: _buildField("LONGITUDE")),
//                     ],
//                   ),
//
//                   const SizedBox(height: 15),
//
//                   /// Second Row (Postcode - Zone)
//                   isMobile
//                       ? Column(
//                     children: [
//                       _buildField("POSTCODE"),
//                       const SizedBox(height: 10),
//                       _buildDropdown("ZONE"),
//                     ],
//                   )
//                       : Row(
//                     children: [
//                       Expanded(child: _buildField("POSTCODE")),
//                       const SizedBox(width: 10),
//                       Expanded(child: _buildDropdown("ZONE")),
//                     ],
//                   ),
//
//                   const SizedBox(height: 15),
//
//                   /// Third Row (Shortcut - Extra Charges)
//                   isMobile
//                       ? Column(
//                     children: [
//                       _buildField("SHORTCUT"),
//                       const SizedBox(height: 10),
//                       _buildField("EXTRA CHARGES"),
//                     ],
//                   )
//
//                       : Row(
//                     children: [
//                       Expanded(child: _buildField("SHORTCUT")),
//                       const SizedBox(width: 10),
//                       Expanded(child: _buildField("EXTRA CHARGES")),
//                     ],
//                   ),
//
//                   const SizedBox(height: 15),
//
//                   /// Fourth Row (Location Type - Latitude)
//                   isMobile
//                       ? Column(
//                     children: [
//                       _buildDropdown("LOCATION TYPE"),
//                       const SizedBox(height: 10),
//                       _buildField("LATITUDE"),
//                     ],
//                   )
//
//                       : Row(
//                     children: [
//                       Expanded(child: _buildDropdown("LOCATION TYPE")),
//                       const SizedBox(width: 10),
//                       Expanded(child: _buildField("LATITUDE")),
//                     ],
//                   ),
//
//
//                   const SizedBox(height: 15),
//
//
//                   /// Address
//                   _buildMultiline("ADDRESS"),
//                   const SizedBox(height: 20),
//
//
//                   /// Save Button
//                   Container(
//                     // height: screenHeight / 20,
//                     width: double.infinity,
//                     color: DynamicColors.gryClr,
//                     padding: EdgeInsets.symmetric(horizontal: 120, vertical: 14),
//                     child: CustomButton(
//                       height: 30,
//                       width: Get.width / 4,
//                       verticalPadding: 0.0,
//                       borderRadius: 4,
//                       style: mozillaTextSemiBoldText(
//                           fontSize: 12, color: DynamicColors.whiteClr),
//                       btnText: AppText.save,
//                     ),
//                   ),
//
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   static Widget _buildField(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
//         const SizedBox(height: 5),
//         TextField(
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             isDense: true,
//           ),
//         ),
//       ],
//     );
//   }
//
//   static Widget _buildDropdown(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
//         const SizedBox(height: 5),
//         DropdownButtonFormField<String>(
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             isDense: true,
//           ),
//           items: const [
//             DropdownMenuItem(value: "1", child: Text("Option 1")),
//             DropdownMenuItem(value: "2", child: Text("Option 2")),
//           ],
//           onChanged: (value) {},
//         ),
//       ],
//     );
//   }
//
//   static Widget _buildMultiline(String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
//         const SizedBox(height: 5),
//         TextField(
//           maxLines: 3,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/locations_view/Model/location_types_zoneModel.dart';
import 'package:dashboard_new1/view/locations_view/controller/lacations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';


class LocationForm extends StatelessWidget {
  LocationForm({super.key});

  LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return GetBuilder<LocationController>(
            initState: (v){
              _controller.getLocationTypeZone();
            },
            builder: (controller) {
              return controller.getLocationTypeZoneLoader.value == true?SizedBox.shrink():
              SingleChildScrollView(
                child: Container(
                  width: isMobile ? double.infinity : 800,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),

                      const SizedBox(height: 20),

                      // Location Name - Longitude
                      isMobile
                          ? Column(
                        children: [
                          _buildField("LOCATION NAME", controller.locationNameCtrl),
                          const SizedBox(height: 10),
                          _buildField("LONGITUDE", controller.longitudeCtrl),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(child: _buildField("LOCATION NAME", controller.locationNameCtrl)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildField("LONGITUDE", controller.longitudeCtrl)),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Postcode - Zone
                      isMobile
                          ? Column(
                        children: [
                          _buildField("POSTCODE", controller.postcodeCtrl),
                          const SizedBox(height: 10),

                          DropdownButtonFormField<ZoneObject>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            value: controller.zoneValue,
                            items: controller.locationtypezoneModel!.zonesList!
                                .map((zone) => DropdownMenuItem<ZoneObject>(
                              value: controller.zoneValue,
                              child: Text(controller.zoneValue!.name??""),
                            ))
                                .toList(),
                            onChanged: (v) {
                              controller.zoneValue = v;
                            },
                          )

                          // _buildZoneDropdown(label:"ZONE", value: controller.zoneValue!, itemsList: controller.locationtypezoneModel!.zones),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(child: _buildField("POSTCODE", controller.postcodeCtrl)),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                            CustomDropdownField<ZoneObject>(
                              label: "Select User",
                              items: controller.locationtypezoneModel!.zonesList!,
                              value: controller.zoneValue,
                              itemLabel: (templateList) => templateList.name!, // show name
                              onChanged: (val) {
                                // controller.templateTitleController.clear();
                                controller.zoneValue = val;
                                // controller.insertTagValue(value: val?.templateValue,temFormate: true);
                                print("Selected User ID: ${val?.id}");
                              },
                            ),
                          ),
                          // Expanded(child: _buildZoneDropdown(label:"ZONE", value: controller.zoneValue!, itemsList: controller.locationtypezoneModel!.zones),),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Shortcut - Extra Charges
                      isMobile
                          ? Column(
                        children: [
                          _buildField("SHORTCUT", controller.shortcutCtrl),
                          const SizedBox(height: 10),
                          _buildField("EXTRA CHARGES", controller.extraChargesCtrl),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(child: _buildField("SHORTCUT", controller.shortcutCtrl)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildField("EXTRA CHARGES", controller.extraChargesCtrl)),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // Location Type - Latitude
                      isMobile
                          ? Column(
                        children: [
                          DropdownButtonFormField<LocationTypeObject>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            value: controller.locationTypeValue,
                            items: controller.locationtypezoneModel!.zonesList!
                                .map((zone) => DropdownMenuItem<LocationTypeObject>(
                              value: controller.locationTypeValue,
                              child: Text(controller.locationTypeValue!.name??""),
                            ))
                                .toList(),
                            onChanged: (v) {
                              controller.locationTypeValue = v;
                            },
                          ),
                          // _buildDropdown("LOCATION TYPE", controller.locationTypeValue, controller.locationTypes),
                          const SizedBox(height: 10),
                          _buildField("LATITUDE", controller.latitudeCtrl),
                        ],
                      )
                          : Row(
                        children: [

                          DropdownButtonFormField<LocationTypeObject>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            value: controller.locationTypeValue,
                            items: controller.locationtypezoneModel!.locationTypesList!
                                .map((zone) => DropdownMenuItem<LocationTypeObject>(
                              value: controller.locationTypeValue,
                              child: Text(controller.locationTypeValue!.name??""),
                            ))
                                .toList(),
                            onChanged: (v) {
                              controller.locationTypeValue = v;
                              controller.update();
                            },
                          ),
                          // Expanded(child: _buildDropdown("LOCATION TYPE", controller.locationTypeValue, controller.locationTypes)),
                          const SizedBox(width: 10),
                          Expanded(child: _buildField("LATITUDE", controller.latitudeCtrl)),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _buildMultiline("ADDRESS", controller.addressCtrl),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          controller.postLocation();
                          // controller.saveLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColors.primaryClr,
                          padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 14),
                        ),
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: Text(
        "LOCATION",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  // static Widget _buildZoneDropdown(
  //     {String? label, Zone? value,  List? itemsList}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(label!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
  //       const SizedBox(height: 5),
  //       Obx(() {
  //         return DropdownButtonFormField<Zone>(
  //           decoration: const InputDecoration(
  //             border: OutlineInputBorder(),
  //             isDense: true,
  //           ),
  //           value: value,
  //           items: itemsList!
  //               .map((zone) => DropdownMenuItem<Zone>(
  //             value: zone,
  //             child: Text(zone.name),
  //           ))
  //               .toList(),
  //           onChanged: (v) {
  //             value = v;
  //           },
  //         );
  //       }),
  //     ],
  //   );
  // }

  static Widget _buildDropdown(String label, RxString value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        Obx(() {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            value: value.value.isEmpty ? null : value.value,
            items: items
                .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
                .toList(),
            onChanged: (v) => value.value = v ?? '',
          );
        }),
      ],
    );
  }

  static Widget _buildMultiline(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
