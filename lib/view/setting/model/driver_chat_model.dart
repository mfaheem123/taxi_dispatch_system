import 'package:intl/intl.dart';

class ChatMessage {
  final int id;
  final int? companyId;
  final int? senderId;
  final String? senderRole;
  final int? receiverId;
  final String? receiverRole;
  final String? chatType;
  final String? messageType;
  final String content;
  String status; // 'PENDING', 'SENT', 'DELIVERED', 'READ'
  bool isRead;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    this.companyId,
    this.senderId,
    this.senderRole,
    this.receiverId,
    this.receiverRole,
    this.chatType,
    this.messageType,
    required this.content,
    this.status = 'SENT',
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Parse ID
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? 0;
    }

    // Parse sender/receiver IDs
    int? sId;
    if (json['sender_id'] is int) {
      sId = json['sender_id'];
    } else if (json['sender_id'] != null) {
      sId = int.tryParse(json['sender_id'].toString());
    }

    int? rId;
    if (json['receiver_id'] is int) {
      rId = json['receiver_id'];
    } else if (json['receiver_id'] != null) {
      rId = int.tryParse(json['receiver_id'].toString());
    }

    int? compId;
    if (json['company_id'] is int) {
      compId = json['company_id'];
    } else if (json['company_id'] != null) {
      compId = int.tryParse(json['company_id'].toString());
    }

    // Parse is_read
    bool read = false;
    final isReadVal = json['is_read'];
    if (isReadVal is bool) {
      read = isReadVal;
    } else if (isReadVal is int) {
      read = isReadVal == 1;
    } else if (isReadVal != null) {
      read = isReadVal.toString().toLowerCase() == 'true' || isReadVal.toString() == '1';
    }

    // Parse status
    String st = json['status']?.toString().toUpperCase() ?? (read ? 'READ' : 'SENT');
    if (read) st = 'READ';

    // Parse created_at
    DateTime dt = DateTime.now();
    if (json['created_at'] != null) {
      final parsed = DateTime.tryParse(json['created_at'].toString());
      if (parsed != null) {
        dt = parsed.toLocal();
      }
    }

    return ChatMessage(
      id: parsedId,
      companyId: compId,
      senderId: sId,
      senderRole: json['sender_role']?.toString(),
      receiverId: rId,
      receiverRole: json['receiver_role']?.toString(),
      chatType: json['chat_type']?.toString(),
      messageType: json['message_type']?.toString(),
      content: json['content']?.toString() ?? '',
      status: st,
      isRead: read,
      createdAt: dt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_id': companyId,
    'sender_id': senderId,
    'sender_role': senderRole,
    'receiver_id': receiverId,
    'receiver_role': receiverRole,
    'chat_type': chatType,
    'message_type': messageType,
    'content': content,
    'status': status,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
  };

  bool isSentByMe(String myUserId, String myRole) {
    if (senderId == null) return false;
    final isMatchingId = senderId.toString() == myUserId.trim();
    final sRole = (senderRole ?? '').trim().toUpperCase();
    final mRole = myRole.trim().toUpperCase();
    return isMatchingId && (sRole == mRole || sRole.isEmpty || mRole.isEmpty);
  }

  String get formattedTime {
    return DateFormat('hh:mm a').format(createdAt);
  }
}

class ChatDriver {
  final int id;
  final String name;
  final String vehicleNumber;
  final String? mobile;
  final String? callsign;
  final bool isActive;
  int unreadCount;

  ChatDriver({
    required this.id,
    required this.name,
    required this.vehicleNumber,
    this.mobile,
    this.callsign,
    this.isActive = true,
    this.unreadCount = 0,
  });

  factory ChatDriver.fromJson(Map<String, dynamic> json) {
    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] != null) {
      parsedId = int.tryParse(json['id'].toString()) ?? 0;
    }

    String veh = 'No Vehicle';
    if (json['vehicle'] != null && json['vehicle'] is Map) {
      veh = json['vehicle']['vehicle_number']?.toString() ?? 'No Vehicle';
    }

    return ChatDriver(
      id: parsedId,
      name: json['name']?.toString() ?? 'Driver #$parsedId',
      vehicleNumber: veh,
      mobile: json['mobile']?.toString(),
      callsign: json['callsign']?.toString() ?? json['username']?.toString(),
      isActive: json['active'] == true || json['active'] == 1,
      unreadCount: 0,
    );
  }
}
