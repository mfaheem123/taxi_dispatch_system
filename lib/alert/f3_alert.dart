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

  // Initially keeping selected driver as null so "SELECT DRIVER" is active
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

          final currentDriver = localSelectedDriver;
          final bool isDriverSelected = currentDriver != null;
          final String sessionRaw = (currentDriver?.sessionStatus ?? "")
              .toString()
              .toLowerCase()
              .trim()
              .replaceAll(" ", "_");
          final bool isLoggedIn = isDriverSelected &&
              (sessionRaw == "logged_in" || sessionRaw == "login");

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
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
                        // Dropdown with Default "SELECT DRIVER" Option
                        Container(
                          width: 250,
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<DriverObject?>(
                              value: currentDriver,
                              hint: Text(
                                "SELECT DRIVER",
                                style: mozillaTextSemiBoldText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                              style: mozillaTextSemiBoldText(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              items: [
                                // Placeholder Item: SELECT DRIVER
                                DropdownMenuItem<DriverObject?>(
                                  value: null,
                                  child: Text(
                                    "SELECT DRIVER",
                                    style: mozillaTextSemiBoldText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                ...drivers.map((DriverObject driver) {
                                  return DropdownMenuItem<DriverObject?>(
                                    value: driver,
                                    child: Text(
                                      "${driver.username} ${driver.name ?? ''}".trim(),
                                      style: mozillaTextSemiBoldText(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (DriverObject? newValue) {
                                if (newValue != null) {
                                  print("--- DRIVER DEBUG INFO ---");
                                  print("Driver Name: ${newValue.name}");
                                  print("Active Status: ${newValue.active}");
                                  print("Session Status from API: '${newValue.sessionStatus}'");
                                }
                                setState(() {
                                  localSelectedDriver = newValue;
                                  controller.selectedDriver.value = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        const Spacer(),

                        // Logged status text and button show only when a driver is selected
                        if (isDriverSelected) ...[
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
                              // Perform Force Logout
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
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vehicle Info Card
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
                                    color: DynamicColors.primaryClr,
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade500),
                                    ),
                                  ),
                                  child: Text(
                                    "VEHICLE INFO",
                                    style: mozillaTextSemiBoldText(
                                        context: context,
                                        fontSize: 14,
                                        color: DynamicColors.whiteClr
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow(
                                        "VEHICLE #:",
                                        isDriverSelected ? (currentDriver.vehicle?.vehicleNumber ?? "-") : "-",
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow(
                                        "MAKE:",
                                        isDriverSelected ? (currentDriver.vehicle?.make ?? "-") : "-",
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow(
                                        "MODEL:",
                                        isDriverSelected ? (currentDriver.vehicle?.model ?? "-") : "-",
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow(
                                        "TYPE:",
                                        isDriverSelected ? (currentDriver.vehicle?.vehicleType?.name ?? "-") : "-",
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow(
                                        "COLOR:",
                                        isDriverSelected ? (currentDriver.vehicle?.color ?? "-") : "-",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Driver Info Card
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
                                    color: DynamicColors.primaryClr,
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade500),
                                    ),
                                  ),
                                  child: Text(
                                    "DRIVER INFO",
                                    style: mozillaTextSemiBoldText(
                                        context: context,
                                        fontSize: 14,
                                        color: DynamicColors.whiteClr
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
                                              isDriverSelected ? (currentDriver.mobile ?? "-") : "-",
                                              style: mozillaTextRegularText(
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isDriverSelected)
                                            GestureDetector(
                                              onTap: () {},
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
                                      _buildInfoRow(
                                        "TELEPHONE #:",
                                        isDriverSelected ? (currentDriver.telephone ?? "-") : "-",
                                      ),
                                      const SizedBox(height: 14),
                                      _buildInfoRow(
                                        "ADDRESS:",
                                        isDriverSelected ? (currentDriver.address ?? "-") : "-",
                                      ),
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