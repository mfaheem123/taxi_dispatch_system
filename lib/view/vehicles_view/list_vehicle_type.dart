import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/view/vehicles_view/model/vehicle_type_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/color.dart';
import '../../component/datatable_widget.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/booking_table.dart';
import 'controller.dart';

class ListVehicleType extends StatefulWidget {
  const ListVehicleType({super.key});

  @override
  State<ListVehicleType> createState() => _ListVehicleTypeState();
}

class _ListVehicleTypeState extends State<ListVehicleType> {
  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 5; // total rows (dynamic list ke hisaab se change hoga)

  VehicleController controller = Get.isRegistered<VehicleController>()
      ? Get.find<VehicleController>()
      : Get.put(VehicleController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortCutKeyValue.value = "listVehicleType";
    controller.getVehicleTypes();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double width = WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    return GetBuilder<VehicleController>(builder: (controller) {
      return LayoutBuilder(builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isMobile = maxWidth < 600;
        final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

        // Instead of fixed width, we calculate flexible field widths
        final double fieldWidth = isMobile
            ? maxWidth // full width
            : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

        return controller.isLoading.value == true
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppText.vehicleType + " (10)",
                          style: mozillaTextSemiBoldText(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: CustomButton(
                            height: 40,
                            width: 80,
                            verticalPadding: 0.0,
                            borderRadius: 4,
                            onTap: () {
                              Future.delayed(const Duration(seconds: 10), () {
                                controller.getVehicleTypes();
                                print(
                                    "Refresh ho rha hai -------------- ${controller.getVehicleTypes}");
                              });
                            },
                            widget: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0.0),
                              child: Icon(
                                Icons.refresh,
                                color: DynamicColors.whiteClr,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: Get.width,
                        child: DatatableWidget(
                          columns: [
                            buildHeaderWithSearch(title: AppText.vehicleType),
                            buildHeaderWithSearch(title: "PASSENGERS"),
                            buildHeaderWithSearch(title: "LUGGAGES"),
                            buildHeaderWithSearch(title: "HAND LUGGAGES"),
                            buildHeaderWithSearch(title: "MINIMUM FARES"),
                            buildHeaderWithSearch(title: "MINIMUM MILES"),
                            buildHeaderWithSearch(
                                title: "ACTIONS", removeSearching: true),
                          ],
                          totalRow: controller
                                  .vehicleTypeModel!.vehicleTypes!.length ??
                              0,

                          rows:
                              (controller.vehicleTypeModel!.vehicleTypes ?? [])
                                  .map((item) {
                            return DataRow(cells: [
                              DataCell(Center(child: Text(item.name!))),
                              DataCell(Center(
                                  child: Text(item.passengers.toString()))),
                              DataCell(Center(
                                  child: Text(item.luggages.toString()))),
                              DataCell(Center(
                                  child: Text(item.handLuggages.toString()))),
                              DataCell(Center(child: Text(item.minimumFares!))),
                              DataCell(Center(child: Text(item.minimumMiles!))),
                              DataCell(
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(24, 24),
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () {},
                                        child:
                                            Icon(Icons.edit_calendar, size: 20),
                                      ),
                                      const SizedBox(width: 4),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(24, 24),
                                          side: BorderSide.none,
                                        ),
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.delete_forever,
                                          size: 20,
                                          color: DynamicColors.redClr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),

                         
                        ),
                      ),
                    ),
                  ],
                ),
              );
      });
    });
  }
}
