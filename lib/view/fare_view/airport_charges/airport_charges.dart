
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/color.dart';
import '../../../component/datatable_widget.dart';
import '../../../component/textStyle.dart';
import '../../../component/text_widget.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import '../controller/controller.dart';

class AirportCharges extends StatefulWidget {
  const AirportCharges({super.key});

  @override
  State<AirportCharges> createState() => _AirportChargesState();
}

class _AirportChargesState extends State<AirportCharges> {

  FareController controller = Get.isRegistered<FareController>()
      ? Get.find<FareController>()
      : Get.put(FareController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50; // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "airportCharges";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FareController>(
        initState: (v){
          controller.getAllAirPortCharges();
        },
        builder: (controller) {
      return LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;
            final bool isMobile = maxWidth < 600;
            final bool isTablet = maxWidth >= 600 && maxWidth < 1024;

            // Instead of fixed width, we calculate flexible field widths
            final double fieldWidth = isMobile
                ? maxWidth // full width
                : isTablet
                ? maxWidth / 2
                : maxWidth / 4;

            return Container(
              width: Get.width/1.5,
              decoration: BoxDecoration(
                  border: Border.all(color: DynamicColors.gryClr)
              ),
              child: controller.getAllAirPortChargesLoader.value== false?Center(
                child: CircularProgressIndicator(),
              ): Column(
                children: [
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    color: DynamicColors.gryClr.withOpacity(0.5),
                    child: Text(AppText.airportCharges, style: titleDesign()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: Get.height/1.2,
                    child: SingleChildScrollView(
                      child: DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                          dataRowMinHeight: 48,
                          dataRowMaxHeight: 56,
                          headingTextStyle: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),

                          dataTextStyle: TextStyle(

                          ),

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: DynamicColors.textClr.withOpacity(0.5))
                          ),

                          columns: [
                            buildHeaderWithSearch(title: "AIRPORTS",removeSearching: true),
                            buildHeaderWithSearch(title: "PICKUP CHARGES",removeSearching: true),
                            buildHeaderWithSearch(title: "DROPOFF CHARGES",removeSearching: true),
                            buildHeaderWithSearch(title: "ACTIONS",removeSearching: true),
                          ],

                        rows: [
                          /// 🔍 Search row (only on top)
                          DataRow(
                            color: MaterialStateProperty.all(Colors.grey[100]),
                            cells: [
                              DataCell(
                                Text(""),
                              ),
                              DataCell(
                                CustomTextField(
                                  columnText: false,
                                  controller: controller.pickUpChargesController,
                                  width: fieldWidth/2,
                                  hintText: "FROM",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),
                              DataCell(
                                CustomTextField(
                                  columnText: false,
                                  controller: controller.pickUpChargesController,
                                  width: fieldWidth/2,
                                  hintText: "TO",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),

                              DataCell(
                                CustomTextField(
                                  columnText: false,
                                  controller: controller.dropOffChargesController,
                                  width: fieldWidth/2,
                                  hintText: "FARES",
                                  prefixIcon: Icon(Icons.search),
                                ),
                              ),

                              DataCell(
                                CustomButton(
                                  height: 35,
                                  width: 80,
                                  verticalPadding: 0.0,
                                  borderRadius: 4,
                                  onTap: (){
                                    controller.editAirPortCharge();
                                  },
                                  widget: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                                    child:  Text(
                                      AppText.save,
                                      style: mozillaTextRegularText(
                                          fontSize: 12, color: DynamicColors.whiteClr),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                          /// 🔽 Normal data rows
                          ...List.generate(controller.airportChargesData!.locations!.length, (index) {
                            return DataRow(
                              cells: [

                                DataCell(Text(controller.airportChargesData!.locations![index].name.toString())),
                                DataCell(Text(controller.airportChargesData!.locations![index].pickupCharges!)),
                                DataCell(Text(controller.airportChargesData!.locations![index].dropoffCharges!)),
                                DataCell(
                                  Row(
                                    children: [
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                        ),
                                        onPressed: () {
                                          controller.pickUpChargesController.text = controller.airportChargesData!.locations![index].pickupCharges.toString();
                                          controller.dropOffChargesController.text = controller.airportChargesData!.locations![index].dropoffCharges.toString();
                                          controller.airPortSelectedItemId = controller.airportChargesData!.locations![index].id;
                                          controller.update();
                                        },
                                        child: Icon(
                                          Icons.edit_calendar,
                                          size: 28,
                                          color: DynamicColors.primaryClr,
                                        ),
                                      ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.transparent),
                                        ),
                                        onPressed: () {
                                          controller.clearAirPortCharges(controller.airportChargesData!.locations![index].id);
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          size: 28,
                                          color: DynamicColors.redClr,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
