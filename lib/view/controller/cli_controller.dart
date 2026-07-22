
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
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Ensure intl package is imported
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dashboard_new1/component/networks/api.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/web_socket_channel.dart';

import '../dashboard_view/models/dashboard_model.dart';

class CliController extends GetxController {
  WebSocketChannel? channel;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;

  /// 🔹 Customer Data
  RxString customerName = "".obs;
  RxString customerMobile = "".obs;
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

      final uri = Uri.parse(
        "${baseUrl}cli/find-customer",
      );

      final response = await http.post(
        uri,
        body: {
          "phone": phone,
          "company_id": Api.singleton.globalCompanyId,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["success"] == true) {
          customerName.value = jsonData["customer"]?["name"] ?? "";
          customerMobile.value = phone;
          bookings.value = jsonData["bookings"] ?? [];
          print("✅ Customer Loaded");
        } else {
          customerName.value = "No Customer Found";
          customerMobile.value = "";
          bookings.clear();
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

  @override
  void onClose() {
    disconnectSocket();
    super.onClose();
  }
}