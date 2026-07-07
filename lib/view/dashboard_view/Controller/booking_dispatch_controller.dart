import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import '../../../component/networks/api.dart';
import '../../drivers_view/driver/login_drivers/driver_login_logout_model.dart';
import '../models/dashboard_table_model.dart' hide Driver;
import 'dashboard_controller.dart';
class DispatchController extends GetxController {
  var drivers = <Driver>[].obs;
  var isLoading = false.obs;
  var isAssigning = false.obs; // Isse class ke andar hona chahiye



  void getDispatchDrivers() async {
    try {
      isLoading(true);
      var response = await Api().get("drivers/session?session_status=logged_in", sendCompanyId: true);
      if (response.statusCode == 200) {
        var model = DriverLoginLogoutModel.fromJson(response.data);
        drivers.value = model.drivers ?? [];
      }
    } finally {
      isLoading(false);
    }
  }


  Future<void> assignDriverToBooking(dynamic bookingId, dynamic driverId) async {
    if (bookingId == null || driverId == null) {
      BotToast.showText(text: 'Booking or Driver ID is missing');
      return;
    }
    try {
      isAssigning(true);
      var formData = {
        "booking_id": bookingId.toString(),
        "driver_id": driverId,
      };
      print("Sending Data: $formData");
      var response = await Api().post(
        formData,
        "bookings/assign-driver",
        auth: true,
      );
      if (response.statusCode == 200) {
        BotToast.showText(text: 'Driver Assigned Successfully');
        Get.back();
      } else {
        BotToast.showText(text: response.data['message']);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isAssigning(false);
    }
  }
}