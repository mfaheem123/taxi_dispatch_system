import 'package:dashboard_new1/component/networks/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/dispatch_booking_alert_model.dart';
import '../component/customButton.dart';
import '../component/textStyle.dart';
import '../view/drivers_view/driver/login_drivers/driver_login_logout_model.dart';

class DispatchBooking extends StatefulWidget {
  const DispatchBooking({super.key});

  @override
  State<DispatchBooking> createState() => _DispatchBookingState();
}

class _DispatchBookingState extends State<DispatchBooking> {
  DriverLoginLogoutModel? driverLoginLogoutModel;
  List<Driver> drivers = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDispatchDrivers();
  }

  getDispatchDrivers() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await Api().get("drivers/session?session_status=logged_in");

      if (response.statusCode == 200) {
        setState(() {
          driverLoginLogoutModel = DriverLoginLogoutModel.fromJson(response.data);
          drivers = driverLoginLogoutModel?.drivers ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching drivers: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.only(top: 100, left: 40, right: 40),
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DISPATCH BOOKING (1025)",
                      style: mozillaTextSemiBoldText(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child:
                          const Icon(Icons.close, size: 22, color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SELECT DRIVER TO DISPATCH",
                      style: mozillaTextSemiBoldText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    CustomButton(
                      width: 165,
                      height: 35,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      btnText: "CALCULATE DISTANCE",
                      style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : drivers.isEmpty
                        ? const Center(child: Text("No Drivers Found"))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowHeight: 45,
                              columnSpacing: 25,
                              headingRowColor:
                                  WidgetStateProperty.all(Colors.grey.shade50),
                              border: TableBorder.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                              columns: [
                                DataColumn(
                                    label: Text("ID",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("DRIVER NAME",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("SUBSIDIARY",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("STATUS",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("ATTRIBUTES",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("DISTANCE",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                                DataColumn(
                                    label: Text("ACTION",
                                        style: mozillaTextSemiBoldText(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                              ],
                                rows: drivers.map((driver) {
                                  return DataRow(
                                        cells: [
                                          DataCell(Text("${driver.id ?? ''}",
                                              style: mozillaTextRegularText(
                                                  fontSize: 14))),
                                          DataCell(Text(driver.name ?? '',
                                              style: mozillaTextRegularText(
                                                  fontSize: 14))),
                                          DataCell(Text(driver.subsidiary?.name ?? '',
                                              style: mozillaTextRegularText(
                                                  fontSize: 14))),
                                          DataCell(Text(driver.bookingStatus ?? '',
                                              style: mozillaTextRegularText(
                                                  fontSize: 14,
                                                  color: Colors.green))),
                                          DataCell(Center(
                                              child: Text("-",
                                                  style: mozillaTextRegularText(
                                                      fontSize: 14)))),
                                          DataCell(Center(
                                              child: Text("-",
                                                  style: mozillaTextRegularText(
                                                      fontSize: 14)))),
                                          DataCell(
                                            Center(
                                              child: CustomButton(
                                                width: 80,
                                                height: 28,
                                                verticalPadding: 0.0,
                                                borderRadius: 4,
                                                btnText: "DISPATCH",
                                                style: mozillaTextSemiBoldText(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                }).toList(),
                                  ),
                            ),
                SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 80,
                      height: 28,
                      btnText: "CLOSE",
                      btnColor: Colors.grey.shade600,
                      verticalPadding: 0.0,
                      borderRadius: 4,
                      onTap: () => Get.back(),
                      style: mozillaTextSemiBoldText(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
