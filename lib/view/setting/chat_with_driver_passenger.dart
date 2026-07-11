import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/dropdown_button.dart';
import 'package:dashboard_new1/component/keyboard_checkBox_widget.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/view/setting/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Model to hold a single chat message
class ChatMessage {
  final String text;
  final bool isMe; // true = sent by current user (right side), false = received (left side)
  final String senderName;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.senderName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

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

  /// ✅ Chat messages list — persisted at state level
  final List<ChatMessage> chatMessages = [];

  /// ScrollController to auto-scroll to bottom on new messages
  final ScrollController _chatScrollController = ScrollController();

  // Menu items (users in the sidebar)
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
  void dispose() {
    _chatScrollController.dispose();
    super.dispose();
  }

  /// Scroll chat to the bottom after a new message
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Called when the current user sends a message (appears on the RIGHT side)
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    setState(() {
      chatMessages.add(ChatMessage(
        text: message.trim(),
        isMe: true,
        senderName: 'You',
      ));
    });
    _scrollToBottom();
  }

  /// Called when a sidebar user is tapped — their data/message appears on the LEFT side
  void _onUserTapped(String userName) {
    setState(() {
      selectedMenu = userName;
      // Add the user's data as a received message on the left side
      chatMessages.add(ChatMessage(
        text: userName,
        isMe: false,
        senderName: userName,
      ));
    });
    _scrollToBottom();
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
          width: Get.width,
          // width: maxWidth,
          height: Get.height / 1.14,
          // height: fieldWidth / 1.2,
          color: Colors.white,
          padding: const EdgeInsets.all(0),
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
                          width: isMobile ? double.infinity : 250,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              // CustomDropdownField<String>(
                              //   text: AppText.selectMessage,
                              //   width: double.infinity,
                              //   label: AppText.selectMessage,
                              //   items: ["Driver", "Passenger"],
                              //   value: controller.selectMessageRole,
                              //   itemLabel: (val) => val,
                              //   onChanged: (val) {
                              //     controller.selectMessageRole = val!;
                              //     controller.update();
                              //   },
                              // ),

                              // const SizedBox(height: 15),

                              // Checkbox (Send to all)
                              // KeyboardCheckbox(
                              //   onChanged: (v) {
                              //     controller.sendToAllValue.value = v;
                              //     controller.update();
                              //   },
                              //   label: AppText.sendAll,
                              //   value: controller.sendToAllValue.value,
                              //   focusNode: controller.sendToAllNode,
                              //   width: 200,
                              // ),

                              const SizedBox(height: 10),

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
                                        _onUserTapped(item);
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
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ChatMessagesArea(
                                    chatMessages: chatMessages,
                                    scrollController: _chatScrollController,
                                  ),
                                ),
                                ChatInputBox(onSend: _sendMessage),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
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
        child:
        Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color:
            selected ? DynamicColors.whiteClr : DynamicColors.textClr,
          ),
        )
        /*Row(
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
        )*/,
      ),
    );
  }
}

/// ===== Chat Messages Area with left/right alignment =====
class ChatMessagesArea extends StatelessWidget {
  final List<ChatMessage> chatMessages;
  final ScrollController scrollController;

  const ChatMessagesArea({
    super.key,
    required this.chatMessages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (chatMessages.isEmpty) {
      return const Center(
        child: Text("No messages yet"),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: chatMessages.length,
      itemBuilder: (context, index) {
        final message = chatMessages[index];
        return _ChatBubble(message: message);
      },
    );
  }
}

/// ===== Individual Chat Bubble (right for "me", left for others) =====
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.55,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? DynamicColors.primaryClr
              : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show sender name for received messages (left side)
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: DynamicColors.primaryClr,
                  ),
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : DynamicColors.textClr,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// ===== Chat Input Box =====
class ChatInputBox extends StatefulWidget {
  final Function(String) onSend;

  const ChatInputBox({
    super.key,
    required this.onSend,
  });

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: DynamicColors.primaryClr),
                ),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: DynamicColors.primaryClr,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}