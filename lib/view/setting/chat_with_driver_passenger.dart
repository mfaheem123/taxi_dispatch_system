import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

        final bool isDriver =
            controller.selectMessageRole == "Driver"; // selected role

        final currentItems = isDriver ? driverItems : passengerItems;
        final currentSelections =
            isDriver ? driverSelections : passengerSelections;

        return Container(
          width: maxWidth,
          height: fieldWidth / 1.2,
          color: Colors.white,
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Left Sidebar =====
                    Container(
                      width: 250,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          // Dropdown for selecting Driver / Passenger
                          SizedBox(
                            width: 250,
                            child: CustomDropdownField<String>(
                              text: AppText.selectMessage,
                              width: fieldWidth / 2,
                              label: AppText.selectMessage,

                              items: [
                                "Driver",
                                "Passenger",
                              ],
                              value: controller.selectMessageRole,
                              itemLabel: (val) => val,
                              onChanged: (val) {
                                controller.selectMessageRole = val!;
                                controller.update();
                              },
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Checkbox (Send to all)
                          KeyboardCheckbox(
                            onChanged: (v) {
                              controller.sendToAllValue.value = v;
                              controller.update();
                            },
                            label: AppText.sendAll,
                            value: controller.sendToAllValue.value,
                            focusNode: controller.sendToAllNode,
                            width: 200,
                          ),

                          const SizedBox(height: 10),

                          // ===== Dynamic Message List with Checkboxes =====
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

                    const SizedBox(width: 16),

                    // ===== Right Side (Chat Area) =====
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: const ChatMessagesArea()),
                          ChatInputBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }

  // ===== Helper Widget for message list items with checkbox =====
  Widget _messageListWithCheckbox(
    String title, {
    required bool selected,
    required bool isChecked,
    required VoidCallback onTap,
    required ValueChanged<bool?> onCheckChanged,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? DynamicColors.primaryClr : Colors.white,
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(
          //   color: selected ? DynamicColors.primaryClr : Colors.grey.shade300,
          // ),
        ),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: isChecked,
              onChanged: onCheckChanged,
              activeColor: DynamicColors.primaryClr,
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
        "No messages yet",
        style: TextStyle(color: DynamicColors.gryClr),
      ),
    );
  }
}

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: DynamicColors.gryClr)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write your message here",
                filled: true,
                fillColor: DynamicColors.whiteClr,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: DynamicColors.gryClr),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
            color: DynamicColors.primaryClr,
          ),
        ],
      ),
    );
  }
}
