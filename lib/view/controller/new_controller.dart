// class CliController extends GetxController {
//
//   WebSocketChannel? channel;
//   RxBool isConnected = false.obs;
//   RxBool isLoading = false.obs;
//
//   /// 🔹 Customer Data
//   RxString customerName = "".obs;
//   RxString customerMobile = "".obs;
//   RxList bookings = [].obs;
//
//
//
//
//   RxBool CLIJOBLoader = false.obs;
//   postCLIJob(bid,date,time,did,vid) async {
//     CLIJOBLoader(false);
//     var formData = {
//       'booking_id': bid,
//       'vehicle_type_id':vid,
//       'pickup_date': date,
//       'pickup_time': time,
//       'driver_id': did,
//
//     };
//
//     var response = await Api().post(formData, 'bookings/cli', auth: true);
//     if (response.statusCode == 200) {
//       Get.back();
//       // CLIJOBLoader(true);
//       // update();
//     }
//   }
//
//
//   // ================= SOCKET METHODS ========================
//
//   DashboardDriverObject? selectDriverValue;
//   DashboardDataModel? dashboardAllData;
//   DashboardVehicleTypeObject? selectVehicleValue;
//
//   void connectSocket(String extension) {
//
//     if (channel != null && isConnected.value) return;
//
//     channel = WebSocketChannel.connect(
//
//       // Uri.parse('ws://192.168.110.5:5000/websocket/cli?extension=$extension',),
//       // Uri.parse('wss://www.nexustechnologys.com//websocket/cli?extension=$extension',),
//       Uri.parse('ws://158.220.92.206:5000/websocket/cli?extension=$extension&company_id=3',),
//
//     );
//
//     channel!.stream.listen(
//           (data) {
//         print("📩 Socket Data: $data");
//
//         if (!isConnected.value) {
//           isConnected.value = true;
//           Get.offAllNamed('/socketScreen');
//         }
//       },
//       onError: (error) {
//         print("❌ Socket Error: $error");
//         isConnected.value = false;
//         channel = null;
//       },
//       onDone: () {
//         print("🔌 Socket Disconnected");
//         isConnected.value = false;
//         channel = null;
//       },
//     );
//   }
//
//   void disconnectSocket() {
//     channel?.sink.close();
//     channel = null;
//     isConnected.value = false;
//   }
//
//
//   // ================= API METHOD ONLY =======================
//
//
//
//   Future<void> findCustomerApi(String phone) async {
//     try {
//       isLoading.value = true;
//
//       final uri = Uri.parse(
//         "${baseUrl}cli/find-customer",
//       );
//
//       final response = await http.post(
//         uri,
//         body: {
//           "phone": phone,
//           "company_id": "3",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData["success"] == true) {
//
//           customerName.value = jsonData["customer"]?["name"] ?? "";
//
//           customerMobile.value = phone?? "";
//
//           bookings.value = jsonData["bookings"] ?? [];
//
//           print("✅ Customer Loaded");
//         } else {
//           customerName.value = "No Customer Found";
//           customerMobile.value = "";
//           bookings.clear();
//         }
//       } else {
//         print("❌ Server Error: ${response.statusCode}");
//       }
//
//     } catch (e) {
//       print("❌ API ERROR: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     disconnectSocket();
//     super.onClose();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Ensure intl package is imported
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dashboard_new1/component/networks/api.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/web_socket_channel.dart';

import '../Model/cli_Customer_DetailModel.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/models/dashboard_table_model.dart';

class CliController extends GetxController {
  CliCustomerModel? cliCustomerModel;
  WebSocketChannel? channel;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;

  /// 🔹 Customer Data
  RxString customerName = "".obs;
  RxString customerMobile = "".obs;
  RxString customerEmail = "".obs;
  RxString customerTelephone = "".obs;

  /// Raw booking maps, all tabs together (deduplicated by id). Kept for the
  /// old cli_Screen.dart, which reads this list directly.
  RxList bookings = [].obs;

  /// find-customer splits the caller's bookings server-side:
  /// `bookings: {current: [...], past: [...], quoted: [...]}`.
  final RxList<BookingObjectData> currentBookings = <BookingObjectData>[].obs;
  final RxList<BookingObjectData> pastBookings = <BookingObjectData>[].obs;
  final RxList<BookingObjectData> quotedBookings = <BookingObjectData>[].obs;

  /// The response's `stats` block (the footer cards).
  final Rx<CliBookingStats> stats = const CliBookingStats().obs;

  RxBool CLIJOBLoader = false.obs;




  /// 🔹 POST CLI JOB WITH CURRENT DATE & TIME
  postCLIJob(bid, dynamic date, dynamic time, did, vid) async {
    CLIJOBLoader(false);
    // Current Date and Time
    DateTime now = DateTime.now();
    // Force strictly current system date & time
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    var formData = {
      'booking_id': bid,
      'vehicle_type_id': vid,
      'pickup_date': formattedDate,
      'pickup_time': formattedTime,
      'driver_id': did,
      'company_id': Api.singleton.globalCompanyId,
    };
    print("--- POSTING CLI JOB DATA ---");
    print(formData);

    var response = await Api().post(formData, 'bookings/cli', auth: true, sendCompanyId: true);
    if (response != null && response.statusCode == 200) {
      Get.back();
    }
  }

  // ================= SOCKET METHODS ========================

  DashboardDriverObject? selectDriverValue;
  DashboardDataModel? dashboardAllData;
  DashboardVehicleTypeObject? selectVehicleValue;

  void connectSocket(String extension) {
    if (channel != null && isConnected.value) return;

    final String companyId = Api.singleton.globalCompanyId;
    channel = WebSocketChannel.connect(
      Uri.parse('${socketUrl}/cli?extension=$extension&company_id=$companyId'),
    );

    channel!.stream.listen(
          (data) {
        print("📩 Socket Data: $data");
        if (!isConnected.value) {
          isConnected.value = true;
          Get.offAllNamed('/socketScreen');
        }
      },
      onError: (error) {
        print("❌ Socket Error: $error");
        isConnected.value = false;
        channel = null;
      },
      onDone: () {
        print("🔌 Socket Disconnected");
        isConnected.value = false;
        channel = null;
      },
    );
  }

  void disconnectSocket() {
    channel?.sink.close();
    channel = null;
    isConnected.value = false;
  }

  // ================= API METHOD ONLY =======================

  Future<void> findCustomerApi(String phone) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> queryParams = {
        "phone": phone,
      };
      dynamic response = await Api().get(
        "cli/find-customer",
        queryParameters: queryParams,
        sendCompanyId: true,
      );

      final uri = Uri.parse(
        "${baseUrl}cli/find-customer",
      );

      // final response = await http.post(
      //   uri,
      //   body: {
      //     "phone": phone,
      //     "company_id": Api.singleton.globalCompanyId,
      //   },
      // );

      if (response.statusCode == 200) {
        // final jsonData = jsonDecode(response.data);

        if (response.data["success"] == true) {
          // final customer = jsonData["customer"];
          // customerName.value = customer?["name"] ?? "";
          // customerMobile.value = phone;
          // customerEmail.value = customer?["email"] ?? "";
          // customerTelephone.value = customer?["telephone"] ?? "";
          _bindBookings(response.data["bookings"], response.data["stats"]);
          print("✅ Customer Loaded");
        } else {
          customerName.value = "No Customer Found";
          customerMobile.value = "";
          customerEmail.value = "";
          customerTelephone.value = "";
          _bindBookings(null, null);
        }
      } else {
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================= CLI SCREEN (cli_new_designing.dart) =================
  //
  // Booking state and actions for the new CLI screen. This controller is
  // registered permanent, so [startCall] resets all of it for every call.
  // Plain fields + update(): the screen listens with GetBuilder<CliController>
  // (and Obx for the Rx fields above).

  DashboardController get _dashboard => Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  /// The caller's phone number for the current call.
  String extensionNumber = '';

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  /// Coordinates of whatever is in the pickup / dropoff fields. Only set when
  /// the address came from a booking (checkbox or right-click), which is what
  /// a new booking from this screen needs.
  LatLng? pickupPoints;
  LatLng? dropoffPoints;

  /// Passenger details carried over from a right-clicked booking.
  String? passengerName;
  String? passengerEmail;
  String? passengerMobile;
  String? passengerTelephone;

  /// The ticked booking (one at a time). Swapping mutates this copy so the
  /// swapped addresses travel with it into the booking form.
  BookingObjectData? selectedBooking;
  String? selectedBookingId;

  int? selectedDriverId;
  int? selectedVehicleId;

  /// Once pickup and dropoff are swapped the booking no longer matches the
  /// server's copy, so SUBMIT (which re-dispatches it as-is) is disabled and
  /// the swapped job has to go through NEW BOOKING.
  bool isSwapped = false;
  bool _newBookingBusy = false;

  /// 0 current, 1 past, 2 quoted.
  int selectedTab = 0;

  bool get canSubmit => selectedBooking != null && !isSwapped;

  /// Resets the screen state for a new call and loads the caller's data.
  void startCall(String extension) {
    extensionNumber = extension;
    pickupController.clear();
    dropoffController.clear();
    pickupPoints = null;
    dropoffPoints = null;
    passengerName = null;
    passengerEmail = null;
    passengerMobile = null;
    passengerTelephone = null;
    selectedBooking = null;
    selectedBookingId = null;
    selectedDriverId = null;
    selectedVehicleId = null;
    isSwapped = false;
    selectedTab = 0;
    _bindBookings(null, null);

    findCustomerApi(extension);
    _dashboard.cliJobHit = false;
    if (_dashboard.dashboardAllData == null) {
      _dashboard.dashboardData().then((_) {
        _setDefaultVehicle();
        update();
      });
    } else {
      _setDefaultVehicle();
    }
    update();
  }

  void _setDefaultVehicle() {
    final types = _dashboard.dashboardAllData?.vehicleTypes;
    if (types != null && types.isNotEmpty) {
      _dashboard.selectVehicleValue ??= types.first;
      selectedVehicleId = _dashboard.selectVehicleValue?.id;
    }
  }

  void selectTab(int tab) {
    selectedTab = tab;
    update();
  }

  void selectDriver(DashboardDriverObject? driver) {
    _dashboard.selectDriverValue = driver;
    selectedDriverId = driver?.id;
    _dashboard.update();
    update();
  }

  void selectVehicle(DashboardVehicleTypeObject? vehicle) {
    _dashboard.selectVehicleValue = vehicle;
    selectedVehicleId = vehicle?.id;
    _dashboard.update();
    update();
  }

  // ---------- booking data ----------

  /// Fills the three tab lists, [stats] and the legacy [bookings] list from
  /// the find-customer response. Also accepts the older response shape,
  /// where `bookings` was one flat list (it all lands in "current").
  void _bindBookings(dynamic rawBookings, dynamic rawStats) {
    List<dynamic> rawList(dynamic v) => v is List ? v : const [];

    final List<dynamic> current, past, quoted;
    if (rawBookings is Map) {
      current = rawList(rawBookings['current']);
      past = rawList(rawBookings['past']);
      quoted = rawList(rawBookings['quoted']);
    } else {
      current = rawList(rawBookings);
      past = const [];
      quoted = const [];
    }

    currentBookings.assignAll(_parseBookings(current));
    pastBookings.assignAll(_parseBookings(past));
    quotedBookings.assignAll(_parseBookings(quoted));

    // A quoted booking can also appear under past — list it once here.
    final seen = <dynamic>{};
    bookings.assignAll([...current, ...past, ...quoted]
        .where((e) => e is Map && seen.add(e['id'])));

    stats.value = rawStats is Map
        ? CliBookingStats.fromJson(Map<String, dynamic>.from(rawStats))
        : CliBookingStats(
      total: bookings.length,
      current: currentBookings.length,
      quoted: quotedBookings.length,
    );
  }

  /// Parses each booking on its own so one malformed row does not empty the
  /// whole tab.
  List<BookingObjectData> _parseBookings(List<dynamic> raw) {
    final out = <BookingObjectData>[];
    for (final e in raw) {
      if (e is! Map) continue;
      try {
        out.add(BookingObjectData.fromJson(Map<String, dynamic>.from(e)));
      } catch (err) {
        debugPrint('CLI booking parse error (${e['id']}): $err');
      }
    }
    return out;
  }

  String bookingStatusText(BookingObjectData b) =>
      (b.bookingStatus?.bookingStatus ?? '').toUpperCase();

  /// Bookings for tab [tab]: 0 current, 1 past, 2 quoted.
  List<BookingObjectData> bookingsForTab(int tab) {
    switch (tab) {
      case 0:
        return currentBookings;
      case 1:
        return pastBookings;
      default:
        return quotedBookings;
    }
  }

  LatLng? _parseLatLng(dynamic lat, dynamic lng) {
    final la = double.tryParse('${lat ?? ''}');
    final lo = double.tryParse('${lng ?? ''}');
    return la != null && lo != null ? LatLng(la, lo) : null;
  }

  // ---------- actions ----------

  void swapLocations() {
    isSwapped = !isSwapped;
    final tempText = pickupController.text;
    pickupController.text = dropoffController.text;
    dropoffController.text = tempText;

    final tempPoints = pickupPoints;
    pickupPoints = dropoffPoints;
    dropoffPoints = tempPoints;

    final b = selectedBooking;
    if (b != null) {
      final p = b.pickup, pLat = b.pickupLatitude, pLng = b.pickupLongitude;
      b.pickup = b.dropoff;
      b.pickupLatitude = b.dropoffLatitude;
      b.pickupLongitude = b.dropoffLongitude;
      b.dropoff = p;
      b.dropoffLatitude = pLat;
      b.dropoffLongitude = pLng;
    }

    // Keep the main dashboard form in step, then re-route.
    _dashboard.pickupController.text = pickupController.text;
    _dashboard.dropOffController.text = dropoffController.text;
    update();
    _dashboard.fetchRouteFromOSRM();
  }

  /// Ticks / unticks [b] (single selection) and loads its addresses.
  void toggleBooking(BookingObjectData b) {
    if (selectedBookingId == b.id) {
      selectedBookingId = null;
      selectedBooking = null;
      pickupController.clear();
      dropoffController.clear();
    } else {
      selectedBookingId = b.id;
      selectedBooking = b;
      pickupController.text = b.pickup ?? '';
      dropoffController.text = b.dropoff ?? '';
    }
    update();
  }

  /// Right-click "Set as Pickup / Dropoff": copies the address of the
  /// clicked cell (the booking's dropoff when [fromDropoff], else its pickup)
  /// into this call's pickup ([asPickup]) or dropoff field.
  void setAddressFromBooking(BookingObjectData b,
      {required bool fromDropoff, required bool asPickup}) {
    final text = (fromDropoff ? b.dropoff : b.pickup) ?? '';
    final points = fromDropoff
        ? _parseLatLng(b.dropoffLatitude, b.dropoffLongitude)
        : _parseLatLng(b.pickupLatitude, b.pickupLongitude);
    if (asPickup) {
      pickupController.text = text;
      pickupPoints = points;
    } else {
      dropoffController.text = text;
      dropoffPoints = points;
    }
    passengerName = b.name;
    passengerEmail = b.email;
    passengerMobile = b.mobile?.toString();
    passengerTelephone = b.telephone;
    update();
  }

  /// SUBMIT: re-dispatch the ticked booking now with the chosen driver and
  /// vehicle.
  void submitSelectedBooking() {
    if (selectedBooking == null) {
      Get.snackbar('Error', 'Select booking first');
      return;
    }
    final types = _dashboard.dashboardAllData?.vehicleTypes;
    if (selectedVehicleId == null && types != null && types.isNotEmpty) {
      selectedVehicleId = types.first.id;
    }
    if (selectedDriverId == null || selectedVehicleId == null) {
      Get.snackbar('Error', 'Select driver & vehicle');
      return;
    }
    final now = DateTime.now();
    postCLIJob(
      selectedBooking!.id,
      DateFormat('yyyy-MM-dd').format(now),
      DateFormat('HH:mm').format(now),
      selectedDriverId,
      selectedVehicleId,
    );
  }

  /// NEW BOOKING: hands the call over to the main booking form — either the
  /// typed / right-clicked addresses as a fresh job, the ticked booking
  /// (possibly swapped), or just the caller's number.
  Future<void> newBooking() async {
    if (_newBookingBusy) return;
    try {
      _newBookingBusy = true;
      if (pickupController.text.isNotEmpty &&
          dropoffController.text.isNotEmpty &&
          selectedBooking == null) {
        if (pickupController.text == dropoffController.text) {
          BotToast.showText(text: 'Please write different address');
          return;
        }
        if (pickupPoints == null || dropoffPoints == null) {
          BotToast.showText(text: 'Location data missing');
          return;
        }
        await _dashboard.cliDataBinding(
          pickup: pickupController.text,
          dropoff: dropoffController.text,
          pickupLatitude: pickupPoints!.latitude.toString(),
          pickupLongitude: pickupPoints!.longitude.toString(),
          dropoffLatitude: dropoffPoints!.latitude.toString(),
          dropoffLongitude: dropoffPoints!.longitude.toString(),
          name: passengerName,
          mobile: passengerMobile,
          email: passengerEmail,
          phoneNumber: passengerTelephone,
        );
      } else {
        if (selectedBooking == null) {
          _dashboard.mobileController.text = extensionNumber;
          Get.back();
          return;
        }
        _dashboard.cliJobHit = true;
        await _dashboard.dashBoardDataBinding(
          id: selectedBooking!.id,
          jobData: selectedBooking,
          cliHit: true,
          swappedPickup: pickupController.text,
          swappedDropoff: dropoffController.text,
        );
        Get.back();
      }
    } catch (e) {
      BotToast.showText(text: 'Something went wrong');
      debugPrint('$e');
    } finally {
      _newBookingBusy = false;
    }
  }

  @override
  void onClose() {
    disconnectSocket();
    pickupController.dispose();
    dropoffController.dispose();
    super.onClose();
  }
}

/// The `stats` block of the cli/find-customer response.
class CliBookingStats {
  const CliBookingStats({
    this.total = 0,
    this.current = 0,
    this.completed = 0,
    this.cancelled = 0,
    this.quoted = 0,
  });

  final int total;
  final int current;
  final int completed;
  final int cancelled;
  final int quoted;

  static int _int(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

  factory CliBookingStats.fromJson(Map<String, dynamic> json) =>
      CliBookingStats(
        total: _int(json['total']),
        current: _int(json['current']),
        completed: _int(json['completed']),
        cancelled: _int(json['cancelled']),
        quoted: _int(json['quoted']),
      );
}