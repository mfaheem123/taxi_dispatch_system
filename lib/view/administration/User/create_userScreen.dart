import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';

class CreateUserScreen extends StatelessWidget {
  CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: isMobile
              ? Column(
                  children: [
                    _buildImageBox(isMobile),
                    SizedBox(height: 20),
                    _buildFormBox(screenHeight),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image box fix with Flexible
                    Flexible(flex: 1, child: _buildImageBox(isMobile)),
                    SizedBox(width: 20),
                    // Form box fix with Flexible
                    Flexible(flex: 3, child: _buildFormBox(screenHeight)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildImageBox(bool isMobile) {
    return Container(
      height: isMobile ? 200 : 400,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "UPLOAD IMAGE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DynamicColors.gryClr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormBox(double screenHeight) {
    String? selectedValue;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: screenHeight / 20,
            width: double.infinity,
            color: DynamicColors.gryClr,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
              child: Text(
                "USER",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.textClr),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Wrap(
              runSpacing: 16,
              spacing: 20,
              children: [
                _buildTextField("USERNAME"),
                _buildTextField("EMAIL"),
                _buildPasswordField("PASSWORD"),
                _buildPasswordField("CONFIRM PASSWORD"),
                _buildTextField("PHONE"),
                _buildTextField("FAX"),
                CustomDropdownField<String>(
                  label: "ROLI",
                  items: ["SELECT ROLI"],
                  value: selectedValue,
                  itemLabel: (val) => val, // just show the string
                  onChanged: (val) {
                    selectedValue = val;
                  },
                ),
                _buildTextField("SURBIONARY"),
                _buildTextField("DIDIC COMPANY"),
                _buildCheckBox("ACTIVE"),
                _buildCheckBox("ALL DRIVERS"),
                _buildCheckBox("ALL BOOKINGS"),
                _buildCheckBox("ALL ACCOUNTS"),
                _buildCheckBox("CALL RECEIVER"),
                _buildCheckBox("ALLOW TRANSFER BOOKINGS"),
              ],
            ),
          ),
          SizedBox(height: 20),
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
    );
  }

  static Widget _buildTextField(String label) {
    return SizedBox(
      width: Get.width / 4,
      height: 30,
      child: TextField(
        style: mozillaTextRegularText(
          fontSize: 10,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: mozillaTextRegularText(
            fontSize: 10,
          ),
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  static Widget _buildPasswordField(String label) {
    return SizedBox(
      width: Get.width / 4,
      height: 30,
      child: TextField(
        obscureText: true,
        style: mozillaTextRegularText(
          fontSize: 10,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: mozillaTextRegularText(
            fontSize: 10,
          ),
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  static Widget _buildCheckBox(String label) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (v) {}),
          Text(label),
        ],
      ),
    );
  }
}

