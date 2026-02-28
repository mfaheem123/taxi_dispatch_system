import 'package:dashboard_new1/component/customButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../alert/driver_commission_alt.dart';
import '../../../../component/color.dart';
import '../../../../component/datatable_widget.dart';
import '../../../../component/textStyle.dart';
import '../../../../component/text_widget.dart';
import '../../../dashboard_view/Controller/dashboard_controller.dart';
import '../../../dashboard_view/booking_table.dart';
import '../../controller/driver_controller.dart';
import '../../model/driver_commission_model.dart';

class DriverCommission extends StatefulWidget {
  const DriverCommission({super.key});

  @override
  State<DriverCommission> createState() => _DriverCommissionState();
}

class _DriverCommissionState extends State<DriverCommission> {
  int selectedRowIndex = 0; // currently selected row
  // final int totalRows = 5;
  late final totalRows =
      controller.driverCommission?.driverCommissions?.length ?? 1;

  DriverController controller = Get.isRegistered<DriverController>()
      ? Get.find<DriverController>()
      : Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "driversCommission";
    // controller.getDriverCommission();
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          selectedRowIndex = (selectedRowIndex + 1) % totalRows; // move down
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          selectedRowIndex = ((selectedRowIndex - 1 + totalRows) % totalRows);
        }); // move up
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        // DriverCommissionAlt.show();
        // Enter dabane par row ke action button ka kaam
        debugPrint("Row $selectedRowIndex Enter Pressed (Search/Delete)");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: _handleKey,
      child: GetBuilder<DriverController>(initState: (state) async {
        await controller.getDriverCommission();

        if (controller.driverCommission?.driverCommissions?.isNotEmpty ??
            false) {
          var firstDriverId =
              controller.driverCommission!.driverCommissions!.first.driverId;
          controller.getDriverCommissionDetails(firstDriverId);
        }

      }, builder: (controller) {
        final driverList = controller.driverCommission?.driverCommissions ?? [];
        final countList = controller.driverCommission?.count ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppText.driverCommission,
                    style: titleDesign(),
                  ),
                  Text(
                    // "(5)",
                    "(${driverList.length})",
                    style: titleDesign(),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  CustomButton(
                    height: 40,
                    width: 80,
                    verticalPadding: 0.0,
                    borderRadius: 4,
                    widget: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                      child: Icon(
                        Icons.refresh,
                        color: DynamicColors.whiteClr,
                        size: 25,
                      ),
                    ),
                    onTap: () => controller.getDriverCommission(),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: Get.width,
                  child: DatatableWidget(
                    columns: [
                      buildHeaderWithSearch(title: "USERNAME"),
                      buildHeaderWithSearch(title: "NAME"),
                      buildHeaderWithSearch(title: "TYPE"),
                      buildHeaderWithSearch(title: "COMMISSION"),
                      buildHeaderWithSearch(title: "LAST MODIFIED"),
                    ],
                    totalRow: driverList.length,
                    cells: [
                      ...driverList.map((driverItem) {
                        final countItem = countList.firstWhere(
                          (c) => c.driverId == driverItem.driverId,
                          orElse: () => Count(lastModified: "-"),
                        );

                        return DataCell(
                          Center(
                              child: Text(driverItem.driver?.username ?? "-")),
                          onTap: () async {
                            print("Click hua!");
                            await controller.getDriverCommissionDetails(driverItem.driverId);
                            print("Data mil gaya, ab alert khulega");
                            DriverCommissionAlt.show(id: driverItem.driverId ?? 0);
                          },
                        );
                      }).toList(),
                      ...driverList.map((driverItem) {
                        return DataCell(
                          Center(child: Text(driverItem.driver?.name ?? "-")),
                          onTap: () async {
                            await controller.getDriverCommissionDetails(driverItem.driverId);
                            DriverCommissionAlt.show(id: driverItem.driverId ?? 0);
                          },
                        );
                      }).toList(),
                      ...driverList.map((driverItem) {
                        return DataCell(
                          Center(
                              child:
                                  Text(driverItem.driver?.driverType ?? "-")),
                          onTap: () async {
                            await controller.getDriverCommissionDetails(driverItem.driverId);
                            DriverCommissionAlt.show(id: driverItem.driverId ?? 0);
                          },
                        );
                      }).toList(),
                      ...driverList.map((driverItem) {
                        return DataCell(
                          Center(
                              child: Text(
                                  "${driverItem.driver?.driverCommission ?? "0"}%")),
                          onTap: () async {
                            await controller.getDriverCommissionDetails(driverItem.driverId);
                            DriverCommissionAlt.show(id: driverItem.driverId ?? 0);
                          },
                        );
                      }).toList(),
                      ...driverList.map((driverItem) {
                        final countItem = countList.firstWhere(
                          (c) => c.driverId == driverItem.driverId,
                          orElse: () => Count(lastModified: "-"),
                        );
                        return DataCell(
                          Center(child: Text(countItem.lastModified ?? "-")),
                          onTap: () async {
                            await controller.getDriverCommissionDetails(driverItem.driverId);
                            DriverCommissionAlt.show(id: driverItem.driverId ?? 0);
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
