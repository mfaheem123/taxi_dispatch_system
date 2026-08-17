import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// class ChatWithDriverAndPassenger extends StatelessWidget {

class ChatWithDriverAndPassenger extends StatefulWidget {
  const ChatWithDriverAndPassenger({super.key});

  @override
  State<ChatWithDriverAndPassenger> createState() =>
      ChatWithDriverAndPassengerState();
}

class ChatWithDriverAndPassengerState
    extends State<ChatWithDriverAndPassenger> {
  SettingController controller = Get.isRegistered<SettingController>()
      ? Get.find<SettingController>()
      : Get.put(SettingController());

  String? selectedMenu;

  /// ✅ Checkbox selection states
  final Map<String, bool> driverSelections = {};
  final Map<String, bool> passengerSelections = {};

  // Menu items
  final List<String> passengerItems = [
    "Passenger Message 1",
    "Passenger Message 2",
    "Passenger Message 3",
    "Passenger Message 4",
  ];

  final List<String> driverItems = [
    "Driver Message 1",
    "Driver Message 2",
    "Driver Message 3",
    "Driver Message 4",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selection maps
    for (var item in passengerItems) {
      passengerSelections[item] = false;
    }
    for (var item in driverItems) {
      driverSelections[item] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        final double fieldWidth = isMobile
            ? maxWidth
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        final bool isDriver = controller.selectMessageRole == "Driver";

        final currentItems = isDriver ? driverItems : passengerItems;
        final currentSelections =
            isDriver ? driverSelections : passengerSelections;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Container(
              width: Get.width,
              height: Get.height / 1.14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isMobile = constraints.maxWidth < 600;

                        return Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== Left Sidebar =====
                            Container(
                              width: isMobile ? double.infinity : 280,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  CustomDropdownField<String>(
                                    text: AppText.selectMessage,
                                    width: double.infinity,
                                    label: AppText.selectMessage,
                                    items: ["Driver", "Passenger"],
                                    value: controller.selectMessageRole,
                                    itemLabel: (val) => val,
                                    onChanged: (val) {
                                      controller.selectMessageRole = val!;
                                      controller.update();
                                    },
                                  ),

                                  const SizedBox(height: 15),

                                  // Checkbox (Send to all)
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                        horizontal: 4),
                                    child: KeyboardCheckbox(
                                      onChanged: (v) {
                                        controller.sendToAllValue.value = v;
                                        controller.update();
                                      },
                                      label: AppText.sendAll,
                                      value: controller.sendToAllValue.value,
                                      focusNode: controller.sendToAllNode,
                                      width: double.infinity,
                                    ),
                                  ),

                                  const SizedBox(height: 30),

                                  // ===== Dynamic Message List =====
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: currentItems.length,
                                      itemBuilder: (context, index) {
                                        final item = currentItems[index];
                                        final isSelected =
                                            currentSelections[item] ?? false;
                                        return _messageListWithCheckbox(
                                          item,
                                          isChecked: isSelected,
                                          selected: item == selectedMenu,
                                          onTap: () {
                                            setState(() {
                                              selectedMenu = item;
                                            });
                                          },
                                          onCheckChanged: (val) {
                                            setState(() {
                                              currentSelections[item] = val!;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                                width: isMobile ? 0 : 16,
                                height: isMobile ? 16 : 0),

                            // ===== Right Chat Section =====
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: const Column(
                                  children: [
                                    Expanded(child: ChatMessagesArea()),
                                    ChatInputBox(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  // =====   message list items with checkbox =====
  Widget _messageListWithCheckbox(
    String title, {
    required bool selected,
    required bool isChecked,
    required VoidCallback onTap,
    required ValueChanged<bool?> onCheckChanged,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: selected ? DynamicColors.primaryClr : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? DynamicColors.primaryClr : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: isChecked,
              onChanged: onCheckChanged,
              activeColor: DynamicColors.primaryClr,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color:
                      selected ? DynamicColors.whiteClr : DynamicColors.textClr,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessagesArea extends StatelessWidget {
  const ChatMessagesArea({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "NO MESSAGES YET",
        style: TextStyle(color: DynamicColors.black, fontSize: 14),
      ),
    );
  }
}

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "WRITE YOUR MESSAGE HERE",
                hintStyle: TextStyle(color: DynamicColors.black, fontSize: 14),
                filled: true,
                fillColor: DynamicColors.whiteClr,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: DynamicColors.primaryClr),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: DynamicColors.primaryClr.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {},
              color: DynamicColors.primaryClr,
            ),
          ),
        ],
      ),
    );
  }
}