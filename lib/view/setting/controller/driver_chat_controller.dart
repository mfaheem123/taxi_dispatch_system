import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../component/networks/Url.dart';
import '../../../component/networks/api.dart';
import '../../administration/model/user_model.dart';
import '../model/driver_chat_model.dart';

class DriverChatController extends GetxController {
  static DriverChatController get to {
    if (Get.isRegistered<DriverChatController>()) {
      return Get.find<DriverChatController>();
    }
    return Get.put(DriverChatController());
  }

  final sp = GetStorage();

  // Connection states
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionStatus = "Offline".obs;

  // Data states
  final RxBool isLoadingDrivers = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxList<ChatDriver> driversList = <ChatDriver>[].obs;
  final RxList<ChatDriver> filteredDriversList = <ChatDriver>[].obs;
  final Rxn<ChatDriver> selectedDriver = Rxn<ChatDriver>();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isDriverTyping = false.obs;
  final RxInt totalUnreadCount = 0.obs;

  // Input & search controllers
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController searchDriverController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // WebSocket & Timers
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Timer? _typingTimer;

  // User details retrieved from session/storage
  String get currentUserId {
    final storedUser = sp.read('userData');
    if (storedUser != null && storedUser['id'] != null) {
      return storedUser['id'].toString();
    }
    if (Employee.selectedEmployee?.id != null) {
      return Employee.selectedEmployee!.id.toString();
    }
    return "34";
  }

  String get companyId {
    final cid = sp.read('company_id');
    if (cid != null && cid.toString().trim().isNotEmpty) {
      return cid.toString().trim();
    }
    final storedUser = sp.read('userData');
    if (storedUser != null && storedUser['company_id'] != null) {
      return storedUser['company_id'].toString().trim();
    }
    return Api.singleton.globalCompanyId;
  }

  String get currentUserRole {
    final r = sp.read('userRole');
    if (r != null && r.toString().trim().isNotEmpty) {
      return r.toString().trim().toUpperCase();
    }
    final storedUser = sp.read('userData');
    if (storedUser != null && storedUser['role'] != null) {
      final roleObj = storedUser['role'];
      if (roleObj is Map && roleObj['name'] != null) {
        return roleObj['name'].toString().trim().toUpperCase();
      }
    }
    if (Employee.selectedEmployee?.role?.name != null) {
      return Employee.selectedEmployee!.role!.name!.trim().toUpperCase();
    }
    return "ADMIN";
  }

  String get currentUserName {
    final storedUser = sp.read('userData');
    if (storedUser != null && storedUser['name'] != null) {
      return storedUser['name'].toString();
    }
    if (Employee.selectedEmployee?.username != null) {
      return Employee.selectedEmployee!.username!;
    }
    return "Web Operator";
  }

  @override
  void onInit() {
    super.onInit();
    fetchDrivers();
    connectWs();
  }

  @override
  void onClose() {
    disconnectWs();
    _typingTimer?.cancel();
    _reconnectTimer?.cancel();
    messageInputController.dispose();
    searchDriverController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // --- WebSocket Connection ---
  void connectWs() {
    if (isConnected.value || isConnecting.value) return;

    isConnecting.value = true;
    connectionStatus.value = "Connecting...";
    update();

    try {
      String base = Environment().config.socketUrl;
      while (base.endsWith('/')) {
        base = base.substring(0, base.length - 1);
      }

      final wsUri = Uri.parse(
        "$base/chat?company_id=$companyId&user_id=$currentUserId&role=$currentUserRole",
      );

      debugPrint("🔌 Connecting Chat WebSocket: $wsUri");
      _channel = WebSocketChannel.connect(wsUri);

      _subscription = _channel!.stream.listen(
        (data) {
          if (!isConnected.value) {
            isConnected.value = true;
            isConnecting.value = false;
            connectionStatus.value = "Online";
            update();
            debugPrint("✅ Chat WebSocket Connected!");
          }
          handleIncomingWSMessage(data);
        },
        onError: (error) {
          debugPrint("❌ Chat WebSocket Error: $error");
          _handleDisconnect();
        },
        onDone: () {
          debugPrint("🔌 Chat WebSocket Closed");
          _handleDisconnect();
        },
      );
    } catch (e) {
      debugPrint("❌ Chat WebSocket Exception: $e");
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    isConnected.value = false;
    isConnecting.value = false;
    connectionStatus.value = "Offline";
    update();
    _subscription?.cancel();
    _subscription = null;
    _channel = null;

    // Auto-reconnect after 4 seconds
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 4), () {
      if (!isConnected.value) {
        connectWs();
      }
    });
  }

  void disconnectWs() {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    isConnected.value = false;
    isConnecting.value = false;
    connectionStatus.value = "Offline";
    update();
  }

  // --- Handling Incoming WS Messages ---
  void handleIncomingWSMessage(dynamic rawData) {
    try {
      final Map<String, dynamic> payload = jsonDecode(rawData.toString());
      final String? eventType = payload['event'];
      final dynamic data = payload['data'];

      debugPrint("📩 WS Chat Event Received: $eventType => $data");

      if (eventType == 'message_sent_ack') {
        if (data != null && data['message'] != null) {
          final newMsg = ChatMessage.fromJson(data['message']);
          _addOrUpdateMessage(newMsg);
        }
      } else if (eventType == 'new_message') {
        if (data != null) {
          final newMsg = ChatMessage.fromJson(data);
          final currentTarget = selectedDriver.value;
          final myRole = currentUserRole;

          bool isForCurrentWindow = false;
          if (currentTarget != null) {
            final sId = newMsg.senderId?.toString();
            final rId = newMsg.receiverId?.toString();
            final cId = currentTarget.id.toString();
            final sRole = (newMsg.senderRole ?? '').toUpperCase();
            final rRole = (newMsg.receiverRole ?? '').toUpperCase();

            if ((sId == cId || rId == cId) &&
                (sRole == myRole || rRole == myRole || sRole == 'DRIVER' || rRole == 'DRIVER')) {
              isForCurrentWindow = true;
            }
          }

          if (isForCurrentWindow) {
            _addOrUpdateMessage(newMsg);
            sendMarkAsRead([newMsg.id], currentTarget!.id, 'DRIVER');
          } else {
            // Increment unread badge for the driver
            final sId = newMsg.senderId;
            if (sId != null) {
              final dIndex = driversList.indexWhere((d) => d.id == sId);
              if (dIndex != -1) {
                driversList[dIndex].unreadCount++;
                driversList.refresh();
                filterDrivers(searchDriverController.text);
                _recalculateTotalUnread();
                update();
              }
            }
          }
        }
      } else if (eventType == 'message_status_update') {
        if (data != null) {
          final String? status = data['status'];
          final dynamic msgId = data['message_id'];
          if (msgId != null && status == 'DELIVERED') {
            final int id = msgId is int ? msgId : int.tryParse(msgId.toString()) ?? 0;
            final mIndex = messages.indexWhere((m) => m.id == id);
            if (mIndex != -1) {
              if (messages[mIndex].status != 'READ') {
                messages[mIndex].status = 'DELIVERED';
                messages.refresh();
                update();
              }
            }
          }
        }
      } else if (eventType == 'messages_read_ack') {
        if (data != null && data['message_ids'] is List) {
          final List ids = data['message_ids'];
          for (var item in ids) {
            final int id = item is int ? item : int.tryParse(item.toString()) ?? 0;
            final mIndex = messages.indexWhere((m) => m.id == id);
            if (mIndex != -1) {
              messages[mIndex].isRead = true;
              messages[mIndex].status = 'READ';
            }
          }
          messages.refresh();
          update();
        }
      } else if (eventType == 'user_typing') {
        if (data != null) {
          isDriverTyping.value = data['is_typing'] == true;
          update();
        }
      }
    } catch (e) {
      debugPrint("❌ Error parsing WS message: $e");
    }
  }

  void _addOrUpdateMessage(ChatMessage msg) {
    final existingIndex = messages.indexWhere((m) => m.id == msg.id);
    if (existingIndex != -1) {
      messages[existingIndex] = msg;
    } else {
      messages.add(msg);
    }
    messages.refresh();
    update();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- Fetch Drivers List ---
  Future<void> fetchDrivers() async {
    isLoadingDrivers.value = true;
    update();
    try {
      final res = await Api().get(
        "drivers/get?active=true",
        sendCompanyId: true,
      );

      if (res != null && res.statusCode == 200 && res.data != null) {
        final List<dynamic>? list = res.data['drivers'];
        if (list != null) {
          final List<ChatDriver> parsed = list.map((item) {
            return ChatDriver.fromJson(Map<String, dynamic>.from(item));
          }).toList();

          driversList.assignAll(parsed);
          filterDrivers(searchDriverController.text);
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching drivers: $e");
    } finally {
      isLoadingDrivers.value = false;
      update();
    }
  }

  void filterDrivers(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredDriversList.assignAll(driversList);
    } else {
      filteredDriversList.assignAll(
        driversList.where((d) {
          final nameMatch = d.name.toLowerCase().contains(q);
          final idMatch = d.id.toString().contains(q);
          final vehMatch = d.vehicleNumber.toLowerCase().contains(q);
          final callMatch = (d.callsign ?? '').toLowerCase().contains(q);
          return nameMatch || idMatch || vehMatch || callMatch;
        }).toList(),
      );
    }
    update();
  }

  // --- Driver Selection ---
  void selectDriver(ChatDriver driver) {
    selectedDriver.value = driver;
    // Clear unread count for this driver
    driver.unreadCount = 0;
    driversList.refresh();
    filteredDriversList.refresh();
    _recalculateTotalUnread();
    update();

    loadChatHistory(driver.id);
  }

  void _recalculateTotalUnread() {
    int count = 0;
    for (var d in driversList) {
      count += d.unreadCount;
    }
    totalUnreadCount.value = count;
    update();
  }

  // --- Load Chat History ---
  Future<void> loadChatHistory(int driverId) async {
    isLoadingHistory.value = true;
    messages.clear();
    isDriverTyping.value = false;
    update();

    try {
      final res = await Api().get(
        "chat/history",
        queryParameters: {
          "company_id": companyId,
          "user_id": currentUserId,
          "role": currentUserRole,
          "target_id": driverId.toString(),
          "target_role": "DRIVER",
          "chat_type": "DRIVER_CHAT",
        },
      );

      if (res != null && res.data != null) {
        final dynamic rawList = res.data['data'];
        if (rawList is List) {
          final List<int> unreadIds = [];
          final List<ChatMessage> loadedMessages = [];

          for (var item in rawList) {
            final msg = ChatMessage.fromJson(Map<String, dynamic>.from(item));
            loadedMessages.add(msg);

            final isSentByMe = msg.isSentByMe(currentUserId, currentUserRole);
            if (!isSentByMe && !msg.isRead) {
              unreadIds.add(msg.id);
            }
          }

          messages.assignAll(loadedMessages);
          _scrollToBottom();

          // Mark unread messages as read
          if (unreadIds.isNotEmpty) {
            sendMarkAsRead(unreadIds, driverId, 'DRIVER');
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error loading chat history: $e");
    } finally {
      isLoadingHistory.value = false;
      update();
    }
  }

  // --- Send Message ---
  void sendMessage() {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    final targetDriver = selectedDriver.value;
    if (targetDriver == null) {
      BotToast.showText(text: "Please select a driver to chat with.");
      return;
    }

    if (!isConnected.value || _channel == null) {
      BotToast.showText(text: "Chat is offline. Reconnecting...");
      connectWs();
      return;
    }

    final payload = {
      "event": "send_message",
      "receiver_id": targetDriver.id,
      "receiver_role": "DRIVER",
      "chat_type": "DRIVER_CHAT",
      "message_type": "text",
      "content": text,
    };

    try {
      _channel!.sink.add(jsonEncode(payload));
      messageInputController.clear();
      update();

      // Stop typing if active
      _typingTimer?.cancel();
      _channel?.sink.add(jsonEncode({
        "event": "typing_stop",
        "target_role": "DRIVER",
        "target_id": targetDriver.id,
      }));
    } catch (e) {
      debugPrint("❌ Error sending message: $e");
      BotToast.showText(text: "Failed to send message: $e");
    }
  }

  // --- Typing Indicator ---
  void onTypingChanged(String val) {
    final targetDriver = selectedDriver.value;
    if (targetDriver == null || !isConnected.value || _channel == null) return;

    try {
      _channel!.sink.add(jsonEncode({
        "event": "typing_start",
        "target_role": "DRIVER",
        "target_id": targetDriver.id,
      }));

      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(milliseconds: 1500), () {
        if (isConnected.value && _channel != null) {
          _channel!.sink.add(jsonEncode({
            "event": "typing_stop",
            "target_role": "DRIVER",
            "target_id": targetDriver.id,
          }));
        }
      });
    } catch (e) {
      debugPrint("❌ Error sending typing event: $e");
    }
  }

  // --- Mark As Read ---
  void sendMarkAsRead(List<dynamic> messageIds, dynamic senderId, String senderRole) {
    if (!isConnected.value || _channel == null || messageIds.isEmpty) return;

    final payload = {
      "event": "mark_as_read",
      "message_ids": messageIds,
      "sender_id": senderId,
      "sender_role": senderRole,
    };

    try {
      debugPrint("📤 Sending mark_as_read: $payload");
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      debugPrint("❌ Error sending mark_as_read: $e");
    }
  }
}
