import 'package:dashboard_new1/alert/restrict_drivers_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../component/text_widget.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';

class SendEmailAlert extends StatefulWidget {
  const SendEmailAlert({super.key});

  @override
  State<SendEmailAlert> createState() => _SendEmailAlertState();
}

class _SendEmailAlertState extends State<SendEmailAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        // insetPadding: EdgeInsets.all(20),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
            // height: 390,
            width: 650,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withOpacity(0.5),
                        // borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined,
                              color: DynamicColors.primaryClr),
                          const SizedBox(width: 10),
                          Text(
                            "COMPOSE EMAIL",
                            style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("FROM"),
                        CustomTextField(
                          hintText: "NEXUSTECHNOLOGYGROUPS@GMAIL.COM",
                          controller: dashBoardCntrl.sendEmailController,
                          borderRadius: 6,
                          readOnly: true,
                        ),
                        SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("SEARCH RECIPIENT"),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: CustomTextField(
                                      hintText: "NAME OR EMAIL...",
                                      controller:
                                          dashBoardCntrl.emailToController,
                                      borderRadius: 6,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                      width: 140,
                                      height: 36,
                                      child: CustomDropdownField<String>(
                                        label: "SELECT",
                                        width: 140,
                                        height: 36,
                                        items: sendEmailRoleList,
                                        value: selectedRole,
                                        itemLabel: (role) => role,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedRole = val;
                                          });
                                        },
                                      )),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 36,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: DynamicColors.primaryClr,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.search,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildFieldLabel("TO EMAIL"),
                        CustomTextField(
                            borderRadius: 6,
                            hintText: "RECIPIENT@EXAMPLE.COM",
                            controller: dashBoardCntrl.subjectController),
                        const SizedBox(height: 14),
                        _buildFieldLabel("SUBJECT"),
                        CustomTextField(
                          hintText: "ENTER SUBJECT...",
                          controller: dashBoardCntrl.subjectController,
                          borderRadius: 6,
                        ),
                        const SizedBox(height: 14),
                        _buildFieldLabel("EMAIL CONTENT"),
                        CustomTextField(
                          hintText: "TYPE YOUR MESSAGE HERE...",
                          controller: dashBoardCntrl.typeEmailController,
                          maxLines: 4,
                          height: 90,
                          borderRadius: 6,
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 80,
                              height: 28,
                              verticalPadding: 0.0,
                              btnText: "CANCEL",
                              btnColor: Colors.grey.shade300,
                              borderRadius: 4,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                              onTap: () => Get.back(),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.send, size: 16),
                              label: Text(
                                "SEND EMAIL",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 38),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])));
  }

  Widget _buildFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SendMessageAlert extends StatefulWidget {
  const SendMessageAlert({super.key});

  @override
  State<SendMessageAlert> createState() => _SendMessageAlertState();
}

class _SendMessageAlertState extends State<SendMessageAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  String? selectedRole = "DRIVER";

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
            width: 580,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      color: DynamicColors.gryClr.withOpacity(0.5),
                      child: Row(
                        children: [
                          Icon(Icons.sms,
                              color: DynamicColors.primaryClr, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "COMPOSE TEXT MESSAGE",
                            style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SEARCH CONTACT BOX
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel("SEARCH CONTACT"),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: "NAME OR MOBILE #...",
                                      controller:
                                          dashBoardCntrl.mobileNoController,
                                      borderRadius: 6,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                      width: 120,
                                      height: 35,
                                      child: CustomDropdownField<String>(
                                        label: "SELECT",
                                        width: 100,
                                        height: 32,
                                        items: sendEmailRoleList,
                                        value: selectedRole,
                                        itemLabel: (role) => role,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedRole = val;
                                          });
                                        },
                                      )),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      // Search action
                                    },
                                    child: Container(
                                      height: 36,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: DynamicColors.primaryClr,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.search,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildFieldLabel("CONTACT NUMBER"),
                        CustomTextField(
                          hintText: "ENTER MOBILE NUMBER...",
                          controller: dashBoardCntrl.smsToController,
                          borderRadius: 6,
                        ),
                        const SizedBox(height: 16),

                        // MESSAGE CONTENT FIELD
                        _buildFieldLabel("MESSAGE CONTENT"),
                        CustomTextField(
                          hintText: "TYPE YOUR MESSAGE HERE...",
                          controller: dashBoardCntrl.typeYourMessageController,
                          maxLines: 5,
                          height: 110,
                          borderRadius: 6,
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 80,
                              height: 28,
                              verticalPadding: 0.0,
                              btnText: "CANCEL",
                              btnColor: Colors.grey.shade300,
                              borderRadius: 4,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                              onTap: () => Get.back(),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.send, size: 16),
                              label: Text(
                                "SEND SMS",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 38),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ])));
  }

  Widget _buildFieldLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
