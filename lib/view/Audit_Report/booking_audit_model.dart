import 'dart:convert';
import 'package:intl/intl.dart';

class BookingAuditModel {
  final bool? status;
  final int? count;
  final List<AuditActivity> activities;
  final List<AuditUpdate> updates;

  BookingAuditModel({
    this.status,
    this.count,
    required this.activities,
    required this.updates,
  });

  factory BookingAuditModel.fromJson(Map<String, dynamic> json) {
    List<AuditActivity> activitiesList = [];
    List<AuditUpdate> updatesList = [];

    final rawAudits = json['audits'] ?? json['data'];
    if (rawAudits is List) {
      for (var item in rawAudits) {
        if (item is Map<String, dynamic>) {
          final operation = item['operation']?.toString().toLowerCase();
          if (operation == 'activity') {
            activitiesList.add(AuditActivity.fromJson(item));
          } else if (operation == 'update') {
            updatesList.add(AuditUpdate.fromJson(item));
          } else {
            // Default check
            if (item['operation'] != null) {
              activitiesList.add(AuditActivity.fromJson(item));
            }
          }
        }
      }
    }

    return BookingAuditModel(
      status: json['status'] == true,
      count: json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? ''),
      activities: activitiesList,
      updates: updatesList,
    );
  }
}

class AuditActivity {
  final int? id;
  final String? employee;
  final String? driver;
  final String? activityDescription;
  final String? date;
  final String? time;

  AuditActivity({
    this.id,
    this.employee,
    this.driver,
    this.activityDescription,
    this.date,
    this.time,
  });

  factory AuditActivity.fromJson(Map<String, dynamic> json) {
    // 1. Employee username
    String? empName = '-';
    if (json['employee'] is Map) {
      empName = json['employee']['username']?.toString() ?? json['employee']['name']?.toString() ?? '-';
    } else if (json['employee'] != null) {
      empName = json['employee'].toString();
    }

    // 2. Driver username and name
    String? drvDisplay = '-';
    if (json['driver'] is Map) {
      final uName = json['driver']['username']?.toString() ?? json['driver']['id']?.toString() ?? '';
      final name = json['driver']['name']?.toString() ?? '';
      if (uName.isNotEmpty && name.isNotEmpty) {
        drvDisplay = '($uName) $name';
      } else if (name.isNotEmpty) {
        drvDisplay = name;
      } else if (uName.isNotEmpty) {
        drvDisplay = '($uName)';
      }
    } else if (json['driver'] != null) {
      drvDisplay = json['driver'].toString();
    }

    // 3. Activity description from next
    String desc = '-';
    final rawNext = json['next'];
    if (rawNext != null) {
      desc = _cleanStringOrJsonList(rawNext.toString());
    }

    // 4. Date formatting (e.g. 2026-11-12T23:00:00.000Z -> 12-11-26)
    String dateStr = '-';
    final rawDate = json['date']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      try {
        final parsed = DateTime.parse(rawDate);
        dateStr = DateFormat('dd-MM-yy').format(parsed);
      } catch (_) {
        dateStr = rawDate.split('T')[0];
      }
    }

    // 5. Time
    final timeStr = json['time']?.toString() ?? '-';

    return AuditActivity(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      employee: empName,
      driver: drvDisplay,
      activityDescription: desc,
      date: dateStr,
      time: timeStr,
    );
  }
}

class AuditUpdate {
  final int? id;
  final String? employee;
  final String previousState;
  final String newState;
  final String? date;
  final String? time;

  AuditUpdate({
    this.id,
    this.employee,
    required this.previousState,
    required this.newState,
    this.date,
    this.time,
  });

  factory AuditUpdate.fromJson(Map<String, dynamic> json) {
    // 1. Employee
    String? empName = '-';
    if (json['employee'] is Map) {

      empName = json['employee']['username']?.toString() ?? json['employee']['name']?.toString() ?? '-';

    } else if (json['employee'] != null) {
      empName = json['employee'].toString();
    }

    // 2. Parse previous and next state
    final prev = _formatStateList(json['previous']);
    final next = _formatStateList(json['next']);

    // 3. Date
    String dateStr = '-';
    final rawDate = json['date']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      try {
        final parsed = DateTime.parse(rawDate);
        dateStr = DateFormat('dd-MM-yy').format(parsed);
      } catch (_) {
        dateStr = rawDate.split('T')[0];
      }
    }

    // 4. Time
    final timeStr = json['time']?.toString() ?? '-';

    return AuditUpdate(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      employee: empName,
      previousState: prev.isEmpty ? '-' : prev,
      newState: next.isEmpty ? '-' : next,
      date: dateStr,
      time: timeStr,
    );
  }
}

// ─── Helpers to clean & format state arrays ──────────────────────────────────

String _cleanStringOrJsonList(String raw) {
  raw = raw.trim();
  if (raw.startsWith('[') && raw.endsWith(']')) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).join('\n');
      }
    } catch (_) {
      // Clean string brackets
      String cleaned = raw.substring(1, raw.length - 1);
      cleaned = cleaned.replaceAll('"', '').replaceAll('\\', '');
      return cleaned;
    }
  }
  return raw;
}

String _formatStateList(dynamic raw) {
  if (raw == null) return '-';
  List<dynamic> items = [];

  if (raw is List) {
    items = raw;
  } else if (raw is String) {
    final str = raw.trim();
    if (str.isEmpty || str == '[]' || str == 'null') return '-';
    try {
      final decoded = jsonDecode(str);
      if (decoded is List) {
        items = decoded;
      } else if (decoded is Map) {
        return _formatMap(decoded);
      } else {
        return decoded.toString();
      }
    } catch (_) {
      return str;
    }
  }

  if (items.isEmpty) return '-';

  List<String> formattedLines = [];
  for (var item in items) {
    final s = item.toString().trim();
    if (s.isEmpty) continue;

    // Check for "key: value"
    final colonIdx = s.indexOf(':');
    if (colonIdx > 0) {
      final key = s.substring(0, colonIdx).trim().replaceAll('_', ' ').toUpperCase();
      final valPart = s.substring(colonIdx + 1).trim();

      // Check if value is a JSON array/object
      if ((valPart.startsWith('[') && valPart.endsWith(']')) ||
          (valPart.startsWith('{') && valPart.endsWith('}'))) {
        try {
          final decodedVal = jsonDecode(valPart);
          if (decodedVal is List) {
            if (decodedVal.isEmpty) {
              formattedLines.add('$key: -');
            } else {
              formattedLines.add('$key:');
              for (var sub in decodedVal) {
                if (sub is Map) {
                  // e.g. viapoint or note or restricted_driver
                  final name = sub['name'] ?? sub['viapoint'] ?? sub['note'] ?? sub['username'] ?? sub.toString();
                  formattedLines.add('  - $name');
                } else {
                  formattedLines.add('  - $sub');
                }
              }
            }
            continue;
          }
        } catch (_) {}
      }

      formattedLines.add('$key: $valPart');
    } else {
      formattedLines.add(s);
    }
  }

  return formattedLines.join('\n');
}

String _formatMap(Map map) {
  return map.entries.map((e) {
    final k = e.key.toString().replaceAll('_', ' ').toUpperCase();
    return '$k: ${e.value}';
  }).join('\n');
}

// ─── Booking Detail Model (from bookings/getbyid) ─────────────────────────────

class BookingDetailModel {
  final int? id;
  final String? referenceNumber;
  final String? name;
  final String? mobile;
  final String? pickup;
  final String? dropoff;
  final String? fares;
  final String? bookingStatus;
  final String? bookingSource;
  final String? pickupDate;
  final String? pickupTime;
  final int? driverId;
  final String? driverName;
  final String? subsidiaryName;
  final String? phcD;
  final String? phcV;
  final String? vrm;

  BookingDetailModel({
    this.id,
    this.referenceNumber,
    this.name,
    this.mobile,
    this.pickup,
    this.dropoff,
    this.fares,
    this.bookingStatus,
    this.bookingSource,
    this.pickupDate,
    this.pickupTime,
    this.driverId,
    this.driverName,
    this.subsidiaryName,
    this.phcD,
    this.phcV,
    this.vrm,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json;

    // In bookings/getbyid, structure is: { "success": true, "booking": [ { ... } ] }
    if (json['booking'] is List && (json['booking'] as List).isNotEmpty) {
      data = json['booking'][0];
    } else if (json['booking'] is Map<String, dynamic>) {
      data = json['booking'];
    } else if (json['data'] is Map<String, dynamic>) {
      data = json['data'];
    }

    // Driver id
    int? dId;
    String? dName;
    if (data['driver_id'] != null) {
      dId = int.tryParse(data['driver_id'].toString());
    } else if (data['driverId'] != null) {
      dId = int.tryParse(data['driverId'].toString());
    }

    if (data['driver'] is Map) {
      dId ??= int.tryParse(data['driver']['id']?.toString() ?? '');
      dName = data['driver']['name']?.toString();
    }

    // Subsidiary name
    String? subName = 'DEMO COMPANY';
    if (data['subsidiary'] is Map) {
      subName = data['subsidiary']['name']?.toString() ?? 'DEMO COMPANY';
    } else if (data['subsidiary_name'] != null) {
      subName = data['subsidiary_name'].toString();
    }

    // Booking status
    String status = '-';
    if (data['booking_status'] is Map) {
      status = data['booking_status']['booking_status']?.toString() ?? '-';
    } else if (data['bookingStatus'] is Map) {
      status = data['bookingStatus']['bookingStatus']?.toString() ?? '-';
    } else if (data['booking_status'] != null) {
      status = data['booking_status'].toString();
    } else if (data['bookingStatus'] != null) {
      status = data['bookingStatus'].toString();
    }

    // Format pickup date to dd-MM-yy
    String formattedDate = '-';
    final rawDate = data['pickup_date']?.toString() ?? data['pickupDate']?.toString();
    if (rawDate != null && rawDate.isNotEmpty) {
      try {
        final parsed = DateTime.parse(rawDate);
        formattedDate = DateFormat('dd-MM-yy').format(parsed);
      } catch (_) {
        formattedDate = rawDate;
      }
    }

    // Fares
    String fareStr = '0.00';
    if (data['fares'] != null) {
      fareStr = double.tryParse(data['fares'].toString())?.toStringAsFixed(2) ?? data['fares'].toString();
    }

    return BookingDetailModel(
      id: int.tryParse(data['id']?.toString() ?? ''),
      referenceNumber: data['reference_number']?.toString() ?? data['referenceNumber']?.toString() ?? '-',
      name: data['name']?.toString() ?? '-',
      mobile: data['mobile']?.toString() ?? data['telephone']?.toString() ?? '-',
      pickup: data['pickup']?.toString() ?? '-',
      dropoff: data['dropoff']?.toString() ?? '-',
      fares: fareStr,
      bookingStatus: status,
      bookingSource: data['booking_source']?.toString() ?? data['bookingSource']?.toString() ?? 'OPERATOR',
      pickupDate: formattedDate,
      pickupTime: data['pickup_time']?.toString() ?? data['pickupTime']?.toString() ?? '',
      driverId: dId,
      driverName: dName,
      subsidiaryName: subName,
      phcD: data['driver'] is Map ? data['driver']['phc_driver_number']?.toString() : null,
      phcV: data['driver'] is Map ? data['driver']['phc_vehicle_number']?.toString() : null,
      vrm: data['driver'] is Map && data['driver']['vehicle'] is Map
          ? data['driver']['vehicle']['vehicle_number']?.toString()
          : null,
    );
  }
}

// ─── Driver Detail Model (from drivers/getbyid) ───────────────────────────────

class DriverDetailModel {
  final int? id;
  final String? username;
  final String? name;
  final String? mobile;
  final String? email;
  final String? phcDriverNumber;
  final String? phcVehicleNumber;
  final String? vehicleNumber;

  DriverDetailModel({
    this.id,
    this.username,
    this.name,
    this.mobile,
    this.email,
    this.phcDriverNumber,
    this.phcVehicleNumber,
    this.vehicleNumber,
  });

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json;
    if (json['driver'] is Map<String, dynamic>) {
      data = json['driver'];
    }

    // Vehicle number
    String? vNumber;
    if (data['vehicle'] is Map) {
      vNumber = data['vehicle']['vehicle_number']?.toString() ?? data['vehicle']['vehicleNumber']?.toString();
    }

    return DriverDetailModel(
      id: int.tryParse(data['id']?.toString() ?? ''),
      username: data['username']?.toString(),
      name: data['name']?.toString(),
      mobile: data['mobile']?.toString() ?? data['telephone']?.toString(),
      email: data['email']?.toString(),
      phcDriverNumber: data['phc_driver_number']?.toString() ?? data['phcDriverNumber']?.toString(),
      phcVehicleNumber: data['phc_vehicle_number']?.toString() ?? data['phcVehicleNumber']?.toString(),
      vehicleNumber: vNumber,
    );
  }
}
