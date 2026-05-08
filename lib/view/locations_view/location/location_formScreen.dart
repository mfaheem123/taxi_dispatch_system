import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/view/locations_view/Model/location_types_zoneModel.dart';
import 'package:dashboard_new1/view/locations_view/controller/locations_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../component/dropdown_button.dart';
import '../../../component/networks/api.dart';

class LocationForm extends StatelessWidget {
  LocationForm({super.key});

  LocationController _controller = Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController());
    List permissions = [];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return GetBuilder<LocationController>(
            initState: (v) {
                  permissions = Api().sp.read('all_permissions') ?? [];
              if (_controller.updateLocationValue.value == false && _controller.locationtypezoneModel == null) {
                _controller.getLocationTypeZone();
              }
            },
            builder: (controller) {
              return controller.getLocationTypeZoneLoader.value == true
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
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

                      isMobile
                          ? Column(
                        children: [
                          _buildField("LOCATION NAME",
                              controller.locationNameCtrl,
                              inputType: "both"),
                          const SizedBox(height: 10),
                          _buildField("LONGITUDE",
                              controller.longitudeCtrl,
                              inputType: "number"),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                              child: _buildField("LOCATION NAME",
                                  controller.locationNameCtrl,
                                  inputType: "both")),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildField("LONGITUDE",
                                  controller.longitudeCtrl,
                                  inputType: "number")),
                        ],
                      ),

                       SizedBox(height: 15),

                      isMobile
                          ? Column(
                        children: [
                          _buildField("POSTCODE",
                              controller.postcodeCtrl,
                              inputType: 'both' ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<ZoneObject>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            value: controller.zoneValue,
                            items: controller.locationtypezoneModel!
                                .zonesList!
                                .map((zone) =>
                                DropdownMenuItem<ZoneObject>(
                                  value: zone,
                                  child: Text(zone.name ?? ""),
                                ))
                                .toList(),
                            onChanged: (v) {
                              controller.zoneValue = v;
                              controller.update();
                            },
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                              child: _buildField("POSTCODE",
                                  controller.postcodeCtrl,
                                  inputType: "both")),

                          const SizedBox(width: 10),


                            CustomDropdownField<ZoneObject>(
                              text: "SELECT ZONE",
                              label: "SELECT ZONE",
                              width: Get.width / 5,
                              height: 38,
                              items: controller.locationtypezoneModel!
                                  .zonesList!,
                              value: controller.zoneValue,
                              itemLabel: (templateList) =>
                              templateList.name!.toUpperCase(),
                              onChanged: (val) {
                                controller.zoneValue = val;
                                controller.update();
                              },
                            ),

                        ],
                      ),

                      const SizedBox(height: 15),

                      isMobile
                          ? Column(
                        children: [
                          _buildField("SHORTCUT",
                              controller.shortcutCtrl,
                              inputType: "text"),
                          const SizedBox(height: 10),
                          _buildField("EXTRA CHARGES",
                              controller.extraChargesCtrl,
                              inputType: "number"),
                        ],
                      )
                          : Row(
                        children: [
                          Expanded(
                              child: _buildField("SHORTCUT",
                                  controller.shortcutCtrl,
                                  inputType: "text")),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildField("EXTRA CHARGES",
                                  controller.extraChargesCtrl,
                                  inputType: "number")),
                        ],
                      ),

                      const SizedBox(height: 15),

                      isMobile
                          ? Column(
                        children: [
                          CustomDropdownField<LocationTypeObject>(
                            text: "LOCATION TYPE",
                            label: "LOCATION TYPE",
                            width: Get.width / 5,
                            height: 38,
                            items: controller.locationtypezoneModel!.locationTypesList!,
                            value: controller.locationTypeValue,
                            itemLabel: (templateList) =>
                            templateList.name!.toUpperCase(),
                            onChanged: (val) {
                              controller.locationTypeValue = val;
                              controller.update();
                            },
                          ),

                          const SizedBox(height: 10),

                          _buildField("LATITUDE",
                              controller.latitudeCtrl,
                              inputType: "number"),
                        ],

                      )
                          : Row(
                        children: [
                          CustomDropdownField<LocationTypeObject>(
                            text: "LOCATION TYPE",
                            label: "Location Type",

                            width: Get.width / 5,
                            height: 40,
                            items: controller.locationtypezoneModel!
                                .locationTypesList!,
                            value: controller.locationTypeValue,
                            itemLabel: (templateList) =>
                            templateList.name!.toUpperCase(),
                            onChanged: (val) {
                              controller.locationTypeValue = val;
                              controller.update();
                            },
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _buildField("LATITUDE",
                                  controller.latitudeCtrl,
                                  inputType: "number"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      _buildMultiline("ADDRESS",
                          controller.addressCtrl),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () async{
                         await controller.postLocation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          DynamicColors.primaryClr,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 14),
                        ),
                        child: Text(
                          controller.updateLocationValue.value == true
                              ? "UPDATE" // Agar update mode hai
                              : "SAVE",
                          style: const TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: const Text(
        "LOCATION",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _buildField(
      String label,
      TextEditingController controller, {
        String inputType = "text", // text, number, both
      }) {
    // Pattern selection
    Pattern pattern;
    switch (inputType) {
      case "number":
      // Yeh pattern digits, ek dot, aur ek leading minus sign allow karega
        pattern = RegExp(r'^[-+]?[0-9]*\.?[0-9]*');
        break;
      case "both":
        pattern = RegExp(r'[a-zA-Z0-9 ]');
        break;
      default: // text
        pattern = RegExp(r'[a-zA-Z ]');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) {
            controller.value = controller.value.copyWith(
              text: value.toUpperCase(),
              selection: TextSelection.collapsed(offset: value.length),
            );
          },
          // Number ke liye decimal aur signed (minus) options enable karein
          keyboardType: inputType == "number"
              ? const TextInputType.numberWithOptions(decimal: true, signed: true)
              : TextInputType.text,
          inputFormatters: [
            // Filter use karne ka sahi tarika
            inputType == "number"
                ? FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'))
                : FilteringTextInputFormatter.allow(pattern),
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
      ],
    );
  }


  static Widget _buildMultiline(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: .5)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: 3,
          textCapitalization: TextCapitalization.characters,
          onChanged: (value) {
            controller.value = controller.value.copyWith(
              text: value.toUpperCase(),
              selection: TextSelection.collapsed(offset: value.length),
            );
          },
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
