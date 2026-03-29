 import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/administration/controller/administration_controller.dart';
import 'package:dashboard_new1/view/administration/model/get_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/dropdown_button.dart';
import '../../../component/keyboard_checkBox_widget.dart';
import '../model/get_role.dart';
import '../model/list_subsDiary.dart';

class CreateUserScreen extends StatelessWidget {
  CreateUserScreen({super.key});

  AdministrationController controller = Get.isRegistered<AdministrationController>()
      ? Get.find<AdministrationController>()
      : Get.put(AdministrationController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<AdministrationController>(builder: (controller) {
      return LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: isMobile
                ? Column(
                    children: [
                      _buildImageBox(isMobile, controller: controller),
                      SizedBox(height: 20),
                      _buildFormBox(screenHeight, screenHeight),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: 1,
                          child: _buildImageBox(isMobile, controller: controller)),
                      SizedBox(width: 20),

                      Flexible(
                          flex: 3,
                          child: _buildFormBox(screenHeight, screenWidth)),
                    ],
                  ),
          );
        },
      );
    });
  }

  Widget _buildImageBox(bool isMobile, {required dynamic controller}) {
    return GestureDetector(
      onTap: () {
        if (controller.userProfileImg == null && controller.employee?.image == null) {
          controller.pickImageCreate();
        }
      },
      child: Container(
        height: isMobile ? 200 : 400,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          image: controller.userProfileImg != null
              ? DecorationImage(
            image: MemoryImage(controller.userProfileImg!.bytes),
            fit: BoxFit.fill,
          )
              : (controller.employee?.image != null
              ? DecorationImage(
            image: NetworkImage(controller.employee!.image!),
            fit: BoxFit.fill,
          )
              : null),
        ),
        child: (controller.userProfileImg != null || controller.employee?.image != null)
            ? Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              controller.userProfileImg = null;
              if (controller.employee != null) {
                controller.employee!.image = null;
              }
              controller.update();
            },
            child: Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: DynamicColors.redClr,
                size: 20,
              ),
            ),
          ),
        )
            : Center(
          child: Text(
            "UPLOAD IMAGE",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormBox(double screenHeight, double screenWidth) {
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
                _buildTextField("USER", controller.userNameController),
                _buildTextField("EMAIL", controller.userEmailController),
                _buildPasswordField("PASSWORD", controller.passwordController),
                _buildPasswordField("CONFIRM PASSWORD", controller.confirmController),
                _buildTextField("PHONE", controller.phoneController),
                _buildTextField("FAX", controller.faxUserController),
                CustomDropdownField<Role>(
                  text: "SELECT ROLE",
                  label: "SELECT ROLE",
                  items: controller.getRole?.roles ?? [],   // safe
                  value: controller.selectedRole,
                  itemLabel: (role) {// debug
                    return role.name ?? "";
                  },
                  onChanged: (val) {
                    controller.selectedRole = val;
                    controller.update();
                  },
                ),
                CustomDropdownField<Subsidiaries>(
                  label: "SUBSIDIARY",
                  text: "SUBSIDIARY",
                  items: controller.subsDiaryModel?.subsidiaries ?? [],
                  value: controller.selectedSubsidiary,
                  itemLabel: (item) => item.name ?? "",
                  onChanged: (val) {
                    controller.selectedSubsidiary = val;
                    controller.update();
                  },
                ),
              ],
            ),
          ),
            Wrap(
              runSpacing: 16,
              spacing: 10,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: KeyboardCheckbox(
                    onChanged: (v) {
                      controller.activeValue.value = v;
                      controller.update();
                    },
                    value: controller.activeValue.value,
                    focusNode: controller.activeNode,
                    width: 120,
                    label: "ACTIVE",
                  ),
                ),
                KeyboardCheckbox(
                  onChanged: (v) {
                    print("CHECKBOX VALUE RECEIVED: $v");
                    controller.alldriversValue.value = v;
                    controller.update();
                  },
                  value: controller.alldriversValue.value,
                  focusNode: controller.alldriversNode,
                  width: 120,
                  label: "ALL DRIVERS",
                ),
                KeyboardCheckbox(
                  onChanged: (v) {
                    controller.allbookingValue.value = v;
                    controller.update();
                  },
                  value: controller.allbookingValue.value,
                  focusNode: controller.allbookingNode,
                  width: 140,
                  label: "ALL BOOKINGS",
                ),
                KeyboardCheckbox(
                  onChanged: (v) {
                    controller.accuntValue.value = v;
                    controller.update();
                  },
                  value: controller.accuntValue.value,
                  focusNode: controller.accuntNode,
                  width: 160,
                  label: "ALL ACCOUNTS",
                ),
                KeyboardCheckbox(
                  onChanged: (v) {
                    controller.receviverValue.value = v;
                    controller.update();
                  },
                  value: controller.receviverValue.value,
                  focusNode: controller.receviverNode,
                  width: 160,
                  label: "CALL RECEIVER",
                ),
                KeyboardCheckbox(
                  onChanged: (v) {
                    controller.transferValue.value = v;
                    controller.update();
                  },
                  value: controller.transferValue.value,
                  focusNode: controller.transferNode,
                  width: 240,
                  label: "ALLOW TRANSFER BOOKINGS",
                ),

              ],
            ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            color: DynamicColors.gryClr,
            padding: EdgeInsets.symmetric(horizontal: 120, vertical: 14),
            child: Center(
              child:
                  CustomButton(
                onTap: () {
                  controller.createUser();
                },
                height: 30,
                width: screenWidth / 4,
                verticalPadding: 0.0,
                borderRadius: 4,
                style: mozillaTextSemiBoldText(
                    fontSize: 12, color: DynamicColors.whiteClr),
                btnText: controller.employee!=null ? "UPDATE USER" : "SAVE",
              )

            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildTextField(String label, controller) {
    return SizedBox(
      width: Get.width / 4,
      height: 30,
      child: TextField(
        controller: controller,
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

  static Widget _buildPasswordField(String label, controller) {
    return SizedBox(
      width: Get.width / 4,
      height: 30,
      child: TextField(
        controller: controller,
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

  static Widget _buildCheckBox(String label,
      {bool checkBoxValue = false,
      ValueChanged<bool?>? onChanged,
      required FocusNode focusNode}) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          KeyboardCheckbox(
            onChanged: onChanged!,
            value: checkBoxValue,
            focusNode: focusNode,
          ),
          Text(label),
        ],
      ),
    );
  }
}
