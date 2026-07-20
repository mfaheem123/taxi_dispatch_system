import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/component/text_widget.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_alert_controller.dart';
import '../view/customer/model/restricDriver.dart';

void showDriverInfoAlert() {
  final controller = Get.put(DashboardAlertController());
  controller.fetchRestrictedDrivers();

  Get.dialog(
    const DriverInfoAlert(),
    barrierColor: Colors.black54,
  );
}

class DriverInfoAlert extends StatefulWidget {
  const DriverInfoAlert({super.key});

  @override
  State<DriverInfoAlert> createState() => _DriverInfoAlertState();
}

class _DriverInfoAlertState extends State<DriverInfoAlert> {
  final controller = Get.find<DashboardAlertController>();
  DriverObject? localSelectedDriver;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 650,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Obx(() {
          if (controller.isRestrictedDriverLoading.value) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final drivers = controller.fetchDriver?.drivers ?? [];
          if (drivers.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  "No Drivers Found",
                  style: mozillaTextSemiBoldText(fontSize: 16),
                ),
              ),
            );
          }

          final currentDriver = localSelectedDriver ?? controller.selectedDriver.value ?? drivers.first;

          final String sessionRaw = (currentDriver.sessionStatus ?? "").toString().toLowerCase().trim();
          final bool isLoggedIn = (currentDriver.active == true) ||
              (sessionRaw == "login") ||
              (sessionRaw == "online") ||
              (sessionRaw == "active");

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      AppText.driverInfo,
                      style: mozillaTextSemiBoldText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
              Divider(height: 1, color: Colors.grey.shade500),


              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    Row(
                      children: [
                        Container(
                          width: 250,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<DriverObject>(
                              value: drivers.contains(currentDriver) ? currentDriver : drivers.first,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                              style: mozillaTextSemiBoldText(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              items: drivers.map((DriverObject driver) {
                                return DropdownMenuItem<DriverObject>(
                                  value: driver,
                                  child: Text(
                                    "${driver.id} ${driver.name ?? ''}".trim(),
                                    style: mozillaTextSemiBoldText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (DriverObject? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    localSelectedDriver = newValue;
                                    controller.selectedDriver.value = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const Spacer(),

                        Text(
                          isLoggedIn ? "LOGGED IN" : "LOGGED OUT",
                          style: mozillaTextSemiBoldText(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isLoggedIn ? DynamicColors.greenClr : DynamicColors.redClr,
                          ),
                        ),
                        const SizedBox(width: 16),

                        CustomButton(
                          onTap: () {
                          },
                          width: 130,
                          height: 38,
                          btnText: "FORCE LOGOUT",
                          btnColor: DynamicColors.redClr,
                          borderRadius: 4,
                          verticalPadding: 0.0,
                          fontSize: 12,
                          style: mozillaTextSemiBoldText(
                            fontSize: 12,
                            color: DynamicColors.whiteClr,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle Info
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade500),
                                    ),
                                  ),
                                  child: Text(
                                    "VEHICLE INFO",
                                    style: mozillaTextSemiBoldText(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: DynamicColors.primaryClr,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow("VEHICLE #:", currentDriver.vehicle?.vehicleNumber ?? "-"),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("MAKE:", currentDriver.vehicle?.make ?? "-"),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("MODEL:", currentDriver.vehicle?.model ?? "-"),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("TYPE:", currentDriver.vehicle?.vehicleType?.name ?? "-"),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("COLOR:", currentDriver.vehicle?.color ?? "-"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Driver Info
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade500),
                                    ),
                                  ),
                                  child: Text(
                                    "DRIVER INFO",
                                    style: mozillaTextSemiBoldText(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "MOBILE #: ",
                                            style: mozillaTextSemiBoldText(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              currentDriver.mobile ?? "-",
                                              style: mozillaTextRegularText(
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                            },
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: DynamicColors.greenClr,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.phone,
                                                color: DynamicColors.whiteClr,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("TELEPHONE #:", currentDriver.telephone ?? "-"),
                                      const SizedBox(height: 14),
                                      _buildInfoRow("ADDRESS:", currentDriver.address ?? "-"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: mozillaTextSemiBoldText(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: mozillaTextRegularText(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}