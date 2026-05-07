import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/customButton.dart';
import '../component/dropdown_button.dart';
import '../component/textStyle.dart';
import '../controller/fob_controller.dart';
import '../view/customer/model/restricDriver.dart';


void showAllocateDriverAlert() {
  Get.dialog(
    AllocateDriverAlert(),
    barrierColor: Colors.black54,
  );
}

class AllocateDriverAlert extends StatefulWidget {
  final dynamic bookingItem;
  // final dynamic bookingId;
  const AllocateDriverAlert({super.key, this.bookingItem});

  @override
  State<AllocateDriverAlert> createState() => _AllocateDriverAlertState();
}

class _AllocateDriverAlertState extends State<AllocateDriverAlert> {
  List<String> drivers = ["John", "Mark", "Developer"];
  String? selectedDriver;
  final controller = Get.put(FobController());

  @override
  void initState() {
    super.initState();
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
                    "ALLOCATE DRIVER ${widget.bookingItem?.referenceNumber ?? "N/A"}",
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
                    "SELECT DRIVER TO ASSIGN",
                    style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GetBuilder<FobController>(
                        builder: (ctrl) {
                          return CustomDropdownField<String>(
                            label: "SELECT DRIVERS",
                            width: 320,
                            height: 35,
                            items: drivers,
                            value: selectedDriver,
                            itemLabel:(driver) => driver.toUpperCase(),
                            onChanged: (val) {
                              setState(() {
                                selectedDriver = val;
                              });
                            },
                          );
                        }),
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
                    btnText: "CANCEL",
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
                      btnText: "ASSIGN DRIVER",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onTap: () {}
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