import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';

import '../../component/networks/api.dart';
import 'booking_audit_model.dart';

class BookingAuditController extends GetxController {
  final int bookingId;

  BookingAuditController({required this.bookingId});

  // State
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  // Data
  BookingAuditModel? auditData;
  BookingDetailModel? bookingDetail;
  DriverDetailModel? driverDetail;

  // Status timeline map (status name -> timestamp)
  final Map<String, String?> statusTimeline = {
    'ON ROUTE': null,
    'ARRIVED': null,
    'POB': null,
    'COMPLETED': null,
  };

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading(true);
    errorMessage('');

    try {
      // 1. Fetch Audit Data (audits/booking?booking_id=...)
      await _fetchAuditData();

      // 2. Fetch Booking Data (bookings/getbyid/...)
      await _fetchBookingData();

      // 3. If driver is assigned, fetch Driver Data (drivers/getbyid/...)
      final assignedDriverId = bookingDetail?.driverId;
      if (assignedDriverId != null && assignedDriverId > 0) {
        await _fetchDriverData(assignedDriverId);
      } else {
        driverDetail = null;
      }

      // 4. Populate status timeline from activities
      _buildTimelineFromActivities();
    } catch (e) {
      errorMessage('Failed to load audit data: $e');
      BotToast.showText(text: 'Error loading audit data');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchAuditData() async {
    try {
      var response = await Api().get(
        "audits/booking",
        queryParameters: {'booking_id': bookingId},
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          auditData = BookingAuditModel.fromJson(data);
        }
      }
    } catch (e) {
      print("Error in _fetchAuditData: $e");
    }
  }

  Future<void> _fetchBookingData() async {
    try {
      // Try path param first: bookings/getbyid/$bookingId
      var response = await Api().get("bookings/getbyid/$bookingId");
      if (response == null || response.statusCode != 200) {
        // Fallback to query param
        response = await Api().get(
          "bookings/getbyid",
          queryParameters: {'id': bookingId},
        );
      }

      if (response != null && response.statusCode == 200) {

        final data = response.data;
        if (data is Map<String, dynamic>) {
          bookingDetail = BookingDetailModel.fromJson(data);
        }
      }
    } catch (e) {
      print("Error in _fetchBookingData: $e");
    }
  }

  Future<void> _fetchDriverData(int driverId) async {
    try {
      // Try path param: drivers/getbyid/$driverId
      var response = await Api().get("drivers/getbyid/$driverId");
      if (response == null || response.statusCode != 200) {
        // Fallback to query param
        response = await Api().get(
          "drivers/getbyid",
          queryParameters: {'id': driverId},
        );
      }

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          driverDetail = DriverDetailModel.fromJson(data);
        }
      }
    } catch (e) {
      print("Error in _fetchDriverData: $e");
    }
  }

  void _buildTimelineFromActivities() {
    statusTimeline['ON ROUTE'] = null;
    statusTimeline['ARRIVED'] = null;
    statusTimeline['POB'] = null;
    statusTimeline['COMPLETED'] = null;

    if (auditData == null || auditData!.activities.isEmpty) return;

    for (var act in auditData!.activities) {
      final desc = (act.activityDescription ?? '').toLowerCase();
      final time = act.time;

      if (desc.contains('on route') || desc.contains('en route')) {
        statusTimeline['ON ROUTE'] ??= time;
      } else if (desc.contains('arrived')) {
        statusTimeline['ARRIVED'] ??= time;
      } else if (desc.contains('pob') || desc.contains('passenger on board') || desc.contains('passenger on-board')) {
        statusTimeline['POB'] ??= time;
      } else if (desc.contains('completed')) {
        statusTimeline['COMPLETED'] ??= time;
      }
    }
  }

  Future<void> refresh() => loadAllData();
}
