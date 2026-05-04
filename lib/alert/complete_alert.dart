import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';
import '../view/customer/model/restricDriver.dart';

void showCompleteBookingAlert(int id) {
  Get.dialog(CompleteBookingAlert(bookingId: id),
    barrierColor: Colors.black54,
  );
}

class CompleteBookingAlert extends StatefulWidget {
  final dynamic bookingItem;
  final int bookingId;
  const CompleteBookingAlert({super.key, required this.bookingId, this.bookingItem});

  @override
  State<CompleteBookingAlert> createState() => _CompleteBookingAlertState();
}

class _CompleteBookingAlertState extends State<CompleteBookingAlert> {
  final controller = Get.put(FobController());

  @override
  void initState() {
    super.initState();
    // controller.getAllDrivers;
    controller.getAllDrivers().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    "COMPLETE BOOKING ${widget.bookingItem?.referenceNumber ?? "N/A"}",
                    style: mozillaTextSemiBoldText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT DRIVER",
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                     child: CustomDropdownField<DriverObject>(
                      label: "SELECT DRIVERS",
                      width: 320,
                      height: 35,
                      items: controller.allDriverData?.drivers ?? [],
                      value: controller.selectDriverObject,
                      itemLabel: (driver) =>
                      driver.name ?? "".toUpperCase(),
                      onChanged: (val) {
                        controller.selectDriverObject = val;
                        controller.update();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    width: 80,
                    height: 28,
                    verticalPadding: 0.0,
                    btnText: "BACK",
                    btnColor: Colors.grey,
                    borderRadius: 4,
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold
                    ),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  CustomButton(
                    width: 180, height: 28, verticalPadding: 0.0, borderRadius: 4,
                    btnText: "COMPLETE BOOKING",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    onTap: () {
                      controller.postCompleteBooking(widget.bookingId);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}