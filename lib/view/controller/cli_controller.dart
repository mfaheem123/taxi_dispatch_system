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
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dashboard_new1/component/networks/api.dart';
import '../Model/new_cli_model.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/dashboard_model.dart';
import '../dashboard_view/models/dashboard_table_model.dart';

class CliController extends GetxController {
  CliCustomerModel? cliCustomerModel;
  WebSocketChannel? channel;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;

  var customerData = Rxn<CliCustomerModel>();

  /// 🔹 Customer Data
  RxString customerName = "".obs;
  RxString customerMobile = "".obs;
  RxString customerEmail = "".obs;
  RxString customerTelephone = "".obs;

  // Stats Observables
  RxInt totalStats = 0.obs;
  RxInt currentStats = 0.obs;
  RxInt completedStats = 0.obs;
  RxInt cancelledStats = 0.obs;
  RxInt quotedStats = 0.obs;

  // 🔹 Typed List from Model
  RxList<BookingObjectData> currentBookings = <BookingObjectData>[].obs;
  RxList<BookingObjectData> pastBookings = <BookingObjectData>[].obs;
  RxList<BookingObjectData> quotedBookings = <BookingObjectData>[].obs;
  // var stats = Rxn<Stats>();
  final Rx<Stats> stats = Stats().obs;

  RxList bookings = [].obs;

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
      // Clear the dashboard form first, then close the CLI dialog.
      await _dashboard.refreshPostAllFields();
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

  Future<void>findCustomerApi(String phone) async {
    try {
      isLoading.value = true;

      var response = await Api().get("cli/find-customer?phone=$phone", sendCompanyId: true);

      // final uri = Uri.parse(
      //   "${baseUrl}cli/find-customer",
      // );
      //
      // final response = await http.post(
      //   uri,
      //   body: {
      //     "phone": phone,
      //     "company_id": Api.singleton.globalCompanyId,
      //   },
      // );

      if (response.statusCode == 200) {
        cliCustomerModel = CliCustomerModel.fromJson(response.data);


        if (cliCustomerModel?.customer != null) {
          customerName.value = cliCustomerModel?.customer?.name ?? "";
          customerMobile.value = cliCustomerModel?.customer?.mobile ?? "";
        }

        // Stats Assigning
        if (cliCustomerModel?.stats != null) {
          totalStats.value = cliCustomerModel?.stats?.total ?? 0;
          currentStats.value = cliCustomerModel?.stats?.current ?? 0;
          completedStats.value = cliCustomerModel?.stats?.completed ?? 0;
          cancelledStats.value = cliCustomerModel?.stats?.cancelled ?? 0;
          quotedStats.value = cliCustomerModel?.stats?.quoted ?? 0;
        }

        if (cliCustomerModel?.bookings != null) {
          currentBookings.assignAll(cliCustomerModel!.bookings!.current ?? []);
          pastBookings.assignAll(cliCustomerModel!.bookings!.past ?? []);
          quotedBookings.assignAll(cliCustomerModel!.bookings!.quoted ?? []);

        }
        // if (jsonData["success"] == true) {
        //   customerName.value = jsonData["customer"]?["name"] ?? "";
        //   customerMobile.value = phone;
        //   bookings.value = jsonData["bookings"] ?? [];
        //   print("✅ Customer Loaded");
        // } else {
        //   customerName.value = "No Customer Found";
        //   customerMobile.value = "";
        //   bookings.clear();
        // }
        print("✅ Customer Header & Stats Loaded Successfully");
      } else {
        print("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API ERROR: $e");
      _clearHeaderData();
    } finally {
      isLoading.value = false;
    }
  }

  void _clearHeaderData() {
    customerName.value = "No Customer Found";
    customerMobile.value = "";
    totalStats.value = 0;
    currentStats.value = 0;
    completedStats.value = 0;
    cancelledStats.value = 0;
    quotedStats.value = 0;
    currentBookings.clear();
    pastBookings.clear();
    quotedBookings.clear();
  }

  // ================= CLI SCREEN (cli_new_designing.dart) =================
  DashboardController get _dashboard => Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  String extensionNumber = '';

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropoffController = TextEditingController();

  bool isSwapped = false;
  bool _newBookingBusy = false;
  int? selectedDriverId;
  int? selectedVehicleId;
  int selectedTab = 0;

  bool get canSubmit => selectedBooking != null && !isSwapped;

  /// Passenger details carried over from a right-clicked booking.
  String? passengerName;
  String? passengerEmail;
  String? passengerMobile;
  String? passengerTelephone;

  BookingObjectData? selectedBooking;
  String? selectedBookingId;

  LatLng? pickupPoints;
  LatLng? dropoffPoints;

  LatLng? _parseLatLng(dynamic lat, dynamic lng) {
    final la = double.tryParse('${lat ?? ''}');
    final lo = double.tryParse('${lng ?? ''}');
    return la != null && lo != null ? LatLng(la, lo) : null;
  }


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

  String bookingStatusText(BookingObjectData b) =>
      (b.bookingStatus?.bookingStatus ?? '').toUpperCase();

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

    // Dialog only: the dashboard form behind it is left untouched until
    // NEW BOOKING hands the call over.
    update();
  }

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

  /// SUBMIT: re-dispatch the ticked booking now with the chosen driver and vehicle.
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
        ? Stats.fromJson(Map<String, dynamic>.from(rawStats))
        : Stats(
      total: bookings.length,
      current: currentBookings.length,
      quoted: quotedBookings.length,
    );
  }

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

  /// Wipes whatever was already on the dashboard form so the booking NEW
  /// BOOKING hands over is not mixed with the previous one's leftovers.
  /// The driver / vehicle picked in this dialog are kept: the reset would
  /// otherwise put them back to their defaults.
  Future<void> _clearDashboardForm() async {
    final driver = _dashboard.selectDriverValue;
    final vehicle = _dashboard.selectVehicleValue;
    await _dashboard.refreshPostAllFields();
    _dashboard.selectDriverValue = driver;
    if (vehicle != null) _dashboard.selectVehicleValue = vehicle;
    _dashboard.update();
  }

  Future<void> newBooking() async {
    if (_newBookingBusy) return;
    try {
      _newBookingBusy = true;
      BotToast.showLoading();

      if (pickupController.text.isNotEmpty &&
          dropoffController.text.isNotEmpty &&
          selectedBooking == null) {
        if (pickupController.text == dropoffController.text) {
          BotToast.showText(text: 'PLEASE WRITE DIFFERENT ADDRESS');
          return;
        }
        if (pickupPoints == null || dropoffPoints == null) {
          BotToast.showText(text: 'LOCATION DATA MISSING');
          return;
        }
        await _clearDashboardForm();
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
        // cliDataBinding closes the dialog itself.
      } else {
        await _clearDashboardForm();
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
    } catch (e, stackTrace) {
      print("EXCEPTION IN newBooking(): $e");
      print("FULL STACK TRACE:\n$stackTrace");
      BotToast.showText(text: 'SOMETHING WENT WRONG');
      debugPrint('$e');
    } finally {
      BotToast.closeAllLoading();
      _newBookingBusy = false;
    }
  }

  @override
  void onClose() {
    disconnectSocket();
    super.onClose();
  }
}