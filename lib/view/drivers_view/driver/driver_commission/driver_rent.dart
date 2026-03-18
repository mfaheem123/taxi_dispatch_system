import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/driver_rent_alt.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/networks/api.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';
import '../../model/driver_rent_model.dart';

class DriverRent extends StatefulWidget {
  const DriverRent({super.key});

  @override
  State<DriverRent> createState() => _DriverRentState();
}
class _DriverRentState extends State<DriverRent> {
  int selectedRowIndex = 0;

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  // Null safety check for totalRows
  int get totalRows => controller.listDriverRentModel?.driverRents?.length ?? 0;

  String getLastModified(int? driverId, List<Count>? countList) {
    if (driverId == null || countList == null) return "-";
    try {
      // Searching for matching driverId in count list
      final item = countList.firstWhere((e) => e.driverId == driverId);
      return item.lastModified?.split("T").first ?? "-";
    } catch (e) {
      return "-";
    }
  }

  @override
  void initState() {
    super.initState();
    // Assuming shortCutKeyValue is a global Rx variable
    shortCutKeyValue.value = "driverRent";
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent && totalRows > 0) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex = (selectedRowIndex - 1 + totalRows) % totalRows;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        debugPrint("Row $selectedRowIndex Enter Pressed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<DriverController>(
        initState: (state) {
          controller.getDriverRent();
        },
        builder: (controller) {
          final driverRentList = controller.listDriverRentModel?.driverRents ?? [];
          final countList = controller.listDriverRentModel?.count ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${AppText.driverRent} (${driverRentList.length})",
                      style: mozillaTextSemiBoldText(
                          fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                    const SizedBox(width: 60),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: CustomButton(
                        height: 40,
                        width: 80,
                        onTap: () => controller.getDriverRent(), // Refresh logic
                        verticalPadding: 0.0,
                        borderRadius: 4,
                        widget: Icon(
                          Icons.refresh,
                          color: DynamicColors.whiteClr,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: Get.width,
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(title: "USERNAME"),
                      buildHeaderWithSearch(title: "NAME"),
                      buildHeaderWithSearch(title: "TYPE"),
                      buildHeaderWithSearch(title: "RENT"),
                      buildHeaderWithSearch(title: "LAST MODIFIED"),
                    ],
                    totalRow: driverRentList.length,
                    rows: List<DataRow>.generate(driverRentList.length, (index) {
                      final driverRent = driverRentList[index];
                      final driver = driverRent.driver;
                      final lastModified = getLastModified(driverRent.driverId, countList);

                      return DataRow(
                        selected: selectedRowIndex == index,
                        cells: [
                          DataCell(
                            Center(child: Text(driverRent.driverId?.toString() ?? "0")),
                            onTap: () => _onRowTap(driverRent.driverId),
                          ),
                          DataCell(
                            Center(child: Text(driver?.name ?? "-")),
                            onTap: () => _onRowTap(driverRent.driverId),
                          ),
                          DataCell(
                            Center(child: Text(driver?.driverType ?? "-")),
                            onTap: () => _onRowTap(driverRent.driverId),
                          ),
                          DataCell(
                            Center(child: Text(driver?.driverRent?.toString() ?? "0")),
                            onTap: () => _onRowTap(driverRent.driverId),
                          ),
                          DataCell(
                            Center(child: Text(lastModified)),
                            onTap: () => _onRowTap(driverRent.driverId),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method
  void _onRowTap(int? driverId) async {
    if (driverId != null) {
      await controller.getDriverRentDetails(driverId);
      DriverRentAlt.show(id: driverId);
    }
  }
}

// class _DriverRentState extends State<DriverRent> {
//   int selectedRowIndex = 0;
//
//   DriverController controller = Get.isRegistered<DriverController>()
//       ? Get.find<DriverController>()
//       : Get.put(DriverController());
//
//   int get totalRows => controller.listDriverRentModel?.driverRents?.length ?? 0;
//
//   String getLastModified(int? driverId, List<Count> countList) {
//     if (driverId == null || countList == null) return "-";
//     try {
//       final item = countList.firstWhere((e) => e.driverId == driverId);
//       return item.lastModified?.split("T").first ?? "-";
//     } catch (e) {
//       return "-";
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     shortCutKeyValue.value = "driverRent";
//   }
//
//   void _handleKey(RawKeyEvent event) {
//     if (event is RawKeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//         setState(() {
//           selectedRowIndex = (selectedRowIndex + 1) % totalRows;
//         });
//       } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//         setState(() {
//           selectedRowIndex = (selectedRowIndex - 1 + totalRows) % totalRows;
//         });
//       } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//         debugPrint("Row $selectedRowIndex Enter Pressed");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return RawKeyboardListener(
//       autofocus: true,
//       focusNode: FocusNode(),
//       onKey: _handleKey,
//       child: GetBuilder<DriverController>(initState: (state) {
//         controller.getDriverRent();
//
//         if (controller.listDriverRentModel?.driverRents?.isNotEmpty ??
//             false) {
//           var DriverId =
//               controller.listDriverRentModel!.driverRents?.first.driverId;
//           controller.getDriverRentDetails(DriverId);
//         }
//       }, builder: (controller) {
//         final driverRentList =
//             controller.listDriverRentModel?.driverRents ?? [];
//
//         final countList = controller.listDriverRentModel?.count ?? [];
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     "${AppText.driverRent} (${driverRentList.length})",
//                     style: mozillaTextSemiBoldText(
//                         fontWeight: FontWeight.w800, fontSize: 17),
//                   ),
//                   SizedBox(width: 60),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 12),
//                     child: CustomButton(
//                       height: 40,
//                       width: 80,
//                       verticalPadding: 0.0,
//                       borderRadius: 4,
//                       widget: Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
//                         child: Icon(
//                           Icons.refresh,
//                           color: DynamicColors.whiteClr,
//                           size: 25,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               SingleChildScrollView(
//                 child: SizedBox(
//                   width: Get.width,
//                   child: DatatableWidget(
//                     columns: [
//                       buildHeaderWithSearch(title: "USERNAME"),
//                       buildHeaderWithSearch(title: "NAME"),
//                       buildHeaderWithSearch(title: "TYPE"),
//                       buildHeaderWithSearch(title: "RENT"),
//                       buildHeaderWithSearch(title: "LAST MODIFIED"),
//                     ],
//                     totalRow: driverRentList.length,
//                     rows: driverRentList.map((driverRent) {
//                       final driver = driverRent.driver;
//
//                       final lastModified =
//                           getLastModified(driverRent.driverId, countList);
//
//                       return DataRow(
//                         cells: [
//                           DataCell(
//                             Center(child: Text(driverRent.driverId.toString())),
//                             onTap: () async {
//                               await controller
//                                   .getDriverRentDetails(driverRent.driverId);
//                               DriverRentAlt.show(id: driverRent.driverId ?? 0);
//                             },
//                           ),
//                           DataCell(
//                             Center(child: Text(driver.name)),
//                             onTap: () async {
//                               await controller
//                                   .getDriverRentDetails(driverRent.driverId);
//                               DriverRentAlt.show(id: driverRent.driverId ?? 0);
//                             },
//                           ),
//                           DataCell(
//                             Center(child: Text(driver.driverType)),
//                             onTap: () async {
//                               await controller
//                                   .getDriverRentDetails(driverRent.driverId);
//                               DriverRentAlt.show(id: driverRent.driverId ?? 0);
//                             },
//                           ),
//                           DataCell(
//                             Center(child: Text(driver.driverRent.toString())),
//                             onTap: () async {
//                               await controller
//                                   .getDriverRentDetails(driverRent.driverId);
//                               DriverRentAlt.show(id: driverRent.driverId ?? 0);
//                             },
//                           ),
//                           DataCell(
//                             Center(child: Text(lastModified)),
//                             onTap: () async {
//                               await controller
//                                   .getDriverRentDetails(driverRent.driverId);
//                               DriverRentAlt.show(id: driverRent.driverId ?? 0);
//                             },
//                           ),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
