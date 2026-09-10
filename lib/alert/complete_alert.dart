import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';
import '../view/customer/model/restricDriver.dart';

class CompleteBookingAlert extends StatefulWidget {
  final dynamic bookingItem;
  final dynamic bookingId;
  const CompleteBookingAlert({super.key, required this.bookingId, this.bookingItem});

  @override
  State<CompleteBookingAlert> createState() => _CompleteBookingAlertState();
}

class _CompleteBookingAlertState extends State<CompleteBookingAlert> {
  final controller = Get.put(FobController());
  final FocusNode closeButtonFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    controller.selectDriverObject = null;
    controller.getAllDrivers();
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.done_all, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: mozillaTextSemiBoldText(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        const TextSpan(text: "COMPLETE BOOKING ("),
                        TextSpan(
                          text: widget.bookingItem?.referenceNumber ?? "N/A",
                          style: TextStyle(color: DynamicColors.primaryClr, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ")"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FocusTraversalOrder(
                    order: const NumericFocusOrder(999),
                    child: const AlertCloseButton(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SELECT DRIVER",
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                     child: GetBuilder<FobController>(
                         builder: (ctrl) {
                           return CustomDropdownField<DriverObject>(
                             label: "SELECT DRIVERS",
                             width: 320,
                             height: 35,
                             items: controller.allDriverData?.drivers ?? [],
                             value: controller.selectDriverObject,
                             itemLabel: (driver) =>
                             "${driver.username} ${driver.name}".toUpperCase(),
                             onChanged: (val) {
                               controller.selectDriverObject = val;
                               controller.update();
                             },
                           );
                         }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
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
                    btnColor: Colors.grey.shade300,
                    borderRadius: 4,
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold
                    ),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: controller.isCompleteStatus
                        ? null
                        : () async {
                      await controller.postCompleteBooking(widget.bookingId);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(
                      Icons.done_all, size: 16),
                    label: Text(
                      controller.isCompleteStatus ? "PROCESSING..." : "COMPLETE BOOKING",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DynamicColors.primaryClr,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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