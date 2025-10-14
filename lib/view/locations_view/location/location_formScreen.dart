import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LocationForm extends StatelessWidget {
  const LocationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Text(
                        "LOCATION",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// First Row (Location Name - Longitude)
                  isMobile
                      ? Column(
                    children: [
                      _buildField("LOCATION NAME"),
                      const SizedBox(height: 10),
                      _buildField("LONGITUDE"),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(child: _buildField("LOCATION NAME")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildField("LONGITUDE")),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Second Row (Postcode - Zone)
                  isMobile
                      ? Column(
                    children: [
                      _buildField("POSTCODE"),
                      const SizedBox(height: 10),
                      _buildDropdown("ZONE"),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(child: _buildField("POSTCODE")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildDropdown("ZONE")),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Third Row (Shortcut - Extra Charges)
                  isMobile
                      ? Column(
                    children: [
                      _buildField("SHORTCUT"),
                      const SizedBox(height: 10),
                      _buildField("EXTRA CHARGES"),
                    ],
                  )

                      : Row(
                    children: [
                      Expanded(child: _buildField("SHORTCUT")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildField("EXTRA CHARGES")),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// Fourth Row (Location Type - Latitude)
                  isMobile
                      ? Column(
                    children: [
                      _buildDropdown("LOCATION TYPE"),
                      const SizedBox(height: 10),
                      _buildField("LATITUDE"),
                    ],
                  )

                      : Row(
                    children: [
                      Expanded(child: _buildDropdown("LOCATION TYPE")),
                      const SizedBox(width: 10),
                      Expanded(child: _buildField("LATITUDE")),
                    ],
                  ),


                  const SizedBox(height: 15),


                  /// Address
                  _buildMultiline("ADDRESS"),
                  const SizedBox(height: 20),


                  /// Save Button
                  Container(
                    // height: screenHeight / 20,
                    width: double.infinity,
                    color: DynamicColors.gryClr,
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                    child: CustomButton(
                      height: 30,
                      width: Get.width / 4,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      style: mozillaTextSemiBoldText(
                          fontSize: 12, color: DynamicColors.whiteClr),
                      btnText: AppText.save,
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  static Widget _buildDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: "1", child: Text("Option 1")),
            DropdownMenuItem(value: "2", child: Text("Option 2")),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  static Widget _buildMultiline(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: .5)),
        const SizedBox(height: 5),
        TextField(
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
