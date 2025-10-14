import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
// class ChatWithDriverAndPassenger extends StatelessWidget {

class ChatWithDriverAndPassenger extends StatefulWidget {
  const ChatWithDriverAndPassenger({super.key});

  @override
  State<ChatWithDriverAndPassenger> createState() =>
      ChatWithDriverAndPassengerState();
}

class ChatWithDriverAndPassengerState
    extends State<ChatWithDriverAndPassenger> {
  String? selectedMenu;

  // Menu items
  final List<String> menuItems = [
    "Message 1",
    "Message 2",
    "Message 3",
    "Message 4",
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar

                Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListView(
                    children: menuItems
                        .map((item) => _menuItem(item,
                                selected: item == selectedMenu, onTap: () {
                              setState(() {
                                selectedMenu = item;
                              });
                            }))
                        .toList(),
                  ),
                ),

                const SizedBox(width: 16),

                // Right Side Permission Panels
                Expanded(
                  child: Column(
                    children: [
                      (selectedMenu!.isNotEmpty)
                          ? ChatMessagesArea()
                          : Text("No Message"),
                      Expanded(child: ChatInputBox())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Menu
  Widget _menuItem(String title,
      {bool selected = false, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: selected ? DynamicColors.primaryClr : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: selected ? Colors.white : DynamicColors.primaryClr,
              fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ChatMessagesArea extends StatelessWidget {
  const ChatMessagesArea({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          "No messages yet",
          style: TextStyle(color: Colors.grey),
        ),
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
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write your message here",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
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
