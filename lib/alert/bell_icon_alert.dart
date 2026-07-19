import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Model class for a single notification item
class NotificationItem {
  final String message;
  bool isRead;

  NotificationItem({
    required this.message,
    this.isRead = false,
  });
}

/// Static class to show notification bell alert dropdown
/// Call: BellIconAlert.show(context)
class BellIconAlert {

  /// Notifications list — replace with real data / controller
  static List<NotificationItem> notifications = [
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "DRIVER 26 MESSAGE"),
    NotificationItem(message: "A WEB BOOKING IS CREATED"),
    NotificationItem(message: "A WEB BOOKING IS CREATED"),
    NotificationItem(message: "A WEB BOOKING IS CREATED"),
  ];

  /// Call this from GestureDetector onTap
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return _NotificationDialog();
      },
    );
  }
}

class _NotificationDialog extends StatefulWidget {
  @override
  State<_NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<_NotificationDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKey);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.offset + 60,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.offset - 60,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  void _markAllRead() {
    setState(() {
      for (var n in BellIconAlert.notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, right: 60),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340,
            constraints: const BoxConstraints(maxHeight: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NOTIFICATIONS",
                        style: mozillaTextSemiBoldText(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      GestureDetector(
                        onTap: _markAllRead,
                        child: Text(
                          "MARK ALL READ",
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                              fontWeight: FontWeight.bold,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Divider ──
                Divider(height: 1, color: Colors.grey.shade200),

                // ── Notification List ──
                Flexible(
                  child: BellIconAlert.notifications.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.notifications_off_outlined,
                                  size: 40, color: Colors.grey.shade300),
                              const SizedBox(height: 10),
                              Text(
                                "No notifications",
                                style: mozillaTextRegularText(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: BellIconAlert.notifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationTile(
                                BellIconAlert.notifications[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ── Green bell icon ──
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
              size: 18,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(width: 14),
          // ── Message text ──
          Expanded(
            child: Text(
              notification.message,
              style: mozillaTextSemiBoldText(
                fontSize: 12,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
