import 'package:dashboard_new1/component/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main_appbar/components/main_bottom_bar.dart';
import 'controller/driver_chat_controller.dart';
import 'model/driver_chat_model.dart';

class ChatWithDriverAndPassenger extends StatelessWidget {
  const ChatWithDriverAndPassenger({super.key});

  static const Color primaryColor = Color(0xff424899);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverChatController>(
      init: DriverChatController.to,
      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5FA),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Top Panel Header
              _buildPanelHeader(context, controller),

              // Main Body
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isNarrow = constraints.maxWidth < 390;
                    final activeDriver = controller.selectedDriver.value;

                    // Narrow screens: drill-down (list or chat)
                    if (isNarrow) {
                      if (activeDriver == null) {
                        return _buildDriversSidebar(controller, isNarrow: true);
                      } else {
                        return _buildChatArea(controller, isNarrow: true);
                      }
                    }

                    // Compact / Desktop 2-column layout
                    final double sidebarWidth = (constraints.maxWidth * 0.42)
                        .clamp(170.0, 240.0);

                    return Row(
                      children: [
                        SizedBox(
                          width: sidebarWidth,
                          child: _buildDriversSidebar(controller, isNarrow: false),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFFE2E8F0),
                        ),
                        Expanded(
                          child: activeDriver == null
                              ? _buildEmptyState(controller)
                              : _buildChatArea(controller, isNarrow: false),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Top Panel Header ---
  Widget _buildPanelHeader(BuildContext context, DriverChatController controller) {
    final isOnline = controller.isConnected.value;
    final isConnecting = controller.isConnecting.value;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: primaryColor, // Color(0xff424899)
      ),
      child: Row(
        children: [
          const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            "CHAT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(width: 8),

          // Role & ID Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.currentUserRole,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                  ),
                ),
                // Text(
                //   " #${controller.currentUserId}",
                //   style: TextStyle(
                //     color: Colors.white.withValues(alpha: 0.9),
                //     fontSize: 10.5,
                //   ),
                // ),
              ],
            ),
          ),

          const Spacer(),

          // Status Badge
          InkWell(
            onTap: () {
              if (!isOnline && !isConnecting) {
                controller.connectWs();
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isOnline
                    ? Colors.white.withValues(alpha: 0.18)
                    : isConnecting
                        ? Colors.amber.withValues(alpha: 0.25)
                        : Colors.redAccent.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isOnline
                      ? Colors.white.withValues(alpha: 0.4)
                      : isConnecting
                          ? Colors.amber
                          : Colors.redAccent,
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: isOnline
                          ? const Color(0xFF80D8FF)
                          : isConnecting
                              ? Colors.amber
                              : Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    controller.connectionStatus.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Close button
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
            tooltip: "Close Chat",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () {
              messagesShow.value = false;
            },
          ),
        ],
      ),
    );
  }

  // --- Left Sidebar: Drivers List ---
  Widget _buildDriversSidebar(DriverChatController controller, {required bool isNarrow}) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: TextField(
                      controller: controller.searchDriverController,
                      onChanged: controller.filterDrivers,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        prefixIcon: const Icon(Icons.search, size: 16, color: primaryColor),
                        prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: controller.searchDriverController,
                          builder: (context, value, _) {
                            if (value.text.isNotEmpty) {
                              return IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                onPressed: () {
                                  controller.searchDriverController.clear();
                                  controller.filterDrivers('');
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 17, color: primaryColor),
                  tooltip: "Refresh Drivers",
                  onPressed: controller.fetchDrivers,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          // Drivers List
          Expanded(
            child: Builder(builder: (context) {
              if (controller.isLoadingDrivers.value) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                  ),
                );
              }

              final drivers = controller.filteredDriversList;

              if (drivers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_off_outlined, size: 30, color: Colors.grey.shade400),
                        const SizedBox(height: 6),
                        Text(
                          "No drivers found",
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: drivers.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 48,
                  color: Color(0xFFF1F5F9),
                ),
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  final isSelected = controller.selectedDriver.value?.id == driver.id;

                  return _buildDriverTile(controller, driver, isSelected);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- Driver List Item ---
  Widget _buildDriverTile(DriverChatController controller, ChatDriver driver, bool isSelected) {
    return Material(
      color: isSelected ? const Color(0xFFEEF0FA) : Colors.white,
      child: InkWell(
        onTap: () => controller.selectDriver(driver),
        hoverColor: const Color(0xFFF8FAFC),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected ? primaryColor : Colors.transparent,
                width: 3.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                child: Text(
                  driver.name.isNotEmpty
                      ? driver.name.substring(0, 1).toUpperCase()
                      : "D",
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF334155),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            driver.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? primaryColor : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        // Text(
                        //   "#${driver.id}",
                        //   style: TextStyle(
                        //     fontSize: 10,
                        //     color: Colors.grey.shade500,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Text(
                    //   driver.vehicleNumber,
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: TextStyle(
                    //     fontSize: 11,
                    //     color: Colors.grey.shade600,
                    //   ),
                    // ),
                  ],
                ),
              ),

              // Unread Badge
              if (driver.unreadCount > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: DynamicColors.redClr,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    "${driver.unreadCount}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- Right Main Area: Chat Messages & Input ---
  Widget _buildChatArea(DriverChatController controller, {required bool isNarrow}) {
    final driver = controller.selectedDriver.value;
    if (driver == null) return _buildEmptyState(controller);

    return Container(
      color: const Color(0xFFF9FAFD),
      child: Column(
        children: [
          // Chat Top Header
          _buildChatTopHeader(controller, driver, isNarrow),

          // Message Bubbles Area
          Expanded(
            child: Builder(builder: (context) {
              if (controller.isLoadingHistory.value) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: primaryColor),
                  ),
                );
              }

              final messages = controller.messages;

              if (messages.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 20, color: primaryColor),
                        const SizedBox(height: 4),
                        Text(
                          "Direct dispatch with ${driver.name}",
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Type a message to start.",
                          style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isSent = msg.isSentByMe(
                    controller.currentUserId,
                    controller.currentUserRole,
                  );
                  return _buildMessageBubble(msg, isSent);
                },
              );
            }),
          ),

          // Chat Input Box
          _buildChatInputBox(controller),
        ],
      ),
    );
  }

  // --- Chat Top Header ---
  Widget _buildChatTopHeader(
    DriverChatController controller,
    ChatDriver driver,
    bool isNarrow,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F9),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          if (isNarrow)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryColor, size: 18),
              onPressed: () {
                controller.selectedDriver.value = null;
                controller.update();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            ),
          CircleAvatar(
            radius: 14,
            backgroundColor: primaryColor,
            child: Text(
              driver.name.isNotEmpty ? driver.name.substring(0, 1).toUpperCase() : "D",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${driver.name} (${driver.username})",

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                controller.isDriverTyping.value
                    ? const Text(
                        "typing...",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                        driver.vehicleNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 18, color: primaryColor),
            tooltip: "Reload History",
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
            onPressed: () => controller.loadChatHistory(driver.id),
          ),
        ],
      ),
    );
  }

  // --- Message Bubble ---
  Widget _buildMessageBubble(ChatMessage msg, bool isSent) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFFEDEFFF) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Radius.circular(isSent ? 10 : 2),
            bottomRight: Radius.circular(isSent ? 2 : 10),
          ),
          border: Border.all(
            color: isSent
                ? primaryColor.withValues(alpha: 0.2)
                : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message text
            SelectableText(
              msg.content,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 3),

            // Meta: Time and Ticks
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.formattedTime,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: Colors.grey.shade500,
                  ),
                ),
                if (isSent) ...[
                  const SizedBox(width: 4),
                  _buildTickIcon(msg),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Tick Icons: Single Tick, Double Tick, Double Blue/Purple Tick ---
  Widget _buildTickIcon(ChatMessage msg) {
    // 1. Read: Double Primary Color Tick
    if (msg.isRead || msg.status == 'READ') {
      return const Text(
        "✓✓",
        style: TextStyle(
          color: primaryColor, // Color(0xff424899)
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: -1.5,
        ),
      );
    }

    // 2. Delivered: Double Grey Tick
    if (msg.status == 'DELIVERED') {
      return Text(
        "✓✓",
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: -1.5,
        ),
      );
    }

    // 3. Sent / Pending: Single Grey Tick
    return Text(
      "✓",
      style: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );
  }


// --- Chat Input Box ---
  Widget _buildChatInputBox(DriverChatController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: Color(0xFFF0F2F9),
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: TextField(
                controller: controller.messageInputController,
                onChanged: controller.onTypingChanged,
                onSubmitted: (_) => controller.sendMessage(),
                style: const TextStyle(fontSize: 12.5),
                // Centering the cursor and text vertically
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                  border: InputBorder.none,
                  // Adjust vertical padding to 0 and horizontal for left spacing
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  isDense: true, // Reduces the height of the internal input field
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: primaryColor,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              onTap: controller.sendMessage,
              borderRadius: BorderRadius.circular(18),
              child: const SizedBox(
                width: 34,
                height: 34,
                child: Icon(Icons.send_rounded, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // --- Empty State ---
  Widget _buildEmptyState(DriverChatController controller) {
    return Container(
      color: const Color(0xFFF9FAFD),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 26,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Select a Driver",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose any driver from the list on the left to start dispatch chat.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}