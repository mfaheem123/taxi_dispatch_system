import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../alert/restrict_drivers_alert.dart';
import '../../component/color.dart';
import '../../component/textStyle.dart';
import '../../component/text_widget.dart';
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/widgets/time_picker_widget.dart';
import '../dashboard_view/widgets/user_info_widget.dart';
import 'controller.dart';

class CompleteBookingsScreen extends StatefulWidget {
  const CompleteBookingsScreen({super.key});

  @override
  State<CompleteBookingsScreen> createState() => _CompleteBookingsScreenState();
}

class _CompleteBookingsScreenState extends State<CompleteBookingsScreen> {



  BookingController controller = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());

  int selectedRowIndex = 0; // currently selected row
  final int totalRows = 50;  // total rows (dynamic list ke hisaab se change hoga)

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "completeBookingsScreen";
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
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
              color: const Color(0xFFF7F9FC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Row(
              children: [
              Text(AppText.completeBooking+" (10)",
                style: mozillaTextSemiBoldText(
                    fontWeight: FontWeight.w800,
                    fontSize: 17
                ),
              ),
              SizedBox(
                width: 20,
              ),

              Container(
                decoration: BoxDecoration(
                    color: DynamicColors.primaryClr,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0.0),
                    onPressed: (){

                    }, icon: Icon(Icons.refresh,
                  color: DynamicColors.whiteClr,
                  size: 25,
                )),
              )
              ],
            ),SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CustomTextField(
                          controller: controller.enterKeyboardController,
                        hintText: AppText.enterKeyboard,
                        height: 30,
                        width: fieldWidth/2.5,
                        borderRadius: 4,
                      ),
                      RestrictedDrivers(
                        width: fieldWidth/3,
                        height: 30,
                        padding: 0.0,
                        titleText: "REFERENCE:",
                        driversList: [
                          'NAME',
                          'EMAIL',
                          'MOBILE',
                          'TELEPHONE',
                          'PICKUP',
                          'DROPOFF',
                          'ACCOUNT',
                          'DRIVER',
                        ],
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.date,
                        width: fieldWidth/3,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(),
                        ),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.time,
                        width: fieldWidth/3,
                        child: SizedBox(height: 30, child: CustomTimePicker()),
                      ),
                      Text(AppText.to,
                      style: mozillaTextRegularText(
                        fontSize: 15
                      ),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.date,
                        width: fieldWidth/3,
                        child: SizedBox(
                          height: 30,
                          child: KeyboardDatePicker(),
                        ),
                      ),
                      labeledField(
                        context: context,
                        isMobile: isMobile,
                        label: AppText.time,
                        width: fieldWidth/3,
                        child: SizedBox(height: 30, child: CustomTimePicker()),
                      ),
                      SizedBox(
                        width: fieldWidth/3,
                      ),
                      CustomButton(
                        width: 100,
                        height: 30,
                        borderRadius: 4,
                        btnColor: DynamicColors.redClr,
                        verticalPadding: 0.0,
                        fontSize: 11,
                        btnText: AppText.clear,
                      ),
                      CustomButton(
                        width: 100,
                        height: 30,
                        borderRadius: 4,
                        verticalPadding: 0.0,
                        fontSize: 11,
                        btnText: AppText.search,
                      ),
                    ],
                  ),

                  // 📋 Data Table
                  Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                        columnSpacing: 40,
                        columns: const [
                          DataColumn(label: Text("SOURCE")),
                          DataColumn(label: Text("REF #")),
                          DataColumn(label: Text("DATETIME")),
                          DataColumn(label: Text("CUSTOMER")),
                          DataColumn(label: Text("PICKUP")),
                          DataColumn(label: Text("DROPOFF")),
                          DataColumn(label: Text("ACC")),
                          DataColumn(label: Text("DRV")),
                          DataColumn(label: Text("P/T")),
                          DataColumn(label: Text("VEH")),
                          DataColumn(label: Text("FARE")),
                          DataColumn(label: Text("STATUS")),
                          DataColumn(label: Text("ACTIONS")),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text("OPT")),
                              const DataCell(Text("BCB75044")),
                              const DataCell(Text("26-08-25 06:00")),
                              const DataCell(Text("CUSTOMER")),
                              const DataCell(Text("NORTHWICK AVENUE")),
                              const DataCell(Text("GREEN PARK WAY")),
                              const DataCell(Text("TEST")),
                              const DataCell(Text("TEST")),
                              const DataCell(Text("CASH")),
                              const DataCell(Text("SAL...")),
                              const DataCell(Text("£10.90")),
                              DataCell(Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "COMP",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                              DataCell(
                                Row(
                                  children: const [
                                    Icon(Icons.edit, color: Colors.purple),
                                    SizedBox(width: 8),
                                    Icon(Icons.delete, color: Colors.red),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // ✅ Yahan aur rows add kar sakte ho
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
