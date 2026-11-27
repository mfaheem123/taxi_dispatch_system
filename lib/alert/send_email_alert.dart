import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../component/text_field.dart';
import '../view/dashboard_view/Controller/dashboard_controller.dart';
import '../view/dashboard_view/models/sms_email_search_model.dart';

/// Reusable contact selection dialog for both Email and SMS
void showSelectContactDialog({
  required BuildContext context,
  required List<SearchContactItem> items,
  required String dialogTitle,
  required String valueHeaderTitle,
  required String Function(SearchContactItem item) getValue,
  required String emptyWarningText,
  required Function(List<String> selectedValues) onConfirmed,
}) {
  Map<int, bool> selectedMap = {};

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 580,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.list, color: DynamicColors.primaryClr, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            dialogTitle,
                            style: titleDesign(),
                          ),
                        ],
                      ),
                      FocusTraversalOrder(
                        order: const NumericFocusOrder(999),
                        child: const AlertCloseButton(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Table Header
                Container(
                  color: const Color(0xFFF1F5F9),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 40,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "CONTACT NAME",
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          valueHeaderTitle,
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // List items
                SizedBox(
                  height: 250,
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = item.name ?? '';
                      final valStr = getValue(item);
                      final isSelected = selectedMap[index] ?? false;

                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedMap[index] = !isSelected;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Checkbox(
                                  value: isSelected,
                                  activeColor: DynamicColors.primaryClr,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (val) {
                                    setDialogState(() {
                                      selectedMap[index] = val ?? false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  name,
                                  style: outFitRegular(fontSize: 12, color: Colors.black87),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  valStr,
                                  style: outFitRegular(fontSize: 12, color: valStr.isEmpty ? Colors.grey : Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                // Footer buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2E8F0),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "CLOSE",
                          style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColors.primaryClr,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        onPressed: () {
                          List<String> selectedValues = [];
                          selectedMap.forEach((idx, isSel) {
                            if (isSel && idx < items.length) {
                              final val = getValue(items[idx]);
                              if (val.trim().isNotEmpty) {
                                selectedValues.add(val.trim());
                              }
                            }
                          });

                          if (selectedValues.isEmpty) {
                            BotToast.showText(text: emptyWarningText);
                            return;
                          }

                          onConfirmed(selectedValues);

                          Get.back();
                        },
                        label: Text(
                          "CONFIRM SELECTION",
                          style: mozillaTextSemiBoldText(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

/// SEND by Email 

class SendEmailAlert extends StatefulWidget {
  const SendEmailAlert({super.key});
  @override
  State<SendEmailAlert> createState() => _SendEmailAlertState();
}

class _SendEmailAlertState extends State<SendEmailAlert> {
  final recipientController = TextEditingController();
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "alert";
    dashBoardCntrl.fetchSendEmailCompanyConfiguration();
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  String? selectedRole = "CUSTOMER";

  void _searchContacts() {
    dashBoardCntrl.searchEmailContacts(selectedRole, (items) {
      if (mounted) {
        showSelectContactDialog(
          context: context,
          items: items,
          dialogTitle: "SELECT EMAIL ADDRESSES",
          valueHeaderTitle: "EMAIL ADDRESS",
          getValue: (item) => item.email ?? '',
          emptyWarningText: "Please select at least one contact with a valid email",
          onConfirmed: (selectedEmails) {
            recipientController.text = selectedEmails.join(', ');
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
            width: 500,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: DynamicColors.gryClr.withOpacity(0.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined,
                              color: DynamicColors.primaryClr),
                          const SizedBox(width: 10),
                          Text(
                            "COMPOSE EMAIL",
                            style: titleDesign()),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child: const AlertCloseButton(),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("FROM"),
                        CustomTextField(
                          hintText: "NEXUSTECHNOLOGYGROUPS@GMAIL.COM",
                          hintStyle: outFitRegular(fontSize: 11),
                          controller: dashBoardCntrl.sendEmailController,
                          borderRadius: 6,
                          readOnly: true,
                        ),
                        const SizedBox(height: 14),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: CustomTextField(
                                      hintText: "NAME OR EMAIL...",
                                      hintStyle: outFitRegular(fontSize: 11),
                                      controller: dashBoardCntrl.emailToController,
                                      borderRadius: 6,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      onSubmitted: (val) => _searchContacts(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                      width: 140,
                                      height: 30,
                                      child: CustomDropdownField<String>(
                                        label: "SELECT",
                                        width: 140,
                                        height: 30,
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
                                    onTap: _searchContacts,
                                    child: Container(
                                      height: 30,
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
                            hintText: "RECIPIENTS@EXAMPLE.COM",
                            hintStyle: outFitRegular(fontSize: 11, fontWeight: FontWeight.w100),
                            controller: recipientController,
                          inputFormatters: [UpperCaseTextFormatter()]
                        ),
                        const SizedBox(height: 14),
                        _buildFieldLabel("SUBJECT"),
                        CustomTextField(
                          hintText: "ENTER SUBJECT...",
                          hintStyle: outFitRegular(fontSize: 11),
                          controller: dashBoardCntrl.subjectController,
                          borderRadius: 6,
                          inputFormatters: [UpperCaseTextFormatter()],
                        ),
                        const SizedBox(height: 14),
                        _buildFieldLabel("EMAIL CONTENT"),
                        CustomTextField(
                          hintText: "TYPE YOUR MESSAGE HERE...",
                          hintStyle: outFitRegular(fontSize: 11),
                          controller: dashBoardCntrl.typeEmailController,
                          maxLines: 4,
                          height: 90,
                          borderRadius: 6,
                          contentPadding: const EdgeInsets.all(10),
                          inputFormatters: [UpperCaseTextFormatter()],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 80,
                              height: 28,
                              verticalPadding: 0.0,
                              btnText: "CANCEL",
                              btnColor: Colors.red,
                              borderRadius: 4,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              onTap: () => Get.back(),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                dashBoardCntrl.sendEmail(recipientController.text);
                              },
                              icon: const Icon(Icons.send, size: 16),
                              label: Text(
                                "SEND EMAIL",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(150, 38),
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
        style: outFitRegular(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}


///  SEND by Number 

class SendMessageAlert extends StatefulWidget {
  const SendMessageAlert({super.key});
  @override
  State<SendMessageAlert> createState() => _SendMessageAlertState();
}

class _SendMessageAlertState extends State<SendMessageAlert> {
  final dashBoardCntrl = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "alert";
  }

  List<String> sendEmailRoleList = [
    "DRIVER",
    "CUSTOMER",
    "ACCOUNT",
  ];

  String? selectedRole = "DRIVER";

  void _searchContacts() {
    dashBoardCntrl.searchSmsContacts(selectedRole, (items) {
      if (mounted) {
        showSelectContactDialog(
          context: context,
          items: items,
          dialogTitle: "SELECT CONTACT NUMBERS",
          valueHeaderTitle: "MOBILE NUMBER",
          getValue: (item) => item.mobile ?? '',
          emptyWarningText: "Please select at least one contact with a valid mobile number",
          onConfirmed: (selectedNumbers) {
            dashBoardCntrl.smsToController.text = selectedNumbers.join(', ');
            dashBoardCntrl.mobileNoController.clear();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
            width: 450,
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
                            style: titleDesign()),
                          const Spacer(),
                          FocusTraversalOrder(
                            order: const NumericFocusOrder(999),
                            child:  AlertCloseButton(onTap:  (){
                          dashBoardCntrl.mobileNoController.clear();
                          dashBoardCntrl.smsToController.clear();
                          dashBoardCntrl.typeYourMessageController.clear();
                          Get.back();
                          }
                          ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: "MOBILE #...",
                                      hintStyle: outFitRegular(fontSize: 11),
                                      controller: dashBoardCntrl.mobileNoController,
                                      borderRadius: 6,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      onSubmitted: (val) => _searchContacts(),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                      width: 120,
                                      height: 30,
                                      child: CustomDropdownField<String>(
                                        label: "SELECT",
                                        width: 100,
                                        height: 30,
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
                                    onTap: _searchContacts,
                                    child: Container(
                                      height: 30,
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
                          hintStyle: outFitRegular(fontSize: 11),
                          controller: dashBoardCntrl.smsToController,
                          borderRadius: 6,
                          inputFormatters: [UpperCaseTextFormatter()],
                        ),
                        const SizedBox(height: 16),

                        // MESSAGE CONTENT FIELD
                        _buildFieldLabel("MESSAGE CONTENT"),
                        CustomTextField(
                          hintText: "TYPE YOUR MESSAGE HERE...",
                          hintStyle: outFitRegular(fontSize: 11),
                          controller: dashBoardCntrl.typeYourMessageController,
                          maxLines: 5,
                          height: 110,
                          borderRadius: 6,
                          contentPadding: const EdgeInsets.all(10),
                          inputFormatters: [UpperCaseTextFormatter()],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 80,
                              height: 28,
                              verticalPadding: 0.0,
                              btnText: "CANCEL",
                              btnColor: Colors.red,
                              borderRadius: 4,
                              style: mozillaTextSemiBoldText(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              onTap: () {
                                dashBoardCntrl.mobileNoController.clear();
                                dashBoardCntrl.smsToController.clear();
                                dashBoardCntrl.typeYourMessageController.clear();
                                Get.back();
                              }
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () {
                                dashBoardCntrl.sendSms(dashBoardCntrl.smsToController.text);
                              },
                              icon: const Icon(Icons.send, size: 16),
                              label: Text(
                                "SEND SMS",
                                style: mozillaTextSemiBoldText(
                                    fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(130, 38),
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
        style: outFitRegular(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
